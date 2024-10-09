`timescale 1ns / 1ps

module testbench;

parameter PERIOD = 20;

reg i_clk, i_rst_n;

initial begin
    i_rst_n = 0;
    #5 i_rst_n = 1;
end

initial begin
	i_clk = 0;
	forever #(PERIOD / 2) i_clk = ~i_clk;
end

core core_test(.i_clk(i_clk),
               .i_rst_n_core(i_rst_n)
               );

initial #2000 $finish;

endmodule