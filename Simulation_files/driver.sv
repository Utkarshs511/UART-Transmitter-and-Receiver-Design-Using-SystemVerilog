//class driver;

//    virtual interfac.DRIVER vif;

//    // Constructor
//    function new(virtual interfac.DRIVER vif);
//        this.vif = vif;
//    endfunction

//    // Reset Task
//    task reset();
//        vif.drv_cb.rst <= 1;
//        repeat (5) @(vif.drv_cb);
//        vif.drv_cb.rst <= 0;
//    endtask

//    // Initialize UART
//    task init();
//        vif.drv_cb.ena_baud <= 1;
//        vif.drv_cb.ena_Tx   <= 1;
//        vif.drv_cb.ena_Rx   <= 1;
//        vif.drv_cb.sel      <= 3'b000; // baud select
//    endtask

//    // Send One Byte
//    task send_byte(input [7:0] data);

//        // Wait if transmitter busywait
//        wait(vif.drv_cb.busy_Tx == 1);

//        // Apply data
//        vif.drv_cb.data_in_Tx <= data;
//        vif.drv_cb.ena_Tx     <= 1;

//        @(vif.drv_cb);

//        vif.drv_cb.ena_Tx <= 0;

//        // Wait until transmission completes
//        wait (vif.drv_cb.busy_Tx == 0);

//    endtask

//endclass