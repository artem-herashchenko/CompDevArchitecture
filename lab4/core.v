module core (
    input i_clk, 
    input i_rst_n_core
);

//----program counter----
wire [31:0] o_pc_core;
//----instruction memory----
wire [31:0] o_data_instMem_core;
//----mux_inst----
wire [4:0] o_mux_inst_core;
//----regFile----
wire [31:0] o_dat1_regFile_core, o_dat2_regFile_core;
//----mux regFile----
wire [31:0] o_mux_regFile_core;
//----alu----
wire o_aluZero_core;
wire [31:0] o_resultAlu_core;
//----Data memory----
wire [31:0] o_readData_core;
//----mux_DataMem----
wire [31:0] o_mux_DataMem_core;
//----control----
wire o_RegDst_core, o_Jump_core, o_Brunch_core, o_MemRead_core, o_MemToReg_core, o_MemWrite_core, o_aluSrc_core, o_RegWrite_core, o_ExpOp_core;
wire [1:0] o_aluOp_core;
//----aluControl----
wire [3:0] o_aluControl_core;
//----Sign Extend----
wire [31:0] o_signExtend_core;
//----Shift left 2----
wire [31:0] o_shiftLeftBy2_core;
//----adder pc----
wire [31:0] o_adderPc_core;
//----adder----
wire [31:0] o_adder_core;
//----mux add----
wire [31:0] o_mux_add_core;
//----Shift left 2 mux----
wire [31:0] o_shiftLeftBy2_mux_core;
//----mux_pc----
wire [31:0] o_mux_pc_core;
wire [31:0] jump_adress;
//----AND----
wire o_and_mux_add_core;


//____program counter____
pc pc_core(.i_clk(i_clk),
           .i_rst_n(i_rst_n_core),
           .i_pc(o_mux_pc_core),
           .o_pc(o_pc_core)
           );

//____instruction memory____
rom #(.DATA_WIDTH(32), .ADDR_WIDTH(32)) rom_core(.i_addr(o_pc_core),
                                              .o_data(o_data_instMem_core)
                                              );
//____mux_inst____
mux2in1 #(.WIDTH(5)) mux_inst(.i_dat0(o_data_instMem_core[20:16]),
                 .i_dat1(o_data_instMem_core[15:11]),
                 .i_control(o_RegDst_core),
                 .o_dat(o_mux_inst_core)
                 );

//____regFile____
regFile regFile_core(.i_clk(i_clk),
                     .i_raddr1(o_data_instMem_core[25:21]),
                     .i_raddr2(o_data_instMem_core[20:16]),
                     .i_waddr(o_mux_inst_core),
                     .i_wdata(o_mux_DataMem_core),
                     .i_we(o_RegWrite_core),
                     .o_rdata1(o_dat1_regFile_core),
                     .o_rdata2(o_dat2_regFile_core)
                     );

//____mux regFile____
mux2in1 #(.WIDTH(32)) mux_regFile(.i_dat0(o_dat2_regFile_core),
                                  .i_dat1(o_signExtend_core),
                                  .i_control(o_aluSrc_core),
                                  .o_dat(o_mux_regFile_core)
                                  );

//____alu____
alu alu_core(.i_op1(o_dat1_regFile_core),
             .i_op2(o_mux_regFile_core),
             .i_control(o_aluControl_core),
             .o_result(o_resultAlu_core),
             .o_zf(o_aluZero_core));

//____Data memory____
ram dataMem_core(.i_clk(i_clk),
                 .i_addr(o_resultAlu_core),
                 .i_data(o_dat2_regFile_core),
                 .i_MemWrite(o_MemWrite_core),
                 .i_MemRead(o_MemRead_core),
                 .o_data(o_readData_core)
                 );

//____mux DataMem____
mux2in1 #(.WIDTH()) mux_DataMem(.i_dat0(o_resultAlu_core),
                                .i_dat1(o_readData_core),
                                .i_control(o_MemToReg_core),
                                .o_dat(o_mux_DataMem_core)
                                );

//____control____
control  control_core(.i_instrCode(o_data_instMem_core[31:26]),
                      .o_regDst(o_RegDst_core),
                      .o_jump(o_Jump_core),
                      .o_branch(o_Brunch_core),
                      .o_MemRead(o_MemRead_core),
                      .o_MemToReg(o_MemToReg_core),
                      .o_aluOp(o_aluOp_core),
                      .o_MemWrite(o_MemWrite_core),
                      .o_aluSrc(o_aluSrc_core),
                      .o_RegWrite(o_RegWrite_core),
                      .o_ExpOp(o_ExpOp_core)
                      );

//____alu Control____
aluControl aluControl_core(.i_aluOp(o_aluOp_core),
                           .i_func(o_data_instMem_core[5:0]),
                           .o_aluControl(o_aluControl_core)
                           );

//____Sign Extend____
signExtend signExtend_core(.i_data(o_data_instMem_core[15:0]),
                           .en(o_ExpOp_core),
                           .o_data(o_signExtend_core)
                           );

//____Shift left 2____
shiftLeftBy2 #(.WIDTH_IN(32), .WIDTH_OUT(32)) shiftLeftBy2_core(.i_data(o_signExtend_core),
                               .o_data(o_shiftLeftBy2_core)
                               );

//____adder pc____
adder adder_pc_core(.i_op1(o_pc_core),
                    .i_op2(32'd4),
                    .o_result(o_adderPc_core)
                    );

//____adder____
adder adder_core(.i_op1(o_adderPc_core),
                 .i_op2(o_shiftLeftBy2_core),
                 .o_result(o_adder_core)
                 );

//____mux add____
mux2in1 #(.WIDTH(32)) mux_add(.i_dat0(o_adderPc_core),
                              .i_dat1(o_adder_core),
                              .i_control(o_and_mux_add_core),
                              .o_dat(o_mux_add_core)
                              );

//____Shift left 2 mux____
shiftLeftBy2 #(.WIDTH_IN(32), .WIDTH_OUT(32)) shiftLeftBy2_mux_core(.i_data(o_data_instMem_core),
                                                                    .o_data(o_shiftLeftBy2_mux_core)
                                                                    );

//____mux pc____
assign jump_adress = {o_adderPc_core[31:28], o_shiftLeftBy2_mux_core[27:0]};

mux2in1 #(.WIDTH(32)) mux_pc(.i_dat0(o_mux_add_core),
                             .i_dat1(jump_adress),
                             .i_control(o_Jump_core),         
                             .o_dat(o_mux_pc_core)
                             );

//____AND____
assign o_and_mux_add_core = o_Brunch_core & o_aluZero_core; 


endmodule