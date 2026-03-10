interface interfac(input logic clk);

//reset
logic rst;

//transmitter
logic ena_Tx;
logic [2:0] sel;
logic [7:0] data_in_Tx;
logic data_out_Tx;
logic busy_Tx;
logic err_Tx;

//reciever
    logic data_in_Rx;
    logic[7:0] data_out_Rx;
    logic err_Rx;
    logic busy_Rx;
    logic ena_Rx;
//baud_rate 
    logic err_baud;
    logic tick;
    logic ena_baud;
    
clocking drv_cb @(posedge clk);
        output ena_baud;
        output sel;
        output data_in_Tx;
        output ena_Tx;
        output rst;
        output  data_in_Rx;
        output  ena_Rx;
        
        input  busy_Tx;
        input  busy_Rx;
        input  err_Tx;
        input  err_Rx;
        input  err_baud;
        input  data_out_Tx;
        input  data_out_Rx;
        input  tick;
endclocking

clocking mon_cb @(posedge clk);
        input data_out_Tx;
        input busy_Tx;
        input err_Tx;
        input data_out_Rx;
        input busy_Rx;
        input err_Rx;
        input err_baud;
        input tick;
endclocking
    
modport DUT(
    input rst,
    input clk,
    input ena_baud,
    input ena_Tx,
    input ena_Rx,
    input sel,
    input data_in_Tx,
    input data_in_Rx,
    output data_out_Tx,
    output data_out_Rx,
    output err_baud,
    output err_Tx,
    output err_Rx,
    output busy_Tx,
    output busy_Rx,
    output tick
);
    
    
    modport DRIVER (clocking drv_cb);
    modport MONITOR (clocking mon_cb);
    
endinterface