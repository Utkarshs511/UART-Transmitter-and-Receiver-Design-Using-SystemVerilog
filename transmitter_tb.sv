`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 12:04:11
// Design Name: 
// Module Name: transmitter_tb
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


module transmitter_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic enable;
    logic [7:0] data_bus;
    logic data_out;
    logic busy;

    // Instantiate the Unit Under Test (UUT)
    transmitter uut (
        .rst(rst),
        .clk(clk),
        .enable(enable),
        .data_bus(data_bus),
        .data_out(data_out),
        .busy(busy)
    );

    // Clock generation: 100 MHz (10 ns period)
    always #5 clk=~clk;

    initial begin
        clk=0;
        rst=1;
        enable=0;
        data_bus=8'b00000000;

        
        #20;
        rst=0;
        #10;

       
        data_bus=8'b10101010;
        enable=1;

        #200;
        enable=0; 

        // Let the transmission finish
        #200;
        $display("Next Byte");// Send another byte
        data_bus=8'b11001100;
        enable=1;
        #200;
        enable=0;

        // Wait for completion
        #20;

      
    end

    // Monitor signal changes
    initial begin
        $monitor("Time:%0t| rst=%b| enable=%b| data_bus=%b| data_out=%b| busy=%b| state=%d| count=%d| send=%b",
                 $time, rst, enable, data_bus, data_out, busy, uut.state,uut.count,uut.send);
    end

endmodule
