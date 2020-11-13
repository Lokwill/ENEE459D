`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2020 12:54:43 AM
// Design Name: 
// Module Name: proc_tb
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


module proc_old_tb();

logic [8:0] DIN;
logic Resetn, Clock, Run;
logic Done;
logic [8:0] BusWires;
logic [8:0] result;
logic [8:0] R [7:0];
logic [1:0] Tstep_Q; 
logic [1:0] Tstep_D;
logic IRin, DINout, Ain, Gout, Gin, AddSub;
logic [8:0] IR;
logic [1:3] I;
logic [7:0] Xreg, Yreg; 
logic [8:0] G;
logic [8:0] D_IN;
logic test1;
logic [8:0] test_input;
logic [7:0] Rout, Rin;  
logic [9:0] MUXsel; 
logic [8:0] mem [0:255];
logic [8:0] addr;
logic [8:0] dout;
logic pwrite;
logic penable;
lab9_old uut(.*);

task instr(input [8:0] opcode);
   begin
    @(negedge Clock);
    DIN = opcode;
    Run = 1;
    @(negedge Clock);
    Run = 0;
   // @(posedge Done);
  //  $display("Finished Instruction");
   // $display("Instruction: %b, R1: %h, R2: %h", opcode[8:6], opcode[5:3], opcode[2:0]);
   end
endtask;

task init_all_reg;
   begin
    @(negedge Clock);
    DIN = 9'b001000000;
    //test_input = 9'b000111000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;
    
    @(negedge Done); #1;
    
    @(negedge Clock);
    DIN = 9'b001001000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;

    @(negedge Clock);
    DIN = 9'b001010000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;
    
    @(negedge Clock);
    DIN = 9'b001011000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;
    
    @(negedge Clock);
    DIN = 9'b001100000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;
    
    @(negedge Clock);
    DIN = 9'b001101000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;
    
    @(negedge Clock);
    DIN = 9'b001110000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;
    
    @(negedge Clock);
    DIN = 9'b001111000;
    Run = 1;
    @(negedge Clock); 
    DIN = 9'b000000000; 
    Run = 0;
    
   end 
endtask

task mov_imm(input [8:0] opcode, input [8:0] Din);
   begin
    @(negedge Clock);
    DIN = opcode;
    Run = 1;
    @(negedge Clock); 
    DIN = Din; 
    Run = 0;
   end
endtask
    
initial begin
    #1;
    Clock = 0;
    Resetn = 1;
    Run = 0;
    #1;
    Resetn = 0;
    #3;
    Resetn = 1; 
                
    @(posedge Clock);
    init_all_reg;      
    @(posedge Clock);
    mov_imm(9'b001000000, 9'b000000111); //Move 7 into R0
    @(negedge Done); #1;
    
    @(posedge Clock);
    mov_imm(9'b001001000, 9'b000001001);//Move 9 into R1
    @(negedge Done); #1;
     
    @(posedge Clock);
    instr(9'b011000001); //R0 <- R0-R1
    @(negedge Done); #1;
    
    @(posedge Clock);
    instr(9'b000100000); //R4 <- R0
    @(negedge Done); #1;
    
    @(posedge Clock);
    instr(9'b100001010); //lw
    
    
end
   
always
    #5 Clock = ~Clock;    
    

endmodule