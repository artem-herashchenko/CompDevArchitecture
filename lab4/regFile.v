module regFile(i_clk, 
               i_raddr1, 
               i_raddr2, 
               i_waddr, 
               i_wdata, 
               i_we,
               o_rdata1,
               o_rdata2 
               );
               
input           i_clk, i_we;                    //Clock, RegWrite
input   [4:0]   i_raddr1, i_raddr2, i_waddr;    //RA, RB, RW
input   [31:0]  i_wdata;                        //BusW     
output  [31:0]  o_rdata1, o_rdata2;             //BusA, BusB

reg [31:0] register [31:0];
integer i;

initial begin
    for (i = 0; i < 32 ; i = i + 1) begin
        register[i] = 32'd0;
    end
end

always @(posedge i_clk) begin
    if (i_we && (i_waddr != 0))begin
        register [i_waddr] <= i_wdata;
    end
end

assign o_rdata1 = register[i_raddr1];
assign o_rdata2 = register[i_raddr2];

  
endmodule