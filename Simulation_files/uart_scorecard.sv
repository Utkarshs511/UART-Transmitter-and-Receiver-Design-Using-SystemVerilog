//class uart_scoreboard;

//    // Mailboxes
//    mailbox tx_mb;
//    mailbox rx_mb;

//    // Constructor
//    function new(mailbox tx_mb, mailbox rx_mb);
//        this.tx_mb = tx_mb;
//        this.rx_mb = rx_mb;
//    endfunction


//    task run();

//        byte tx_data;
//        byte rx_data;

//        forever begin

//            // Get transmitted data
//            tx_mb.get(tx_data);

//            // Get received data
//            rx_mb.get(rx_data);

//            if (tx_data == rx_data)
//                $display("SCOREBOARD: PASS | TX = %0h RX = %0h at time %0t",
//                          tx_data, rx_data, $time);
//            else
//                $display("SCOREBOARD: FAIL | TX = %0h RX = %0h at time %0t",
//                          tx_data, rx_data, $time);

//        end

//    endtask

//endclass