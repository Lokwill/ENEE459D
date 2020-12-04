`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2020 09:27:25 PM
// Design Name: 
// Module Name: pc_counter
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


module pc_counter(clk, reset, enable, pc);
input clk;
input reset;
input enable;
output logic [8:0] pc;

always @(posedge clk)
begin
    if(reset)
        pc <= 0;
    else if(enable) 
        pc <= pc + 1;
end
        

endmodule
