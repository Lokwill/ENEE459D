`timescale 1ns / 1ps

module Scoreboard(BusInterface Bus_Int, RegistersInterface Reg_Int, input logic current_mode, output logic fail);
 
 //Access & assign current clock/alarm registers 
 	//APB bus inteface
	logic clk = Bus_Int.clk;
	logic reset = Bus_Int.reset;
	logic sel= Bus_Int.sel;
	logic enable = Bus_Int.enable;
	logic write = Bus_Int.write;
	logic [7:0] addr = Bus_Int.addr;
	logic [31:0] wdata = Bus_Int.wdata;
	logic ready = Bus_Int.ready;
	logic [31:0] rdata = Bus_Int.rdata;
	//regisetr interface
	logic [31:0] sec = Reg_Int.sec;
	logic [31:0] min = Reg_Int.min;
	logic [31:0] hr = Reg_Int.hr;
	logic [31:0] day = Reg_Int.day;
	logic [31:0] yr = Reg_Int.yr;
	logic [31:0] curr_time = Reg_Int.curr_time;
	logic [31:0] alarm1 = Reg_Int.alarm1;
	logic [31:0] alarm2 = Reg_Int.alarm2;
	logic [31:0] alarm3 = Reg_Int.alarm3;
	logic [31:0] alarm4 = Reg_Int.alarm4;

//Implement the check task to check the scoreboard.
	task check;
      	//Reset
      	if(reset == 0) begin
      		if(sec!=0 | min!=0 | hr!=0 | day!=0 | yr!=0 | curr_time!=32'b0) begin
      			fail <= 1'b1;
      			$display("Failed RESET");
      		end
      	//Read
      	end else if(current_mode == 3'b001) begin
      		if(rdata != curr_time) begin
      			fail <= 1'b1;
      			$display("Failed READ");
      		end
      	//Write
      	end else if(current_mode == 3'b010) begin 
      		if(curr_time != wdata) begin
      			fail <= 1'b1;
      			$display("Failed WRITE");
      		end

      	//Add alarm
      	end else if(current_mode == 3'b011) begin 
      		if(alarm1[31:14] != {wdata[31:15], 1'b1} && alarm2[31:14] != {wdata[31:15], 1'b1} && alarm3[31:14] != {wdata[31:15], 1'b1} && alarm3[31:14] != {wdata[31:15], 1'b1}) begin
      			fail <= 1'b1;
      			$display("Failed ALARM");
      		end

     	//Add/Sub time
      	end else if(current_mode == 3'b100) begin
      		if(curr_time != wdata) begin
      			fail <= 1'b1;
      			$display("Failed ADD/SUB");
      		end


      	//Improper operation selected 
      	end else if(current_mode == 3'b101) begin
      			$display("Invalid Operation Selected");
      		

      	//No operation selected 
      	end else begin //any other address
      			$display("RTC not active");

        end

    endtask : check

	
	always_ff @(posedge clk, negedge reset)
		begin
			check;	
		end //end always_ff
	
endmodule