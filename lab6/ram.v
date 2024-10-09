module ram(i_clk, i_addr, i_data, i_we, o_data);
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 5; //32 4-byte words 

input                    	 	 i_clk, i_we;
input   	[ADDR_WIDTH-1:0] 	 i_addr;
input  	 	[DATA_WIDTH-1:0]  	 i_data;
output reg  [DATA_WIDTH-1:0] 	 o_data;

reg [(DATA_WIDTH-1):0] ram_mem [31:0];

initial begin
	ram_mem [0] = 32'd0;
    ram_mem [1] = 32'd0;
    ram_mem [2] = 32'd0;
    ram_mem [3] = 32'd0;
    ram_mem [4] = 32'd0;
    ram_mem [5] = 32'd3;
    ram_mem [6] = 32'd4;
    ram_mem [7] = 32'd5;
    ram_mem [8] = 32'd6;
    ram_mem [9] = 32'd0;
    ram_mem [10] = 32'd0;
    ram_mem [11] = 32'd0;
    ram_mem [12] = 32'd0;
    ram_mem [13] = 32'd0;
    ram_mem [14] = 32'd0;
    ram_mem [15] = 32'd0;
    ram_mem [16] = 32'd0;
    ram_mem [17] = 32'd0;
    ram_mem [18] = 32'd0;
    ram_mem [19] = 32'd0;
    ram_mem [20] = 32'd0;
    ram_mem [21] = 32'd0;
    ram_mem [22] = 32'd0;
    ram_mem [23] = 32'd0;
    ram_mem [24] = 32'd0;
    ram_mem [25] = 32'd0;
    ram_mem [26] = 32'd0;
    ram_mem [27] = 32'd0;
    ram_mem [28] = 32'd0;
    ram_mem [29] = 32'd0;

end


always@(posedge i_clk)begin
	if(i_we) begin
		ram_mem[i_addr] <= i_data;
	end 
end


always@(*)begin
	o_data = ram_mem [i_addr];
end

endmodule