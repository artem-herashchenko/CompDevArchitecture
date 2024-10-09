module ram(i_clk, i_addr, i_data, i_MemWrite, i_MemRead, o_data);
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32; //32 4-byte words 

input                     i_clk, i_MemWrite, i_MemRead;
input   [ADDR_WIDTH-1:0]  i_addr;
input   [DATA_WIDTH-1:0]  i_data;
output reg [DATA_WIDTH-1:0]  o_data;

reg [DATA_WIDTH-1:0] ram_mem [31:0];

initial begin
    ram_mem [0] = 32'd1;
    ram_mem [1] = 32'd2;
    ram_mem [2] = 32'd3;
    ram_mem [3] = 32'd4;
    ram_mem [4] = 32'd5;
    ram_mem [5] = 32'd6;
    ram_mem [6] = 32'd7;
    ram_mem [7] = 32'd8;
    ram_mem [8] = 32'd9;
    ram_mem [9] = 32'd10;
    ram_mem [10] = 32'd11;
    ram_mem [11] = 32'd12;
    ram_mem [12] = 32'd13;
    ram_mem [13] = 32'd14;
    ram_mem [14] = 32'd15;
    ram_mem [15] = 32'd16;
    ram_mem [16] = 32'd17;
    ram_mem [17] = 32'd18;
    ram_mem [18] = 32'd19;
    ram_mem [19] = 32'd20;
    ram_mem [20] = 32'd21;
    ram_mem [21] = 32'd22;
    ram_mem [22] = 32'd23;
    ram_mem [23] = 32'd24;
    ram_mem [24] = 32'd25;
    ram_mem [25] = 32'd26;
    ram_mem [26] = 32'd27;
    ram_mem [27] = 32'd28;
    ram_mem [28] = 32'd29;
    ram_mem [29] = 32'd30;
    
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