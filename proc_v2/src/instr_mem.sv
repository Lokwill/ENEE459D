`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 07:55:25 PM
// Design Name: 
// Module Name: instr_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instr_mem(clk, addr, data, mem);

input clk;
input [8:0] addr;
output logic [8:0] data;

output logic [8:0] mem [0:255];

initial begin
mem[0] = 9'b001111000;
mem[1] = 9'b001001000;
mem[2] = 9'b001010000;
mem[3] = 9'b001011000;
mem[4] = 9'b001100000;
mem[5] = 9'b001101000;
mem[6] = 9'b001110000;
mem[7] = 9'b001000000;
mem[8] = 9'b000100000;//R4 <- R0
mem[9] = 9'b100011010;//load *R3 -> R2, R2 = mem[R3] = 10
mem[10] = 9'b101011000;
mem[11] = 9'b100011010;
mem[12] = 9'b011000001;
end 

always @ (posedge clk) 
begin
  data <= mem[addr];
end

endmodule
