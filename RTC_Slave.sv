`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2020 09:26:09 AM
// Design Name: 
// Module Name: RTC_Slave
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


module RTC_Slave(ext_clk, clk_sel, pclk, preset, paddr, psel, penable, pwrite, 
                       pwdata, pready, prdata);

//Input/Output Variables
input ext_clk;
input clk_sel; //clock select (high = ext_clk, low = pclk)
input logic pclk, preset, psel, penable, pwrite;
input logic [7:0] paddr;
input logic [31:0] pwdata;
output logic pready;
output logic [31:0] prdata;

//State Machine Data 
localparam Idle = 2'b00;
localparam Access = 2'b11;
logic[1:0] c_state = Idle; //current state (initialize idle)
logic[1:0] n_state = Idle; //next state (initialize idle)

//RTC.sv Inputs
logic rtc_on;
logic clk;
logic[1:0] operation;

//RTC.sv outputs
logic alarm_signal;

//Instantiate RTC.sv
RTC dut(rtc_on, clk, preset, operation, pwdata, prdata, alarm_signal);

//Internal Variables
  
//clock vars
integer count; 
//Parameter
localparam clk_div = 32'd10;
logic curr_clk; //selected clock not divided
				//clk is the final divided clk

//intialize clock divider
initial begin
   count = 0; 
   clk = 0;
   $display("POOP");
end

//clock selection logic
always @ (posedge pclk, posedge ext_clk, negedge pclk, negedge ext_clk) 
begin
	if(clk_sel)
    begin
    	curr_clk = ext_clk;
    end else begin
    	curr_clk = pclk;  
    end
end

 //get a 1Hz clock from curr_clk (division)
always @ (posedge curr_clk) 
begin
    if (count == (clk_div - 1)) begin
        count <= 32'b0;
        clk <= ~clk;
    end else begin
        count <= count + 1;
    end
end 
  
//Current State Logic (update values on rising edge)
always_ff @(posedge clk, negedge preset)
begin
    //If reset is active (0), go back to Idle. Otherwise go to n_state
    if(preset == 0) begin
        c_state <= Idle;
    end

    //otherwise, advance to next state
    else begin
        c_state <= n_state;
    end
end //end always_ff

//Next State Logic (do logic for next state on falling edge)
always_comb
begin
    case(c_state)

   	//RTC is not currently selected
    Idle: 
      begin
      	//RTC is not turned on
      	rtc_on <= 0; 
      	operation <= 2'b0;

      	//write/read is not complete -> RTC not ready
      	pready <= 0; 

      	if(psel == 1 & preset == 1) begin
      		n_state <= Access;
      	end else begin
      		n_state <= Idle;
      	end
      end
      
    Access: 
      begin
      	//Read
      	if(pwrite == 0) begin
      		operation <= 2'b00;
      		rtc_on <= 1; 

      	//Write
      	end else if(pwrite == 1 & paddr == 8'b00000000) begin  //addr00
      		operation <= 2'b01;
      		rtc_on <= 1; 

      	//Add alarm
      	end else if(pwrite == 1 & paddr == 8'b00000100) begin //addr04
      		operation <= 2'b10;
      		rtc_on <= 1; 

     	//Add/Sub time
      	end else if(pwrite == 1 & paddr == 8'b00001000) begin //addr08
      		operation <= 2'b11;
      		rtc_on <= 1; 

      	//Improper operation selected 
      	end else begin //any other address
      		operation <= 2'b00;
      		rtc_on <= 0; 
        end

   		n_state <= Idle;
   		pready <= 1;

      end //end Access

    endcase // end Case

end //end always_ff
endmodule
