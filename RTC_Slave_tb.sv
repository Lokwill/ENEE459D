`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2020 09:26:09 AM
// Design Name: 
// Module Name: RTC_Slave_tb
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

module RTC_Slave_tb();
//Inputs to slave
logic pclk, preset, pwrite, psel, penable;
logic [7:0] paddr;
logic [31:0] pwdata;

//Output of slave
logic pready;
logic [31:0] prdata;

//Parameter
localparam PERIOD = 100;

//instantiate slave
RTC_Slave uut(~pclk, 1'b0, pclk, preset, paddr, psel, penable, pwrite, 
                       pwdata, pready, prdata);

//establish clk
always
begin
   pclk= 1; #5; pclk= 0; #5;// 10ns period
end

//Read
task read; 
    begin
        $display("read");
        //Setup
        @ (posedge pclk);
        preset = 1'b1;
        paddr = 8'b11111111; //doesnt matter
        pwrite = 1'b0;
        psel = 1'b1;
        penable = 1'b0;;
         
        //Access
        #1 @ (posedge pclk);
        penable = 1'b1;
        
        //Back to Idle
        @ (negedge pready)
        psel = 1'b0;
        penable = 1'b0;
    end
endtask

//Write
task write; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
	input [8:0] day_in;
	input [5:0] yr_in;
    begin
        $display("write");
        //Setup
        @ (posedge pclk);
        preset = 1'b1;
        paddr = 8'b00000000;
        pwrite = 1'b1;
        psel = 1'b1;
        penable = 1'b0;
        pwdata = {sec_in, min_in, hr_in, day_in, yr_in};
        
        //Access
        #1 @ (posedge pclk);
        penable = 1'b1;
        
        //Back to Idle
        @ (negedge pready)
        psel = 1'b0;
        penable = 1'b0;
    end
endtask

//Add alarm
task add_alarm; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
    begin
        $display("add alarm");
        //Setup
        @ (posedge pclk);
        preset = 1'b1;
        paddr = 8'b00000100;
        pwrite = 1'b1;
        psel = 1'b1;
        penable = 1'b0;
        pwdata = {sec_in, min_in, hr_in, 1'b1, 14'b0};
        
        //Access
        #1 @ (posedge pclk);
        penable = 1'b1;
        
        //Back to Idle
        @ (negedge pready)
        psel = 1'b0;
        penable = 1'b0;
    end
endtask

//Add time
task add_time; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
	input [8:0] day_in;
    begin
        $display("add time");
        //Setup
        @ (posedge pclk);
        preset = 1'b1;
        paddr = 8'b00001000;
        pwrite = 1'b1;
        psel = 1'b1;
        penable = 1'b0;
        pwdata = {sec_in, min_in, hr_in, day_in, 1'b1, 1'b0, 4'b0};
        
        //Access
        #1 @ (posedge pclk);
        penable = 1'b1;
        
        //Back to Idle
        @ (negedge pready)
        psel = 1'b0;
        penable = 1'b0;
    end
endtask

//Sub time
task sub_time; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
	input [8:0] day_in;
    begin
        $display("sub time");
        //Setup
        @ (posedge pclk);
        preset = 1'b1;
        paddr = 8'b00001000;
        pwrite = 1'b1;
        psel = 1'b1;
        penable = 1'b0;
        pwdata = {sec_in, min_in, hr_in, day_in, 1'b0, 1'b0, 4'b0};
        
        //Access
        #1 @ (posedge pclk);
        penable = 1'b1;
        
        //Back to Idle
        @ (negedge pready)
        psel = 1'b0;
        penable = 1'b0;
    end
endtask

//reset
task reset; 
    begin
        $display("reset");
        //Setup
        @ (negedge pclk);
        preset = 1'b0;
        psel = 1'b1;
        penable = 1'b0;

        
        //Back to Idle
        #PERIOD
        preset = 1'b1;
        psel = 1'b0;
        penable = 1'b0;

    end
endtask


//tests
initial
begin
	
    @(negedge pclk);

    reset();

    #PERIOD write(6'b000001, 6'b000001, 5'b00001, 9'b000000001, 6'b000001);
    #PERIOD read ();
    
    #PERIOD add_alarm(6'b000001, 6'b000011, 5'b00001); //32'h 0430c000
    #PERIOD add_alarm(6'b000011, 6'b000011, 5'b00001); //32'h 0c30c000
    #PERIOD add_alarm(6'b000111, 6'b000011, 5'b00001); //32'h 1c30c000
    #PERIOD add_alarm(6'b001111, 6'b000011, 5'b00001); //32'h 3c30c000
    #PERIOD add_alarm(6'b000111, 6'b000011, 5'b00001); //32'h 1c30c000 (repeat)

	#PERIOD add_time(6'd59, 6'd59, 5'd23, 9'd364);
	#PERIOD sub_time(6'd2, 6'd2, 5'd2, 9'd2);
	/*
	#PERIOD reset();
	#PERIOD write(6'd2, 6'd2, 5'd2, 9'd2, 6'd2);
    #PERIOD read ();
	*/
    //alarm test
	#PERIOD write(6'b000000, 6'b000011, 5'b00001, 9'd2, 6'd2);
	
end 
endmodule

