`timescale 1ns / 1ps

interface BusInterface;
	logic clk, reset, sel, enable, write;
	logic [7:0] addr;
	logic [31:0] wdata;
	logic ready;
	logic [31:0] rdata;
endinterface

interface RegistersInterface;
	logic [31:0] sec;
	logic [31:0] min;
	logic [31:0] hr;
	logic [31:0] day;
	logic [31:0] yr;
	logic [31:0] curr_time;
	logic [31:0] alarm1 ;
	logic [31:0] alarm2 ;
	logic [31:0] alarm3 ;
	logic [31:0] alarm4 ;
endinterface

module top_level_tb();
	logic i_clk;
	logic i_rst_n;

	top_level DesignTop(.i_clk(i_clk),.i_rst_n(i_rst_n));

	BusInterface Bus_Int(); //instance the interface
	RegistersInterface Reg_Int(); //instance the interface

	Monitor Mon_Module (Bus_Int, Reg_Int); //connect it

	//RTC Registers
	assign sec = DesignTop.uut.dut.sec;
	assign min = DesignTop.uut.dut.min;
	assign hr = DesignTop.uut.dut.hr;
	assign day = DesignTop.uut.dut.day;   //drive the interface
	assign yr = DesignTop.uut.dut.yr;
	assign curr_time = DesignTop.uut.dut.curr_time;
	assign alarm1 = DesignTop.uut.dut.alarm1;
	assign alarm2 = DesignTop.uut.dut.alarm2;
	assign alarm3 = DesignTop.uut.dut.alarm3;
	assign alarm4 = DesignTop.uut.dut.alarm4;

	//APB Bus
	assign clk = DesignTop.pclk;
	assign reset = DesignTop.preset;
	assign sel = DesignTop.psel;
	assign enable = DesignTop.penable;
	assign addr = DesignTop.paddr;
	assign wdata = DesignTop.pwdata;
	assign ready = DesignTop.pready;
	assign rdata = DesignTop.prdata;



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