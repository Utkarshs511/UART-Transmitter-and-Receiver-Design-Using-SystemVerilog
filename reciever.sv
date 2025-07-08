`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2025 13:37:02
// Design Name: 
// Module Name: reciever
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


module reciever(
    input rst,
    input clk,
    input enable,
    input data_in,
    output logic [7:0] data_bus,
    output logic busy,
    output logic err
    );
    typedef enum logic [2:0] {
        idle, data, par, stop,error
    } sta;
    sta state;
    logic [7:0] data_load;
    logic parity;
    logic [3:0] count;
    always@(posedge clk,posedge rst)begin
        if(rst)begin
            data_bus<=8'b0;
            busy<=0;
            err<=0;
            state<=idle;
            count<=0;
        end
        else if(enable) begin
            case(state)
            idle: begin
                err<=0;
                count<=0;
                busy<=0;
                if(~data_in) begin
                    data_bus<=8'b0;
                    state<=data;
                    busy<=1;
                end
            end
            data:begin
                if(count==8)begin
                    state<=par;
                end
                else if(count==0)begin
                    data_load[count]<=data_in;
                    count<=count+1;
                    parity<=data_in;
                end
                else begin
                    data_load[count]<=data_in;
                    count<=count+1;
                    parity<=parity^data_in;
                end
            end
            par: begin
                if(parity==data_in)begin
                    state<=stop;
                end
                else begin
                    state<=error;
                end
            end
            stop: begin
                if(data_in==1) begin
                    data_bus<=data_load;
                    count<=0;
                    busy<=0;
                    state<=idle;
                end
                else begin
                    state <= error;
                end
            end
            error:begin
                err<=1;
                state<=idle;
                busy<=0;
            end
            endcase
        end
    end
endmodule
