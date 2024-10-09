`timescale 1 ns / 10 ps
module testbench;

reg   [5:0]i_instrCode;
reg   [5:0] opcode [10:0];
wire    o_regDst;
wire	o_regWrite;
wire	o_ExtOp;
wire    o_aluSrc; 
wire    o_beq;
wire    o_bne;
wire    o_jump;
wire    o_memRead;
wire    o_memWrite;
wire    o_memToReg;

initial $readmemb("opcode.dat", opcode);

control control_tb(.i_instrCode(i_instrCode), 
                   .o_regDst(o_regDst),
	               .o_regWrite(o_regWrite),
	               .o_ExtOp(o_ExtOp),
                   .o_aluSrc(o_aluSrc), 
                   .o_beq(o_beq),
                   .o_bne(o_bne),
    	           .o_jump(o_jump),
                   .o_memRead(o_memRead),
                   .o_memWrite(o_memWrite),
                   .o_memToReg(o_memToReg)
              	   );

integer i;

initial begin
	for (i = 0; i < 11; i = i + 1) begin
		i_instrCode = opcode[i]; 
		#500;
	end
end	
endmodule
