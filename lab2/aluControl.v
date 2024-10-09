module aluControl(i_aluOp, i_func, o_aluControl);
 
input       [1:0]   i_aluOp;
input       [5:0]   i_func;
output  reg [3:0]   o_aluControl;

localparam AND = 4'b0000, OR = 4'b0001, ADD = 4'b0010;
localparam SUB = 4'b0110, SOLT = 4'b0111, NOR = 4'b1100; //SOLT - Set On Less then

always @(*) begin
    case (i_aluOp)
        2'b00: o_aluControl = ADD;
        2'b01: o_aluControl = SUB;
        default: case (i_func)
            6'd32: o_aluControl = ADD;
            6'd34: o_aluControl = SUB;
            6'd36: o_aluControl = AND;
            6'd37: o_aluControl = OR;
            6'd39: o_aluControl = NOR;
            6'd42: o_aluControl = SOLT;
        endcase 
    endcase
end

endmodule