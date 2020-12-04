`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2020 01:04:10 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb();
logic i_clk;
logic i_rst_n;

top_level uut4(.i_clk(i_clk),.i_rst_n(i_rst_n));

initial begin
i_clk = 0;
i_rst_n = 1;
#1;
i_rst_n = 0;
#5;
i_rst_n = 1;
end

always #5 i_clk = ~i_clk;

endmodule
