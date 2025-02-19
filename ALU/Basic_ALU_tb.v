module Basic_ALU_tb;
	//control Input
	reg AS, sub, Shift, shift_left, bytewiseAND, bytewiseOR;
	//data IO
	reg [31:0] A, B;
	wire [31:0] S;
	wire cout;

	initial begin
		#100 $stop;
	end
endmodule
