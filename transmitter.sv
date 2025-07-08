`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2025 13:37:02
// Design Name: 
// Module Name: transmitter
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


module transmitter(
    input rst,
    input clk,
    input enable,
    input [7:0] data_bus,
    output logic data_out,
    output logic busy,
    output  logic err
    );
     typedef enum logic [2:0] {
        idle, start, data, par, stop
    } sta;
    sta state;
    logic [7:0] data_load;
    logic [3:0] count=0;
    logic parity;
    logic send;
    always@(*)begin
        if(data_load!=data_bus && state!=idle)begin
            err<=1;
        end
        else begin
            err<=0;
        end
    end
    always@(posedge clk, posedge rst) begin
        if(rst)begin
            data_out<=1;
            state<=idle;
            busy<=0;
            count<=0;
            send<=0;
        end
        else if(enable)begin
            case(state)
                idle: begin
                     data_out<=1;
                     if(send==0)begin
                        state<=start;
                        data_load<=data_bus;
                        parity<=^data_bus;
                        busy<=1;
                        
                     end
                 end
                 start: begin
                    data_out<=0;
                    state<=data;
                 end
                 data: begin
                    if(count<8)begin
                        data_out<=data_load[count];
                        count<=count+1;
                    end
                    else begin
                        state<=par;
                        count<=0;
                    end
                 end
                 par:begin
                    data_out<=parity;
                    state<=stop;
                 end
                 stop: begin
                    data_out<=1;
                    state<=idle;
                    busy<=0;
                    send<=1;
                end
          endcase  
     end
     else if(enable==0) begin
          send<=0;
          data_out<=1;
          busy<=0;
     end     
  end
   
endmodule
