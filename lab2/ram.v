module ram(i_clk, i_addr, i_data, i_we, o_data);
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 5; //32 4-byte words 

input                     i_clk, i_we;
input   [ADDR_WIDTH-1:0]  i_addr;
input   [DATA_WIDTH-1:0]  i_data;
output  [DATA_WIDTH-1:0]  o_data;

reg [DATA_WIDTH-1:0] ram_mem [31:0];

initial $readmemh("ram_mem.dat", ram_mem);

always @(posedge i_clk) begin
    if (i_we) begin
        ram_mem[i_addr] = i_data;
    end
end

assign o_data = ram_mem[i_addr];

endmodule