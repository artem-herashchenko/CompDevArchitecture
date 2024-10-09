module core(i_clk, i_rst_n_pc, i_rst_n_registers);
input i_clk, i_rst_n_pc, i_rst_n_registers;

parameter DATA_WIDTH_ADDER_PC = 30;

parameter DATA_WIDTH_INST_MEM = 32;
parameter ADDR_WIDTH_INST_MEM = 8;

parameter WIDTH_OPPERAND = 5;
parameter DATA_WIDTH_DATA_MEM = 32;
parameter ADDR_WIDTH_DATA_MEM = 5;

parameter WIDTH_IMM_BEFORE_EXTEND = 16;
parameter WIDTH_IMM_AFTER_EXTEND = 32;

parameter WIDTH_IMM_I = 26;
parameter WIDTH_IMM_O = 30;
//MUX_NextPC_to_PC param
wire [DATA_WIDTH_ADDER_PC-1:0] o_MUX_NextPC_to_PC;
//PC param
wire [DATA_WIDTH_INST_MEM-1:0] out_pc;
//ADDER_PC param
wire [DATA_WIDTH_ADDER_PC-1:0] o_result_adderPC;
//NPC reg param
wire [DATA_WIDTH_ADDER_PC-1:0] o_NPC_reg;
//InstMem param
wire [(DATA_WIDTH_INST_MEM-1):0] o_data_inst_memory;
//Mux_Inst_Mem_to_Inst_Reg
wire [(DATA_WIDTH_INST_MEM-1):0] o_MUX_Inst_Mem_to_Inst_Reg;
//Inst_Reg
wire [(DATA_WIDTH_INST_MEM-1):0] o_Inst_Reg;
//MUX_Inst_Reg_to_RegFile param
wire [WIDTH_OPPERAND-1:0] o_MUX_InstMem_to_regFile;
//RegFile param
wire [DATA_WIDTH_DATA_MEM-1:0] o_rdata1_regFile,o_rdata2_regFile;
//Extender param
wire [DATA_WIDTH_DATA_MEM-1:0] o_extOP;
//Mux_RegFile_to_Reg_A
wire [DATA_WIDTH_DATA_MEM-1:0] o_MUX_RegFile_to_Reg_A;
//Mux_RegFile_to_Reg_B
wire [DATA_WIDTH_DATA_MEM-1:0] o_MUX_RegFile_to_Reg_B;
//Reg_SA reg
wire [4:0] o_Reg_SA;
//Reg_A reg
wire [DATA_WIDTH_DATA_MEM-1:0] o_Reg_A;
//Reg_B reg
wire [DATA_WIDTH_DATA_MEM-1:0] o_Reg_B;
//Imm_reg reg
wire [DATA_WIDTH_DATA_MEM-1:0] o_Imm_reg;
//BTA reg
wire [DATA_WIDTH_ADDER_PC-1:0] o_BTA_reg;
//Rd_Ex_reg reg
wire [4:0] o_Rd_Ex_reg;
//hazardDetect_Unit
wire[1:0] o_ForwardB, o_ForwardA;
wire o_Stall;
//MUX_ControlUnit_to_Ex_Reg param
wire [10:0] o_MUX_ControlUnit_to_Ex_Reg;
wire o_kill2orStall;
//def Ex_reg param
wire [10:0] o_Ex_reg;
//MUX_RegFile_to_ALU param
wire [DATA_WIDTH_DATA_MEM-1:0] o_MUX_RegFile_to_ALU;
//ALU param
wire [DATA_WIDTH_DATA_MEM-1:0] o_result_alu;
wire o_zf_alu;
//R_reg param
wire [DATA_WIDTH_DATA_MEM-1:0] o_R_reg;
//D_reg param
wire [DATA_WIDTH_DATA_MEM-1:0] o_D_reg;
//Rd_Mem_reg param
wire [4:0] o_Rd_Mem_reg;
//MEM_reg param
wire [3:0] o_MEM_reg;
//DataMem param
wire [(DATA_WIDTH_DATA_MEM-1):0] o_data_mem;
//MUX_DataMem_to_RegFile param
wire [(DATA_WIDTH_DATA_MEM-1):0] o_MUX_DataMem_to_RegFile;
//Data_reg
wire [(DATA_WIDTH_DATA_MEM-1):0] o_Data_reg;
//Rd_WB_reg
wire [4:0] o_Rd_WB_reg;
//WB_reg
wire o_WB_reg;
//ControlUnit param
wire regDst,j,Beq,Bne,ExtOp,memToReg,memWrite,memRead,aluSrc,regWrite;
wire [1:0] aluOp;
//AluControl param
wire [3:0] o_aluControl_aluControl;
//NextPC param
wire [29:0] o_addr_jump;
wire [29:0] o_outadder;
wire [1:0] o_PCSrc_nextPC;
wire  o_kill1_nextPC, o_kill2_nextPC;


//MUX_NextPC_to_PC
mux3in1 #(.WIDTH(30))	MUX_NextPC_to_PC (		.i_dat0(o_result_adderPC),
														.i_dat1(o_addr_jump),
														.i_dat2(o_BTA_reg),
														.i_control(o_PCSrc_nextPC),
														.o_dat(o_MUX_NextPC_to_PC)
														);
//init PC
pc pc ( .i_clk(i_clk),
		.i_rst_n(i_rst_n_pc),
		.i_en_n (o_Stall),
		.i_pc({o_MUX_NextPC_to_PC,2'b00}),
		.o_pc(out_pc)
		);
//init ADDER_PC
adder #(.DATA_WIDTH(DATA_WIDTH_ADDER_PC)) adderPC(	.i_op1(30'b1),
													.i_op2(out_pc[31:2]),
													.o_result(o_result_adderPC)
													);
//init NPC_reg
register #(.WIDTH(DATA_WIDTH_ADDER_PC)) NPC (.i_clk(i_clk), 
											 .i_data(o_result_adderPC), 
											 .i_en_n(o_Stall), 
											 .i_rst_n(i_rst_n_registers), 
											 .o_data(o_NPC_reg)
											 );
//init inst_memory
rom #(.ADDR_WIDTH(ADDR_WIDTH_INST_MEM),.DATA_WIDTH(DATA_WIDTH_INST_MEM)) inst_memory(	.i_addr(out_pc[9:2]),
																								.o_data(o_data_inst_memory)
																								);
//init MUX_Inst_Mem_to_Inst_Reg
mux2in1 #(.WIDTH(DATA_WIDTH_INST_MEM)) Mux_Inst_Mem_to_Inst_Reg (.i_dat0(o_data_inst_memory), 
																 .i_dat1(32'b0),
																 .i_control(o_kill1_nextPC), 
																 .o_dat(o_MUX_Inst_Mem_to_Inst_Reg)
																 );
//init Inst_reg
register #(.WIDTH(DATA_WIDTH_INST_MEM)) INST (.i_clk(i_clk), 
											 .i_data(o_MUX_Inst_Mem_to_Inst_Reg), 
											 .i_en_n(o_Stall), 
											 .i_rst_n(i_rst_n_registers), 
											 .o_data(o_Inst_Reg)
											 );
//MUX_InstMem_to_RegFile
mux2in1 #(.WIDTH(WIDTH_OPPERAND))	MUX_InstMem_to_RegFile (	.i_dat0(o_Inst_Reg[20:16]),
																.i_dat1(o_Inst_Reg[15:11]),
																.i_control(regDst),
																.o_dat(o_MUX_InstMem_to_regFile)
																);
//init regFile
regFile regFile(.i_clk(i_clk), 
               	.i_raddr1(o_Inst_Reg[25:21]),
                .i_raddr2(o_Inst_Reg[20:16]),
               	.i_waddr(o_Rd_WB_reg), 
               	.i_wdata(o_Data_reg), 
               	.i_we(o_WB_reg),
               	.o_rdata1(o_rdata1_regFile),
               	.o_rdata2(o_rdata2_regFile) 
               );
//init Extender
signExtend #(.WISIGNEXTEND(WIDTH_IMM_BEFORE_EXTEND),.WOSIGNEXTEND(WIDTH_IMM_AFTER_EXTEND )) signExtend( .i_data(o_Inst_Reg[15:0]),
																										.i_en(ExtOp),
																										.o_data(o_extOP)
																										);
//init MUX_RegFile_to_Reg_A
mux4in1 #(.WIDTH(DATA_WIDTH_DATA_MEM)) MUX_RegFile_to_Reg_A (.i_dat0(o_rdata1_regFile), 
															.i_dat1(o_result_alu), 
															.i_dat2(o_MUX_DataMem_to_RegFile), 
															.i_dat3(o_Data_reg), 
															.i_control(o_ForwardA), 
															.o_dat(o_MUX_RegFile_to_Reg_A)
															); 
//init MUX_RegFile_to_Reg_B
mux4in1 #(.WIDTH(DATA_WIDTH_DATA_MEM)) MUX_RegFile_to_Reg_B (.i_dat0(o_rdata2_regFile), 
															.i_dat1(o_result_alu), 
															.i_dat2(o_MUX_DataMem_to_RegFile), 
															.i_dat3(o_Data_reg), 
															.i_control(o_ForwardB), 
															.o_dat(o_MUX_RegFile_to_Reg_B)
															); 
//init MUX_ControlUnit_to_Ex_Reg
assign o_kill2orStall = o_kill2_nextPC | o_Stall;

mux2in1 #(.WIDTH(11))	MUX_ControlUnit_to_Ex_Reg 	(	.i_dat0({Beq,Bne,memToReg,memWrite,memRead,aluSrc,regWrite,o_aluControl_aluControl}), 
														.i_dat1(11'b0), 
														.i_control(o_kill2orStall),
														.o_dat(o_MUX_ControlUnit_to_Ex_Reg)
														);
//init BTA_reg
register #(.WIDTH(DATA_WIDTH_ADDER_PC)) BTA_reg (.i_clk(i_clk), 
												 .i_data(o_outadder), 
												 .i_en_n(1'b0), 
												 .i_rst_n(i_rst_n_registers), 
												 .o_data(o_BTA_reg)
												 );
//init Reg_SA
register #(.WIDTH(5)) Res_SA (.i_clk(i_clk), 
												 .i_data(o_Inst_Reg[10:6]), 
												 .i_en_n(1'b0), 
												 .i_rst_n(i_rst_n_registers), 
												 .o_data(o_Reg_SA)
												 );
//init Imm_reg
register #(.WIDTH(DATA_WIDTH_DATA_MEM)) Imm_reg (.i_clk(i_clk), 
												 .i_data(o_extOP), 
												 .i_en_n(1'b0), 
												 .i_rst_n(i_rst_n_registers), 
												 .o_data(o_Imm_reg)
												 );
//init A_reg
register #(.WIDTH(DATA_WIDTH_DATA_MEM)) A_reg (.i_clk(i_clk), 
												 .i_data(o_MUX_RegFile_to_Reg_A), 
												 .i_en_n(1'b0), 
												 .i_rst_n(i_rst_n_registers), 
												 .o_data(o_Reg_A)
												 );
//init B_reg
register #(.WIDTH(DATA_WIDTH_DATA_MEM)) B_reg (  .i_clk(i_clk), 
												 .i_data(o_MUX_RegFile_to_Reg_B), 
												 .i_en_n(1'b0), 
												 .i_rst_n(i_rst_n_registers), 
												 .o_data(o_Reg_B)
												 );
//init Rd_Ex_reg
register #(.WIDTH(WIDTH_OPPERAND)) Rd_Ex_reg (.i_clk(i_clk), 
									 .i_data(o_MUX_InstMem_to_regFile), 
									 .i_en_n(1'b0), 
									 .i_rst_n(i_rst_n_registers), 
									 .o_data(o_Rd_Ex_reg)
									 );
//init EX_reg
register #(.WIDTH(11)) EX_reg (.i_clk(i_clk), 
							.i_data(o_MUX_ControlUnit_to_Ex_Reg),
							.i_en_n(1'b0), 
							.i_rst_n(i_rst_n_registers), 
							.o_data(o_Ex_reg)
							);
//init MUX_RegFile_to_ALU
mux2in1 #(.WIDTH(DATA_WIDTH_DATA_MEM))	MUX_RegFile_to_ALU 	(	.i_dat0(o_Reg_B), 
																.i_dat1(o_Imm_reg), 
																.i_control(o_Ex_reg[5]),
																.o_dat(o_MUX_RegFile_to_ALU)
																);
//init alu
alu alu(	.i_op1(o_Reg_A), 
			.i_op2(o_MUX_RegFile_to_ALU), 
			.i_control(o_Ex_reg[3:0]), 
			.i_sa(o_Reg_SA),
			.o_result(o_result_alu), 
			.o_zf(o_zf_alu)
			);
//init R_reg
register #(.WIDTH(DATA_WIDTH_DATA_MEM)) R_reg (.i_clk(i_clk), 
											 .i_data(o_result_alu), 
											 .i_en_n(1'b0), 
											 .i_rst_n(i_rst_n_registers), 
											 .o_data(o_R_reg)
											 );
//init D_reg
register #(.WIDTH(DATA_WIDTH_DATA_MEM)) D_reg (.i_clk(i_clk), 
											 .i_data(o_Reg_B), 
											 .i_en_n(1'b0), 
											 .i_rst_n(i_rst_n_registers), 
											 .o_data(o_D_reg)
											 );
//init Rd_MEM_reg
register #(.WIDTH(WIDTH_OPPERAND)) Rd_MEM_reg (.i_clk(i_clk), 
										 .i_data(o_Rd_Ex_reg), 
								 		 .i_en_n(1'b0), 
								 		 .i_rst_n(i_rst_n_registers), 
										 .o_data(o_Rd_Mem_reg)
								 			 );
//init MEM_reg
register #(.WIDTH(4)) MEM_reg (.i_clk(i_clk), 
								.i_data({o_Ex_reg[8],o_Ex_reg[7],o_Ex_reg[6],o_Ex_reg[4]}), 
								.i_en_n(1'b0), 
								.i_rst_n(i_rst_n_registers), 
								.o_data(o_MEM_reg)
								);
//init data_memory
ram #(.DATA_WIDTH(DATA_WIDTH_DATA_MEM),
			  .ADDR_WIDTH(ADDR_WIDTH_DATA_MEM)) 
			data_memory(	.i_clk(i_clk),
							.i_addr(o_R_reg[4:0]),
							.i_data(o_D_reg),
							.i_we(o_MEM_reg[2]), 
							.o_data(o_data_mem)
							);
//init MUX_DataMem_to_RegFile
mux2in1 #(.WIDTH(DATA_WIDTH_DATA_MEM))	MUX_DataMem_to_RegFile 	(	.i_dat0(o_R_reg), 
																	.i_dat1(o_data_mem), 
																	.i_control(o_MEM_reg[3]),
																	.o_dat(o_MUX_DataMem_to_RegFile)
																	);
//init Data_reg
register #(.WIDTH(DATA_WIDTH_DATA_MEM)) Data_reg (.i_clk(i_clk), 
											 .i_data(o_MUX_DataMem_to_RegFile), 
											 .i_en_n(1'b0), 
											 .i_rst_n(i_rst_n_registers), 
											 .o_data(o_Data_reg)
											 );
//init Rd_WB_reg
register #(.WIDTH(WIDTH_OPPERAND)) Rd_WB_reg (.i_clk(i_clk), 
									.i_data(o_Rd_Mem_reg), 
									.i_en_n(1'b0), 
									.i_rst_n(i_rst_n_registers), 
									.o_data(o_Rd_WB_reg)
									 );
//init WB_reg
register #(.WIDTH(1)) WB_reg (.i_clk(i_clk), 
								.i_data(o_MEM_reg[0]), 
								.i_en_n(1'b0), 
								.i_rst_n(i_rst_n_registers), 
								.o_data(o_WB_reg)
								);
//init contolUnit
control controlUnit (  .i_op(o_Inst_Reg[31:26]), 
			               .o_regDst(regDst),
			               .o_J(j), 
			               .o_Beq(Beq),
			               .o_Bne(Bne),
			               .o_ExtOp(ExtOp),
			               .o_memToReg(memToReg),
			               .o_aluOp(aluOp),
			               .o_memWrite(memWrite),
			               .o_memRead(memRead),
			               .o_aluSrc(aluSrc),
			               .o_regWrite(regWrite)
			               );
//init hazardDetectUnit
hazardDetect hazardDetect(.i_Rs(o_Inst_Reg[25:21]),.i_Rt(o_Inst_Reg[20:16]),
									.i_Rd_Ex(o_Rd_Ex_reg), .i_Rd_Mem(o_Rd_Mem_reg), .i_Rd_WB(o_Rd_WB_reg),
									.i_RegWr_Ex(o_Ex_reg[4]), .i_RegWr_Mem(o_MEM_reg[0]), .i_RegWr_WB(o_WB_reg),
									.i_MemRd_Ex(o_Ex_reg[6]),
									.o_ForwardA(o_ForwardA), .o_ForwardB(o_ForwardB), .o_Stall(o_Stall)
									);
//init aluControl
aluControl aluControl(	.i_aluOp(aluOp[1:0]), 
						.i_func(o_Inst_Reg[5:0]),
						.o_aluControl(o_aluControl_aluControl)
						);
//init next PC
assign o_addr_jump = {o_NPC_reg[29:26],o_Inst_Reg[25:0]};
adder #(.DATA_WIDTH(30)) adder_NextPC (	.i_op1(o_NPC_reg),
										.i_op2(o_extOP[29:0]),
										.o_result(o_outadder)	
										);
nextPC 	nextPC (
																			.i_zero(o_zf_alu),
																			.i_j(j),
																			.i_beq(o_Ex_reg[10]),
																			.i_bne(o_Ex_reg[9]),
																			.o_PCSrc(o_PCSrc_nextPC),
																			.o_Kill1(o_kill1_nextPC),
																			.o_Kill2(o_kill2_nextPC)
																			);

endmodule