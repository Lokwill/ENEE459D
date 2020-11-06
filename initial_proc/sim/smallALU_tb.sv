`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2020 10:14:00 PM
// Design Name: 
// Module Name: smallALU_tb
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


module smallALU_tb();
logic add_sub;
logic signed [8:0] dataa, datab;
logic signed [8:0] result;
 
smallALU uut(add_sub, dataa, datab, result);

initial begin
#1;
dataa = 9'b111111111;
datab = 9'b000000001;
add_sub = 1;
#5;
dataa = 9'b111011111;
datab = 9'b100011001;
add_sub = 1;
#5;
dataa = 9'b001011111;
datab = 9'b001111001;
add_sub = 0;
end



endmodule
