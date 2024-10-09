`timescale 1ns/1ps
module testbench;
parameter PERIOD = 20;

reg clk;
//____adder____
reg [31:0] i_op1, i_op2;
wire [31:0] o_result;

adder adder(.i_op1(i_op1),
			.i_op2(i_op2),
			.o_result(o_result)
			);
//____ram____
parameter DATA_WIDTH_RAM = 32;
parameter ADDR_WIDTH_RAM = 5;

reg i_we_ram;
reg [(ADDR_WIDTH_RAM-1):0] i_addr_ram;
reg [(DATA_WIDTH_RAM-1):0] i_data_ram;
wire [(DATA_WIDTH_RAM-1):0] o_data_ram;

ram #(.DATA_WIDTH(DATA_WIDTH_RAM),.ADDR_WIDTH(ADDR_WIDTH_RAM)) ram_memory(	.i_clk(clk),
																			.i_addr(i_addr_ram),
																			.i_data(i_data_ram),
																			.i_we(i_we_ram), 
																			.o_data(o_data_ram)
																		    );
//____aluControl____
reg [1:0] i_aluOp_aluControl;
reg [5:0] i_func_aluControl;
wire [3:0] o_aluControl_aluControl;

aluControl aluControl(	.i_aluOp(i_aluOp_aluControl), 
						.i_func(i_func_aluControl),
						.o_aluControl(o_aluControl_aluControl)
						);
//____alu____
reg [31:0] i_op1_alu, i_op2_alu;
reg [3:0] i_control_alu;
wire [31:0] o_result_alu;
wire o_zf_alu;

alu alu(	.i_op1(i_op1_alu), 
			.i_op2(i_op2_alu), 
			.i_control(i_control_alu), 
			.o_result(o_result_alu), 
			.o_zf(o_zf_alu)
			);
//____rom____
parameter DATA_WIDTH_ROM = 32;
parameter ADDR_WIDTH_ROM = 8;

reg [(ADDR_WIDTH_ROM-1):0] i_addr_rom;
wire [(DATA_WIDTH_ROM-1):0] o_data_rom;

rom #(.ADDR_WIDTH(ADDR_WIDTH_ROM),.DATA_WIDTH(DATA_WIDTH_ROM)) rom_memory(	.i_addr(i_addr_rom),
																			.o_data(o_data_rom)
																			);

initial begin
	clk = 0;
	forever #(PERIOD / 2) clk = ~clk;
end

initial begin
    i_op1 = 14;
    i_op2 = 24;
    #10 i_op1 = 1;
    #10 i_op2 = 3;
end

initial begin
    i_op1_alu = 12;
    i_op2_alu = 12;
    i_control_alu = 4'b0110; //SUB
    #20 i_op1_alu = 12;
    #20 i_op2_alu = 15;
    #20 i_control_alu = 4'b0111; //SOLT
    #20 i_op1_alu = 12;
    #20 i_op2_alu = 11;
    #20 i_control_alu = 4'b0010; //ADD
    #20 i_op1_alu = 12;
    #20 i_op2_alu = 21;
    #20 i_control_alu = 4'b0000; //AND
    #20 i_op1_alu = 12;
    #20 i_op2_alu = 25;
    #20 i_control_alu = 4'b0001; //OR
end

initial begin
    i_aluOp_aluControl = 2'b00; //ADD 
    i_func_aluControl = 6'd32;  //ADD funct
    #20 i_aluOp_aluControl = 2'b01; //SUB
    #20 i_func_aluControl = 6'd34;  //SUB funct
    #20 i_aluOp_aluControl = 2'b10; //--->funct
    #20 i_func_aluControl = 6'd36;  //AND funct
    #20 i_aluOp_aluControl = 2'b11; //--->funct
    #20 i_func_aluControl = 6'd37;  //OR funct
    #20 i_aluOp_aluControl = 2'b00; //ADD
    #20 i_func_aluControl = 6'd42;  //SOLT funct
end

initial begin
    i_we_ram = 0;
    i_addr_ram = 6'b000010;
    #20 i_addr_ram = 6'd7;
    #50 i_data_ram = 8;
    #10 i_we_ram = 1;
end

initial begin
    i_addr_rom = 8'd3;
    #20 i_addr_rom = 8'd5;
end

initial #500 $finish;
endmodule : testbench