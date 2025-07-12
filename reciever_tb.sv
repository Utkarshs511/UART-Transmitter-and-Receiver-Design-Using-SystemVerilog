`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 16:07:24
// Design Name: 
// Module Name: reciever_tb
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


module reciever_tb;
    logic rst;
    logic clk;
    logic enable;
    logic data_in;

    logic [7:0] data_bus;
    logic busy;
    logic err;

    reciever uut (
        .rst(rst),
        .clk(clk),
        .enable(enable),
        .data_in(data_in),
        .data_bus(data_bus),
        .busy(busy),
        .err(err)
    );

   
    always #5 clk = ~clk;

    // task to send one bit
    task send_bit(input bit b);
        begin
            data_in<=b;
            #10;  // 1 clock cycle
        end
    endtask

    // task to send a frame (start + 8-bit data + parity + stop)
    task send_frame(input [7:0] data);
        bit parity;
        int i;
        begin
            parity = ^data;

            send_bit(0); // start bit
            for (i = 0; i < 8; i++) begin
                send_bit(data[i]); // LSB first
            end
            send_bit(parity); // parity
            send_bit(1);      // stop 

            #50;
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        enable = 0;
        data_in = 1;

        // Reset
        #20;
        rst=0;
        enable=1;

        #20;
        $display("Sending 0xAE (10101110) with correct parity");
        send_frame(8'b10101110);

        #50;
        $display("Sending 0x55 (01010101) with incorrect parity (flip parity bit)");
        send_bit(0); // start bit
        send_bit(1);
        send_bit(0); 
        send_bit(1); 
        send_bit(0); 
        send_bit(1); 
        send_bit(0); 
        send_bit(1);
        send_bit(0); // wrong parity bit 
        send_bit(1); // stop bit

        #100;
        $finish;
    end

   
    initial begin
        $monitor("Time=%0t | rst=%b | data_in=%b | data_bus=%b | busy=%b | err=%b| state=%d| count=%d",
                  $time, rst, data_in, data_bus, busy, err, uut.state,uut.count);
    end

endmodule
