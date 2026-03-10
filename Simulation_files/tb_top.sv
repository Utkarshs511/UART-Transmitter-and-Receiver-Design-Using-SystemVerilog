`include "uart_pkg.sv"
import uart_pkg::*;

module tb_top;

    // Clock
    logic clk;
    initial clk = 0;
    always #5 clk = ~clk;

    // Interface
    interfac uart_if_inst(clk);
    environment env;
    
    // DUT
    top_module DUT (
        .rst        (uart_if_inst.rst),
        .clk        (clk),
        .ena_baud   (uart_if_inst.ena_baud),
        .ena_Tx     (uart_if_inst.ena_Tx),
        .ena_Rx     (uart_if_inst.ena_Rx),
        .sel        (uart_if_inst.sel),
        .data_in_Tx (uart_if_inst.data_in_Tx),
        .data_in_Rx (uart_if_inst.data_in_Rx),
        .data_out_Tx(uart_if_inst.data_out_Tx),
        .data_out_Rx(uart_if_inst.data_out_Rx),
        .err_baud   (uart_if_inst.err_baud),
        .err_Tx     (uart_if_inst.err_Tx),
        .err_Rx     (uart_if_inst.err_Rx),
        .busy_Tx    (uart_if_inst.busy_Tx),
        .busy_Rx    (uart_if_inst.busy_Rx),
        .tick       (uart_if_inst.tick)
    );
     
   assign uart_if_inst.data_in_Rx=uart_if_inst.data_out_Tx;
  uart_test test;

initial begin
    uart_if_inst.rst=1'b1;
    #10;
    uart_if_inst.rst=1'b0;
    
    test = new(uart_if_inst);
    test.run();
end   


 
//  initial begin
//        $monitor("Time=%0t | rst=%b | data_in=%b | data_bus=%h | busy_Tx=%b | busy_Rx=%b|",
//                  $time, uart_if_inst.rst, uart_if_inst.data_out_Tx, uart_if_inst.data_out_Rx, uart_if_inst.busy_Tx, uart_if_inst.busy_Rx);
//    end
    
endmodule