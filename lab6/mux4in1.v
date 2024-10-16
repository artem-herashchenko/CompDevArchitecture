module mux4in1(i_dat0, i_dat1, i_dat2, i_dat3, i_control, o_dat);

parameter WIDTH = 32;

input   	[WIDTH-1:0] i_dat0, i_dat1, i_dat2, i_dat3; 
input       [1:0]       i_control;
output reg  [WIDTH-1:0] o_dat;

always @(*) begin
	case (i_control)
		2'b00: o_dat = i_dat0;
		2'b01: o_dat = i_dat1;
		2'b10: o_dat = i_dat2;
		2'b11: o_dat = i_dat3;
	endcase // i_control
end

endmodule