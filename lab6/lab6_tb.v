`timescale 1ns/1ps
module testbench;
parameter PERIOD = 20;

reg clk, rst_n_pc, rst_n_registers;

core core_tb (.i_clk(clk),.i_rst_n_pc(rst_n_pc),.i_rst_n_registers(rst_n_registers));

initial begin
	clk = 0;
	forever #(PERIOD / 2) clk = ~clk;
end

initial begin
	rst_n_pc = 0;
	rst_n_registers = 0;

	#2 rst_n_pc = 1;
	rst_n_registers = 1;
end

initial #5000 $finish;
endmodule