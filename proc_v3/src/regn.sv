module regn(R, Rin, Clock, Q);
//add reset
parameter n = 32;
input [n-1:0] R;
input Rin, Clock;
output [n-1:0] Q;
logic [n-1:0] Q;

always @(posedge Clock)
	if (Rin)
		Q <= R;

endmodule
