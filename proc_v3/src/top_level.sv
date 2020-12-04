`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2020 08:57:14 PM
// Design Name: 
// Module Name: top_level
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


module top_level(i_clk, i_rst_n);

input i_clk;
input i_rst_n;

logic test;


//Processor signals
logic Done;
logic [7:0] addr;
logic [31:0] dout;
logic [31:0] mem_in;
logic write, enable, sel;

//APB Master
logic pclk;
logic [7:0] paddr;
logic penable;
logic psel;
logic [31:0] pwdata;
logic [31:0] prdata;
logic pwrite;
logic pready;

lab9 processor(.Clock(i_clk),.Resetn(i_rst_n),.Done(Done),.addr(addr),.dout(dout),.mem_in(mem_in),.write(write),.enable(enable),.sel(sel));
apb_master master(.clk(i_clk), .addr(addr), .enable(enable), .sel(sel), .wdata(dout), .write(write),.rdata(mem_in), 
    .pclk(pclk), .paddr(paddr), .penable(penable), .psel(psel), .pwdata(pwdata), .prdata(prdata), .pwrite(pwrite), .pready(pready));
mem_t memory_data (pclk, paddr, penable, psel, pwrite, pwdata, prdata); 
RTC_Slave uut(~pclk, 1'b0, pclk, i_rst_n, paddr, psel, penable, pwrite, 
                       pwdata, pready, prdata);



endmodule
