`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 10:19:26
// Design Name: 
// Module Name: baud_rate_tb
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


module baud_rate_tb;
    logic enable;
    logic clk;
    logic rst;
    logic err;
    logic tick;
    logic [2:0] sel;
    
    baud_rate_generator uut(.enable(enable),.clk(clk),.rst(rst),.err(err),.tick(tick),.sel(sel));
    
    always #5 clk=~clk;
    
    task test_baud(input [2:0] sel_val, input integer duration_ns);
        begin
            sel = sel_val;
            #20;
            $display("Testing sel = %b | baud_time: %d", sel, uut.baud_time);
            #(duration_ns);
        end
    endtask
    
    initial begin
        rst=1;
        enable=0;
        clk=0;
        sel = 3'b000;
        #10
        rst=0;
        err=0;
        enable=1;// Run tests for valid selections
        test_baud(3'b000, 1_000_00); // 4800
        test_baud(3'b001, 1_000_00); // 9600
        test_baud(3'b010, 1_000_00); // 19200
        test_baud(3'b011, 1_000_00); // 38400
        test_baud(3'b100, 1_000_00);  // 57600
        test_baud(3'b101, 1_000_00);  // 115200

        // Test invalid selection
        test_baud(3'b111, 10000);  // should trigger err 
   end
  
  
endmodule
