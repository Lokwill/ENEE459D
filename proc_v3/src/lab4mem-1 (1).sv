module lab4mem (clk, addr, ce, wren, rden, wr_data, rd_data);

input clk, ce, wren, rden;
input [7:0] addr;
input [31:0] wr_data;
output reg [31:0] rd_data;

reg [31:0] mem [0:255];

always @ (posedge clk) 
if (ce) 
begin
   if (rden) 
       rd_data <= mem[addr];
   else if (wren) 
       mem[addr] <= wr_data;
end

endmodule

