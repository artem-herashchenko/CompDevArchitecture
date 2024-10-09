`timescale 1ns/1ps
module testbench;
//____mux2in1____
reg [31:0] dat0, dat1;
reg control;
wire [31:0] odat;

//____signExtend____
reg [15 : 0] idat_Se;
reg en_Se;
wire [31 : 0] odat_Se;

//____pc____
reg i_rst_n_pc;
reg [31:0] i_pc;
wire [31:0] o_pc;

//____shiftLeftBy2____
parameter WIDTH = 32;
reg [WIDTH-1:0] i_data_Slby2;
wire [WIDTH-1:0] o_data_Slby2;

//____regFile____
reg [4:0]i_raddr1, i_raddr2, i_waddr; 
reg [31:0] i_wdata; 
reg i_we;
wire [31:0] o_rdata1, o_rdata2;            

//____clock_50MHz____
reg clk;
parameter PERIOD = 20;

mux2in1 mux2in1(.i_dat0(dat0),
				.i_dat1(dat1),
				.i_control(control),
				.o_dat(odat)
				);

signExtend signExtend (.i_data(idat_Se),
					   .o_data(odat_Se),
					   .en(en_Se)
					   );

pc pc (.i_clk(clk),
	   .i_rst_n(i_rst_n_pc),
	   .i_pc(i_pc),
	   .o_pc(o_pc)
	   );

shiftLeftBy2 #(.WIDTH(WIDTH)) shiftLeftBy2 (.i_data(i_data_Slby2),
											.o_data(o_data_Slby2)
											); 

regFile regFile(.i_clk(clk), 
               	.i_raddr1(i_raddr1), 
                .i_raddr2(i_raddr2), 
               	.i_waddr(i_waddr), 
               	.i_wdata(i_wdata), 
               	.i_we(i_we),
               	.o_rdata1(o_rdata1),
               	.o_rdata2(o_rdata2) 
               );



initial begin
	clk = 0;
	forever #(PERIOD / 2) clk = ~clk;
end 
//____mux2in1____
initial begin
	dat0 = 32'd14;
	dat1 = 32'd88;
	control = 0;
	forever #(PERIOD * 5) begin
		control = 1;
	end
end
//____signExtend____
initial begin
	en_Se = 0;
	idat_Se = 16'b1000000000000001;
	forever #(PERIOD) en_Se = ~en_Se;
end
//____pc____
initial begin
	i_pc = 0;
	i_rst_n_pc = 0;
	#5 i_rst_n_pc = 1;
	forever #(PERIOD) i_pc = i_pc + 1'b1;
end
//____shiftLeftBy2____
initial begin
	i_data_Slby2 = 0;
	forever #(PERIOD) i_data_Slby2 = i_data_Slby2 + 1'b1;
end
//____regFile____
initial begin 
    i_we = 0;
	i_raddr1 = 0;
	i_raddr2 = 0;
	i_waddr = 0;
	i_wdata = 0;
	#5 i_we = 1;
end

initial begin
    forever #(PERIOD * 5) begin
		i_raddr1 <= i_raddr1 + 1;
		i_raddr2 <= i_raddr2 + 2;
	end
end

initial begin 
	forever #(PERIOD) begin
		i_waddr <= i_waddr + 1;
		i_wdata <= i_wdata + 5;
	end
end

initial #1000 $finish;
endmodule : testbench