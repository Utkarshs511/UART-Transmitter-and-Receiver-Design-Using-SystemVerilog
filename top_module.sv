`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2025 22:07:45
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_module(
    input rst,
    input clk,
    input ena_baud,
    input ena_Tx,
    input ena_Rx,
    input[3:0] sel,
    input [7:0] data_in_Tx,
    input data_in_Rx,
    output data_out_Tx,
    output [7:0] data_out_Rx,
    output err_baud,
    output err_Tx,
    output err_Rx,
    output busy_Tx,
    output busy_Rx,
    output logic tick
    );
    baud_rate_generator uut1(.enable(ena_baud),.clk(clk),.rst(rst),.sel(sel),.tick(tick),.err(err_baud));
   
    transmitter uut2(.clk(tick),.rst(rst),.enable(ena_Tx),.data_bus(data_in_Tx),.busy(busy_Tx),.data_out(data_out_Tx),.err(err_Tx));
    reciever uut3(.clk(tick),.rst(rst),.enable(ena_Rx),.data_in(data_in_Rx),.busy(busy_Rx),.data_bus(data_out_Rx),.err(err_Rx));
endmodule
