module shiftLeftBy2(i_data, o_data);
parameter WIDTH_IN = 32,
          WIDTH_OUT = 32;
input   [WIDTH_IN-1:0]   i_data;
output reg [WIDTH_OUT-1:0]   o_data;

always @(i_data) begin
    o_data <= i_data << 2;
end

endmodule