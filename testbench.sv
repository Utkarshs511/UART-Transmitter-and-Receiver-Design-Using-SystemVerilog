`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2025 10:26:01
// Design Name: 
// Module Name: testbench
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


module testbench;
    
  logic clk;
  logic rst;

  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz
  end

  initial begin
    rst = 1;
    #20 rst = 0;
  end

  // Inputs to top module
  logic ena_baud, ena_Tx, ena_Rx;
  logic [2:0] sel;
  logic [7:0] data_in_Tx;
  logic data_in_Rx;

  // Outputs from top module
  logic data_out_Tx;
  logic [7:0] data_out_Rx;
  logic err_baud, err_Tx, err_Rx;
  logic busy_Tx, busy_Rx;
  logic tick;
  
  
 task send_bit(input bit b);
        begin
            data_in_Rx=b;
            #26060;  // 1 clock cycle of reciever 19200 baud rate
        end
  endtask
  task send_frame(input [7:0] data);
        bit parity;
        int i;
        begin
            parity=^data;

            send_bit(0); // start bit
            for (i = 0; i < 8; i++) begin
                send_bit(data[i]); // LSB first
            end
            send_bit(parity); // parity
            send_bit(1);      // stop 
            #50;
        end
    endtask

  top_module uut (
    .rst(rst),
    .clk(clk),
    .ena_baud(ena_baud),
    .ena_Tx(ena_Tx),
    .ena_Rx(ena_Rx),
    .sel(sel),
    .data_in_Tx(data_in_Tx),
    .data_in_Rx(data_in_Rx),
    .data_out_Tx(data_out_Tx),
    .data_out_Rx(data_out_Rx),
    .err_baud(err_baud),
    .err_Tx(err_Tx),
    .err_Rx(err_Rx),
    .busy_Tx(busy_Tx),
    .busy_Rx(busy_Rx),
    .tick(tick)
  );
    
initial fork 
  begin
       $display("Time\tCLK\tTX_OUT\tRX_IN\tTX_BUSY\tRX_BUSY\tTX_ERR\tRX_ERR\tRX_DATA");
        forever begin
        @(posedge clk);
          $display("%8t\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%8b\t %b",
          $time, clk, data_out_Tx, data_in_Rx,
           busy_Tx, busy_Rx, err_Tx, err_Rx, data_out_Rx,tick);
    end
    end
  begin
    ena_baud=0;
    sel=3'b010;// 19200
    #10;
    ena_baud=1;
  end
begin
        wait (!rst);
        data_in_Tx=8'b10101010;
        ena_Tx<=1;
        #200;
        
    end
    begin
        wait (!rst);
        ena_Rx<=1;
        data_in_Rx<=1;
        #10;
        send_frame(8'b10101110);
    end

 join

endmodule
