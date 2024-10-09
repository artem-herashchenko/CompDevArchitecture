module rom
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(ADDR_WIDTH-1):0] i_addr,
	output [(DATA_WIDTH-1):0] o_data
);

reg [DATA_WIDTH-1:0] rom_mem [ADDR_WIDTH-1:0];

initial $readmemb("instructions.dat", rom_mem);

assign o_data = rom_mem[i_addr];

endmodule
