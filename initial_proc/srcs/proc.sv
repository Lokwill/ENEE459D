`timescale 1ns / 1ps

module lab9(DIN, Resetn, Clock, Run, Done, BusWires, 
R, result, Tstep_Q, Tstep_D, IRin, DINout, Ain, Gout, Gin, AddSub, IR, I, Xreg, Yreg, G, MUXsel,
D_IN, test1, test_input, Rout, Rin);
input [8:0] DIN;
input [8:0] test_input;
input Resetn, Clock, Run;
output logic Done;
output logic [8:0] BusWires;
output logic [8:0] R [7:0];
output logic [8:0] result;
output logic [1:0] Tstep_Q; 
output logic [1:0] Tstep_D;
output logic IRin, DINout, Ain, Gout, Gin, AddSub;
output logic [8:0] IR;
output logic [1:3] I;
output logic [7:0] Xreg, Yreg;
output logic [8:0] G;
output logic [8:0] D_IN; // register used
output test1;
output logic [7:0] Rout, Rin; 
output logic [9:0] MUXsel; 
 parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;

//. . . declare variables
//  logic IRin, DINout, Ain, Gout, Gin, AddSub;
//  logic [7:0] Rout, Rin;    
 // logic [1:3] I;

 // logic [8:0] R0, R1, R2, R3, R4, R5, R6, R7, result;
  logic [8:0] A;
  //new signals and buses for lw and sw, rtc, memory, instruction counter instead of load
  logic incr_pc, addr_in, dout_in;
  logic [8:0] addr;
  logic [8:0] dout;
  logic penable;
  logic psel;
  logic pwrite;
  logic [8:0] mem_in;
  logic get_mem; //control signal to select between memory input, or instruction/mov_imm input


assign test1 = Resetn;
assign I = IR[8:6];
dec3to8 decX (IR[5:3], 1'b1, Xreg);
dec3to8 decY (IR[2:0], 1'b1, Yreg);
	
// Control FSM state table
always_comb //changed from the always @(Run, T_step...)
begin
	case (Tstep_Q)
		T0: // data is loaded into IR in this time step
			if (!Run) Tstep_D = T0;
			else Tstep_D = T1;
		T1: begin
			if (Done) Tstep_D = T0;
			else Tstep_D = T2;
		end
		T2: begin
			if (Done) Tstep_D = T0;
			else Tstep_D = T3;
		end
		T3: begin
			if (Done) Tstep_D = T0;
			else Tstep_D = T3;
		end
		default: Tstep_D = T0;
	endcase
end

// Control FSM outputs
always_comb// @(Tstep_Q or I or Xreg or Yreg)
begin
		Done = 0;
		AddSub = 0;
	    IRin = 0;
		Rout[7:0] = 8'b00000000;
		Rin[7:0] = 8'b00000000;
		DINout = 1'b0;
		Ain = 1'b0;
		Gout = 1'b0;
		Gin = 1'b0;
		penable = 0;
		addr_in = 0;
		psel = 0;
		pwrite = 0;
		get_mem = 0;
//	. . . specify initial values
	case (Tstep_Q)
		T0: // store DIN in IR in time step 0
		begin
		IRin = 1'b1; 
		end
		T1: //define signals in time step 1
		case (I)
		  3'b000: //mov
          begin
            Rout = Yreg;
            Rin = Xreg;
            Done = 1'b1;
          end
          3'b001: //movi
          begin
            DINout = 1'b1;
            Rin = Xreg;
            Done = 1'b1;
          end
          3'b010: //add
          begin
            Rout = Xreg;
            Ain = 1'b1;
          end
          3'b011: //sub
          begin
            Rout = Xreg;
            Ain = 1'b1;
          end
          3'b100: //lw: Ry <- [Rx]
          begin
            Rout = Xreg;
            addr_in = 1'b1;
            pwrite = 0;            
          end
          3'b101: //sw [Ry] <- [Rx]
          begin
            Rout = Xreg;
            pwrite = 1;
          end
		  default: begin
			Gin = 0; 
		  end
		//. . .
			endcase
		T2: //define signals in time step 2
		case (I)
		  3'b010:
          begin
            Rout = Yreg;
            Gin = 1'b1;
          end
          3'b011:
          begin
            Rout = Yreg;
            Gin = 1'b1;
            AddSub = 1'b1;
          end
          3'b100:
          begin
            penable = 1;
          end
		  default: begin
		    Gin = 0;
		  end
		//. . .
			endcase
		T3: //define signals in time step 3
		case (I)
		  3'b010:
          begin
            Gout = 1'b1;
            Rin = Xreg;
            Done = 1'b1;
          end
          3'b011:
          begin
            Gout = 1'b1;
            Rin = Xreg;
            Done = 1'b1;
		  end
	      3'b100:
	      begin
	        DINout = 1'b1;
	        get_mem = 1'b1;
	        Rin = Yreg; //i think this should work
	        Done = 1'b1;
	      end
		  default: begin
			Gout = 0;
		  end
		//. . .
			endcase
	endcase
end

// Control FSM flip-flops
always @(posedge Clock, negedge Resetn)
begin
	if (!Resetn)
		Tstep_Q <=0;
	else begin
		Tstep_Q <= Tstep_D;
	end
end

regn reg_0 (BusWires, Rin[0], Clock, R[7]);
regn reg_1 (BusWires, Rin[1], Clock, R[6]);
regn reg_2 (BusWires, Rin[2], Clock, R[5]);
regn reg_3 (BusWires, Rin[3], Clock, R[4]);
regn reg_4 (BusWires, Rin[4], Clock, R[3]);
regn reg_5 (BusWires, Rin[5], Clock, R[2]);
regn reg_6 (BusWires, Rin[6], Clock, R[1]);
regn reg_7 (BusWires, Rin[7], Clock, R[0]);

regn reg_IR (D_IN, IRin, Clock, IR); //instruction register - will be changed to pc
//always @(posedge Clock)
//	if (IRin==1)
//		IR <= 0;
regn reg_G (result, Gin, Clock, G); //register to store contents of ALU
regn reg_A (BusWires, Ain, Clock, A); //register to store output of register for ALU, change
regn reg_addr (BusWires, addr_in, Clock, addr); //register to store address for mem

mem memory (Clock, addr, penable, pwrite, dout, mem_in); // this is problematic, but I don't know how to fix it!

smallALU myALU(!(AddSub), A, BusWires, result);

//multiplexer to choose between R0-R7, DIN, and G
always @ (MUXsel or Rout or Gout or DINout or D_IN)
  begin
    MUXsel[9:2] = Rout;
    MUXsel[1] = Gout;
    MUXsel[0] = DINout; 
    
    case (MUXsel)
      10'b0000000001: BusWires = D_IN;
      10'b0000000010: BusWires = G;
      10'b0000000100: BusWires = R[7];
      10'b0000001000: BusWires = R[6];
      10'b0000010000: BusWires = R[5];
      10'b0000100000: BusWires = R[4];
      10'b0001000000: BusWires = R[3];
      10'b0010000000: BusWires = R[2];
      10'b0100000000: BusWires = R[1];
      10'b1000000000: BusWires = R[0];
   	default: BusWires = 0;
		endcase
end

//Multiplexer to choose between data/instr from memory or mov_imm input
always_comb
    if(get_mem)
        D_IN = mem_in;
    else
        D_IN = DIN;

endmodule
