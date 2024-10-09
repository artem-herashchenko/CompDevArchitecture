module signExtend(i_data, en, o_data);
input   [15:0]  i_data;
input	en;
output reg [31:0]  o_data;

always @(i_data, en) begin
    if (en) begin
        o_data <= (i_data[15] == 1)? {16'd65535, i_data}: {16'd0, i_data};
    end
    else begin
        o_data <= {16'd0, i_data};
    end
end

endmodule