`timescale 1ns / 1ps
 
module Monitor(BusInterface Bus_Int, RegistersInterface Reg_Int);

	//Input/Output Variables
    logic clk = Bus_Int.clk;
    logic reset = Bus_Int.reset;
    logic sel = Bus_Int.sel;
    logic enable = Bus_Int.enable;
    logic write = Bus_Int.write;
    logic [7:0] addr = Bus_Int.addr;
    logic [31:0] wdata = Bus_Int.wdata;
    logic [31:0] rdata = Bus_Int.rdata;
    logic ready = Bus_Int.ready;

	logic [2:0] current_mode;
	logic fail;
    //current_mode = 	
    	//000 if RTC is not on
    	//001 if RTC is doing a read
    	//010 if RTC is doing a write
    	//011 if RTC is doing a add alarm
    	//100 if RTC is doing a add/sub time
    	//101 INVALID
    	//110 N/A
    	//111 N/A

   //State Machine Data 
	localparam Idle = 2'b00;
	localparam Access = 2'b11;
	logic[1:0] c_state = Idle; //current state (initialize idle)
	logic[1:0] n_state = Idle; //next state (initialize idle)

	//Instantiate Scoreboard
	Scoreboard dut(Bus_Int, Reg_Int, current_mode, fail);


	//Current State Logic (update values on rising edge)
	always_ff @(posedge clk, negedge reset)
	begin
	    //If reset is active (0), go back to Idle
	    if(reset == 0) begin
	        c_state <= Idle;
	    end
	    //otherwise, advance to next state
	    else begin
	        c_state <= n_state;
	    end
	end //end always_ff


	//Next State Logic
	always_comb
	begin
	    case(c_state)

	    //If RTC is not currently selected
	    Idle: 
	      begin
	      	//if RTC not selected again, stay in IDLE
	      	current_mode <= 3'b000;

	      	//if RTC is being seletced, change state to ACTIVE
	      	if(sel == 1 & reset == 1) begin
	      		n_state <= Access;
	      	end else begin
	      		n_state <= Idle;
	      	end
	      end //end IDLE
	    
	    //if RTC is currently selected
	    Access: 
	      begin
	      	//Read
	      	if(write == 0) begin
	      		current_mode <= 3'b001;
	      	//Write
	      	end else if(write == 1 & addr == 8'b00000000) begin  //addr00
	      		current_mode <= 3'b010;
	      	//Add alarm
	      	end else if(write == 1 & addr == 8'b00000100) begin //addr04
	      		current_mode <= 3'b011;
	     	//Add/Sub time
	      	end else if(write == 1 & addr == 8'b00001000) begin //addr08
	      		current_mode <= 3'b100;
	      	//Improper operation selected 
	      	end else begin //any other address
	      		current_mode <= 3'b101;
	        end

	   		n_state <= Idle;
	      end //end Access

	    endcase // end Case

	end //end always_ff


endmodule