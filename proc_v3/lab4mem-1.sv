module mem_t (clk, addr, ce, sel, pwrite, wr_data, rd_data);

input clk, ce, sel, pwrite;
input [7:0] addr;
input [31:0] wr_data;
output reg [31:0] rd_data;

integer i;
reg [31:0] mem [0:255];
/*
initial begin
    mem[0] = 32'h0000000a;
    mem [1] = 32'b00000100000100001000000001000001; //setting the rtc to Yr 1, Day 1 at 1:01:01
    for(i = 2; i < 256; i++)
    begin
        mem[i] = i+10;
    end
end
*/
always @ (posedge clk) 
if (ce && (~sel)) 
begin
   if (!pwrite) 
       rd_data <= mem[addr];
   else if (pwrite) 
       mem[addr] <= wr_data;
end

endmodule

