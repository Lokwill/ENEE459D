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


module instr_mem(clk, addr, o_data, mem, wr_en, i_data);

input clk;
input [7:0] addr; //changed from 8:0
input wr_en;
output logic [31:0] o_data;
input [31:0] i_data;

output logic [31:0] mem [0:255];

initial begin
mem[0] = 32'b00000000000000000000011001111000; //R7 <- 3
mem[1] = 32'b00000000000000000011101001001000; //R1 <- 29
mem[2] = 32'b00000000000000000000101001010000; //R2 <- 5
mem[3] = 32'b00000000000000000000000001011000; //R3 <- 0
mem[4] = 32'b00000000000000000000110001100000; //R4 <- 6
mem[5] = 32'b00000000000000000000001001101000; //R5 <- 1
mem[6] = 32'b00000000000000000000111001110000; //R6 <- 7
mem[7] = 32'b00000000000000000000110001000000; //R0 <- 6
mem[8] = 32'b00000000000000000000000000100000; //R4 <- R0
mem[9] = 32'b000000000000000000000000100101010; //load *R5 -> R2, R2 = mem[R5=1] = 32'b00000100000100...1;
mem[10] = 32'b00000000000000000000001101011010; //store R2 -> *R3, RTC[R3=0] = R2 = write RTC, psel = 1 b/c instr[10] = 1
mem[11] = 32'b00000000000000000000000100011010; //load *R3 -> R2, R2 = mem[R3] = 6
mem[12] = 32'b00000000000000000000000011000001; //sub R0 <- R0 - R1
end 

always @ (posedge clk) 
begin
    if(wr_en)
        mem[addr] <= i_data;
    else
        o_data = mem[addr];
end

 

endmodule
