module ram(i_clk, i_addr, i_data, i_MemWrite, i_MemRead, o_data);
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32; //32 4-byte words 

input                     i_clk, i_MemWrite, i_MemRead;
input   [ADDR_WIDTH-1:0]  i_addr;
input   [DATA_WIDTH-1:0]  i_data;
output reg [DATA_WIDTH-1:0]  o_data;

reg [DATA_WIDTH-1:0] ram_mem [31:0];

initial begin
    ram_mem [0] = 32'd12;
    ram_mem [1] = 32'd3;
    ram_mem [2] = 32'd5;
end


always @(posedge i_clk) begin
    if(i_MemWrite && ~i_MemRead) begin
        ram_mem[i_addr] = i_data;
    end
end

always @(*) begin
    if (~i_MemWrite && i_MemRead) begin
        o_data = ram_mem[i_addr];
    end
end

endmodule