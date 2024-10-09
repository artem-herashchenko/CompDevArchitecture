module rom(i_addr,o_data);
parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=8;

input 		[(ADDR_WIDTH-1):0] i_addr;
output reg  [(DATA_WIDTH-1):0] o_data;

reg [(DATA_WIDTH-1):0] inst_mem [255:0];

initial $readmemb ("instructions.dat",inst_mem); 

always @(*) begin
	o_data = inst_mem [i_addr];
end

endmodule
