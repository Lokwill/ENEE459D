module smallALU(add_sub,dataa, datab, result);

input add_sub;
input signed [8:0] dataa, datab;
output logic signed [8:0] result;

always @(*)
begin
	if(add_sub) begin
		result = dataa + datab;
	end else begin
		result = dataa + (~datab+1'b1);
	end
end
endmodule
	