`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 08:34:33 PM
// Design Name: 
// Module Name: proc_tb2
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


module proc_tb2();

logic [8:0] DIN;
logic Resetn, Clock, Run;
logic Done;
logic [8:0] BusWires;
logic [8:0] result;
logic [8:0] R [7:0];
logic [1:0] Tstep_Q; 
logic [1:0] Tstep_D;
/*logic IRin, DINout, Ain, Gout, Gin, AddSub;
logic [8:0] IR;
logic [1:3] I;
logic [7:0] Xreg, Yreg; 
logic [8:0] G;
logic [8:0] D_IN;
logic [7:0] test1;
logic [8:0] test_input;
logic [7:0] Rout, Rin;  
logic [9:0] MUXsel; 
logic [8:0] mem_data [0:255];
logic [8:0] mem_instr [0:255];
logic [8:0] addr;
logic [8:0] dout;
logic pwrite;
logic penable;
logic [8:0] pc;
logic [8:0] instr; */
lab9 uut1(.*);



initial begin
    #1;
    Clock = 0;
    Resetn = 1;
    Run = 0;
    #1;
    Resetn = 0;
    #5;
    Resetn = 1; 
    
    @(negedge Clock); 
    DIN = 9'b000100100; 
    @(negedge Clock);
    @(negedge Clock);
    @(negedge Clock);

    
    @(negedge Done); #1;
    
    @(negedge Clock);
    DIN = 9'b000001000; 
    @(negedge Done); #1;
    @(negedge Clock);
    @(negedge Clock);
    DIN = 9'b000100000; 
    @(negedge Done); #1;
    @(negedge Clock);
    @(negedge Clock);
    DIN = 9'b000000000; 
    @(negedge Done); #1;
    @(negedge Clock);
    @(negedge Clock);
    DIN = 9'b011000000; 
    @(negedge Done); #1;
    @(negedge Clock);
    @(negedge Clock);
    DIN = 9'b000000000; 
    @(negedge Done); #1;
    @(negedge Clock);
    @(negedge Clock);
    DIN = 9'b000000011; 
    @(negedge Done); #1;
    @(negedge Clock);
    @(negedge Clock);
    DIN = 9'b000011000; 
    @(negedge Done); #1;
    
 end

always #5 Clock = ~Clock;

endmodule
