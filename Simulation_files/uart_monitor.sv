//class uart_monitor;

//    virtual interfac.MONITOR vif;
//    mailbox tx_mb;
//    mailbox rx_mb;

//    // Constructor
//    function new(virtual interfac.MONITOR vif, mailbox tx_mb, mailbox rx_mb);
//        this.vif = vif;
//        this.tx_mb = tx_mb;
//        this.rx_mb = rx_mb;

//    endfunction

//    // Monitor RX Data   
//    task monitor_rx();

//        forever begin
//            @(vif.mon_cb);

//            // Check when receiver finishes
//            if (vif.mon_cb.busy_Rx == 0 && 
//                vif.mon_cb.data_out_Rx !== 8'bx) begin
//                rx_mb.put(vif.mon_cb.data_out_Rx);
//                $display("MONITOR: Received Data = %0h at time %0t",
//                          vif.mon_cb.data_out_Rx, $time);
//            end
//        end

//    endtask


//    // Monitor TX Activity
//    task monitor_tx();

//        forever begin
//            @(vif.mon_cb);

//            if (vif.mon_cb.busy_Tx == 0 &&  vif.mon_cb.data_out_Tx !== 8'bx)begin
//                tx_mb.put(vif.mon_cb.data_out_Tx);
//                $display("MONITOR: TX Busy at %0t", $time);
//            end
//        end
//    endtask

//endclass