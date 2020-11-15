
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2020 06:31:11 PM
// Design Name: 
// Module Name: RTC_tb
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


module RTC_tb();
//Inputs to RTC
logic rtc_on; //only do operations if this is on
logic clk; //1 Hz clock
logic resetn; //active Low
logic [1:0] operation; //00=read, 01=write, 10=alarm, 11=add/sub time 
logic [31:0] w_data;

//Output of RTC
logic [31:0] r_data;
logic alarm; //1 = alarm going off, 0 = otherwise

//Parameter
localparam PERIOD = 10;

//instantiate RTC
RTC unit1(rtc_on, clk, resetn, operation, w_data, r_data, alarm);


//establish clk
always
begin
   clk= 1; #(PERIOD/2); clk= 0; #(PERIOD/2);// 10ns period
end

//Write
task write; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
	input [8:0] day_in;
	input [5:0] yr_in;
    begin
        //setup and input data
        rtc_on = 1'b1;
        @ (negedge clk);
	    rtc_on = 1'b1;
        resetn = 1'b1;
        w_data = {sec_in, min_in, hr_in, day_in, yr_in};
        operation = 2'b01;    
        #PERIOD rtc_on = 1'b0;
    end
endtask

//Read
task read; 
    begin
        //setup
        @ (negedge clk);
	    rtc_on = 1'b1;
        resetn = 1'b1;
        operation = 2'b00;
        #PERIOD rtc_on = 1'b0;
    end
endtask

//Alarm
task add_alarm; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
    begin
        //setup and input data
        @ (negedge clk);
	    rtc_on = 1'b1;
        resetn = 1'b1;
        w_data = {sec_in, min_in, hr_in, 1'b1, 14'b0};
        operation = 2'b10;
        #PERIOD rtc_on = 1'b0;
    end
endtask

//add time
task add_time; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
	input [8:0] day_in;
    begin
        //setup and input data
        @ (negedge clk);
	    rtc_on = 1'b1;
        resetn = 1'b1;
        w_data = {sec_in, min_in, hr_in, day_in, 1'b1, 1'b0, 4'b0};
        operation = 2'b11;
        #PERIOD rtc_on = 1'b0;
    end
endtask

//subtract time
task sub_time; 
    input [5:0] sec_in;
	input [5:0] min_in;
	input [4:0] hr_in;
	input [8:0] day_in;
    begin
        //setup and input data
        @ (negedge clk);
	    rtc_on = 1'b1;
        resetn = 1'b1;
        w_data = {sec_in, min_in, hr_in, day_in, 1'b0, 1'b0, 4'b0};
        operation = 2'b11;
        operation = 2'b11;
        #PERIOD rtc_on = 1'b0;
    end
endtask

//reset
task reset; 
    begin
	    resetn = 0;
	    #(2*PERIOD)
	    resetn = 1;
    end
endtask





initial
begin
    @(negedge clk);
    //initialize values at 0 (make sure slave doesnt do anything)
    reset();

    #PERIOD write(6'b000001, 6'b000001, 5'b00001, 9'b000000001, 6'b000001);
    #PERIOD read ();
    
    #PERIOD add_alarm(6'b000001, 6'b000011, 5'b00001);
    #PERIOD add_alarm(6'b000011, 6'b000011, 5'b00001);
    #PERIOD add_alarm(6'b000111, 6'b000011, 5'b00001);
    #PERIOD add_alarm(6'b001111, 6'b000011, 5'b00001);
    #PERIOD add_alarm(6'b000111, 6'b000011, 5'b00001);

	#PERIOD add_time(6'd59, 6'd59, 5'd23, 9'd364);
	#PERIOD sub_time(6'd2, 6'd2, 5'd2, 9'd2);
	
	#PERIOD reset();
	#PERIOD write(6'd2, 6'd2, 5'd2, 9'd2, 6'd2);
    #PERIOD read ();


    
    #5 rtc_on = 1'b0;
    

end 
endmodule
