`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2025 13:37:02
// Design Name: 
// Module Name: baud_rate_generator
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


module baud_rate_generator(
    input enable,
    input clk,
    input rst,
    input[2:0] sel,
    output logic tick,
    output logic err
    );
    bit[31:0]baud_time;
    bit[31:0] counter;
    logic [31:0] fre=100000000;//100MHz
    always@(*)begin
        case (sel)
            3'b000: baud_time<=fre/(4*4800);//4800
            3'b001: baud_time<=fre/(4*9600);//9600
            3'b010: baud_time<=fre/(4*19200);//19200
            3'b011: baud_time<=fre/(4*38400);//38400
            3'b100: baud_time<=fre/(4*57600);//57600
            3'b101: baud_time<=fre/(4*115200);//115200
            default: baud_time<=32'hffffffff;//undefined
        endcase
        counter<=baud_time;
    end
    always @(posedge clk) begin
        if(rst)begin
            counter<=0;
             tick<=0;
        end
        else if(enable)begin
            if(baud_time==32'hffffffff) begin
                err<=1;
            end
            else if(counter==baud_time)begin
               tick<=~tick;
               counter<=0;
               err<=0;
            end
            else begin
                counter<=counter+1;
                err<=0;
            end
         end
    end
endmodule
