module control (
    input     [5:0]   i_instrCode, //op code
    output            o_regDst,
    output            o_regWrite,
    output            o_ExtOp,
    output            o_aluSrc,
    output            o_beq,
    output            o_bne,
    output            o_jump,
    output            o_memRead, 
    output            o_memWrite,
    output            o_memToReg

    //output    [1:0]   o_aluOp 
);

parameter R     = 6'b000000,
          ADDI  = 6'b001000,
          SLTI  = 6'b001010,
          ANDI  = 6'b001100,
          ORI   = 6'b001101,
          XORI  = 6'b001110,
          LW    = 6'b100011,
          SW    = 6'b101011,
          BEQ   = 6'b000100,
          BNE   = 6'b000101,
          J     = 6'b000010;

reg [9:0] o_control; 

assign {o_regDst, o_regWrite, o_ExtOp, o_aluSrc, o_beq, o_bne, o_jump, o_memRead, o_memWrite, o_memToReg} = o_control;

always @(*) begin
    
    case (i_instrCode)
        R:    o_control <= 10'b11x0000000;
        ADDI: o_control <= 10'b0111000000;
        SLTI: o_control <= 10'b0111000000;
        ANDI: o_control <= 10'b0101000000;
        ORI:  o_control <= 10'b0101000000;
        XORI: o_control <= 10'b0101000000;
        LW:   o_control <= 10'b0111000101;
        SW:   o_control <= 10'bx01100001x;
        BEQ:  o_control <= 10'bx0x010000x;
        BNE:  o_control <= 10'bx0x001000x;
        J:    o_control <= 10'bx0xx00100x;

    endcase

end

endmodule
