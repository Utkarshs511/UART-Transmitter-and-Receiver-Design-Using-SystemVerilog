class uart_transaction;

    rand byte data;

    function void display();
        $display("GEN: Generated Data = %0h at time %0t", data, $time);
    endfunction

endclass

class uart_generator;
    mailbox gen2drv;
    int num_packets = 20;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        uart_transaction tr;

        repeat (num_packets) begin
            tr = new();
            assert(tr.randomize());
            tr.display();
            gen2drv.put(tr);
        end
    endtask

endclass


class driver;

    virtual interfac.DRIVER vif;
    mailbox gen2drv;
    mailbox exp_mb;
    // Constructor
    function new(virtual interfac.DRIVER vif, mailbox gen2drv, mailbox exp_mb);
        this.vif = vif;
        this.gen2drv = gen2drv;
        this.exp_mb = exp_mb;
    endfunction

    task run();
        uart_transaction tr;
        byte pkt;
        forever begin
            gen2drv.get(tr);            
            send_byte(tr.data);
            
        end
    endtask
    
     task reset();
        vif.drv_cb.rst <= 1;
        repeat (1) @(vif.drv_cb);
        vif.drv_cb.rst <= 0;
    endtask

    task init();
        vif.drv_cb.ena_baud <= 1;
        vif.drv_cb.ena_Tx   <= 1;
        vif.drv_cb.ena_Rx   <= 1;
        vif.drv_cb.sel      <= 3'b100;
    endtask
    
    // Send One Byte
    task send_byte(input [7:0] data);

        // Wait if transmitter busywait
       wait(vif.drv_cb.busy_Tx == 0);

        vif.drv_cb.data_in_Tx <= data;

        @(vif.drv_cb);
            exp_mb.put(data);
            $display("DRV->EXP_MB PUT : %0h time=%0t", data, $time);
            wait(vif.drv_cb.busy_Tx == 1);


    endtask

endclass

class uart_monitor;

    virtual interfac.MONITOR vif;
    mailbox rx_mb;

    // Constructor
    function new(virtual interfac.MONITOR vif, mailbox rx_mb);
        this.vif = vif;
        this.rx_mb = rx_mb;
        $display("MONITOR CREATED at time %0t", $time);

    endfunction

    // Monitor RX Data   
    task monitor_rx();
        bit prev_Tx_busy;
        bit prev_Rx_busy;
        bit curr_Tx_busy;
        bit curr_Rx_busy;
        byte Tx_count=0;
        byte Rx_count=0;
    
    prev_Tx_busy = 0;
    prev_Rx_busy = 0;
    forever begin
        @(vif.mon_cb);
        curr_Rx_busy = vif.mon_cb.busy_Rx;
        curr_Tx_busy = vif.mon_cb.busy_Tx;
        // Detect falling edge
        if(vif.mon_cb.err_baud)begin
            $display("error in baud Rate");
        end
        if(vif.mon_cb.err_Tx) begin
            $display("error in transmitter at time %0t", $time);
        end
        if(vif.mon_cb.err_Rx) begin
            $display("error in reciever");
        end
        
        if (prev_Rx_busy == 1 && curr_Rx_busy == 0) begin

            rx_mb.put(vif.mon_cb.data_out_Rx);
            Rx_count++;
            $display("MONITOR: Received Data = %0h at time %0t, %d",
                     vif.mon_cb.data_out_Rx, $time, Rx_count);
        end
        if (prev_Tx_busy==1 && curr_Tx_busy==0) begin
            Tx_count++;
            $display("MONITOR: Data is Transmitted,%d", Tx_count);
        end
        prev_Tx_busy = vif.mon_cb.busy_Tx;
        prev_Rx_busy = vif.mon_cb.busy_Rx;
    end

    endtask
endclass

class uart_scoreboard;

    // Mailboxes
    mailbox exp_mb;
    mailbox rx_mb;
    byte tx_queue[$];
    byte rx_queue[$];
    byte tx,rx;

    // Constructor
    function new(mailbox exp_mb, mailbox rx_mb);
        this.exp_mb = exp_mb;
        this.rx_mb = rx_mb;
    endfunction


    task run();

        byte tx_data;
        byte rx_data;

        forever begin

            // collect expected data
            if(exp_mb.try_get(tx)) begin
                tx_queue.push_back(tx);
            end

            // collect received data
            if(rx_mb.try_get(rx)) begin
                rx_queue.push_back(rx);
            end

            // compare when both available
            if(tx_queue.size() > 0 && rx_queue.size() > 0) begin

                tx_data = tx_queue.pop_front();
                rx_data = rx_queue.pop_front();

                if(tx_data == rx_data)begin
                    $display("=>SCOREBOARD: PASS | TX=%0h RX=%0h time=%0t",
                              tx_data, rx_data, $time);
                    $display("DRV->EXP_MB PUT  in Scorecard: %0h time=%0t", tx_data, $time);
                end
                else begin
                    $display("=>SCOREBOARD: FAIL | TX=%0h RX=%0h time=%0t",
                              tx_data, rx_data, $time);
                    $display("DRV->RX_MB PUT  in Scorecard: %0h time=%0t", rx_data, $time);
                              
                end
            end

            #1;
        end

    endtask

endclass

class environment;

    // Virtual Interface
    virtual interfac vif;

    // Components
    driver           drv;
    uart_monitor     mon;
    uart_scoreboard  sb;
    uart_generator gen;
    
    // Mailboxes
    mailbox gen2drv;
    mailbox exp_mb;
    mailbox rx_mb;

    // Constructor
    function new(virtual interfac vif);

        this.vif = vif;

        // Create mailboxes
        gen2drv = new();
        exp_mb = new();
        rx_mb = new();

        // Create components
        gen = new(gen2drv);
        drv = new(vif, gen2drv,exp_mb);
        mon = new(vif,  rx_mb);
        sb  = new(exp_mb, rx_mb);

    endfunction


     //Run all components
    task run();
        fork
            gen.run();
            drv.run();
            mon.monitor_rx();
            sb.run();
        join_none

    endtask

endclass

class uart_test;

    environment env;

    function new(virtual interfac vif);
        env = new(vif);
    endfunction

    task run();

        env.drv.reset();
        env.drv.init();

        env.run();

        #10000;

    endtask

endclass








