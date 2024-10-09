module control (
    input     [5:0]   i_instrCode, //op code
    output            o_regDst,
    output            o_jump,
    output            o_branch,
    output            o_MemRead,
    output            o_MemToReg,
    output    [1:0]   o_aluOp,
    output            o_MemWrite,
    output            o_aluSrc,
    output            o_RegWrite,
    output            o_ExpOp
     
);

parameter R     = 6'b000000,
          LW    = 6'b100011,
          SW    = 6'b101011,
          BEQ   = 6'b000100,
          J     = 6'b000010,
          ADDI  = 6'b001000,
          ADDIU = 6'b001001;

reg [11:0] o_control; 

assign {o_regDst, o_aluSrc, o_MemToReg, o_RegWrite, o_MemRead, o_MemWrite, o_branch, o_jump, o_ExpOp, o_aluOp} = o_control;

always @(*) begin
    
    case (i_instrCode)
        R:     o_control = 12'b1_0_0_1_0_0_0_0_x_10; //regDst_aluSrc_MemToReg_RegWrite_MemRead_MemWrite_Branch_Jump_ExpOP_aluOp
        LW:    o_control = 12'b0_1_1_1_1_0_0_0_1_00;
        SW:    o_control = 12'bx_1_x_0_0_1_0_0_1_00;
        BEQ:   o_control = 12'bx_0_x_0_0_0_1_0_x_01;
        J:     o_control = 12'bx_x_x_0_0_0_x_1_x_xx;
        ADDI:  o_control = 12'b0_1_0_1_0_0_0_0_1_00;
        ADDIU: o_control = 12'b0_1_0_1_0_0_0_0_0_00;
    endcase

end

endmodule
