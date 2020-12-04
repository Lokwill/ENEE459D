`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2020 10:12:40 AM
// Design Name: 
// Module Name: apb_master
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


module apb_master(clk, addr, enable, sel, wdata, write, rdata, pclk, paddr, penable, psel, pwdata, prdata, pwrite, pready);

input clk;
input [7:0] addr;
input enable;
input sel;
input [31:0] wdata;
output [31:0] rdata;

input write;
//apb master signals
output pclk;
output [7:0] paddr;
output penable;
output psel;
output [31:0] pwdata;
input pready;
output pwrite;
input [31:0] prdata;

assign paddr = addr;
assign pclk = clk;
assign penable = enable;
assign psel = sel;
assign pwdata = wdata;

assign pwrite = write;
assign rdata = prdata;

endmodule
