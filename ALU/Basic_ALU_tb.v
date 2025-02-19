// Code your testbench here
// or browse Examples
module Basic_ALU_tb;
	//control Input
	reg [3:0] control;
	//data IO
	reg [31:0] A, B;
	wire [31:0] Out;
	wire overflow;
	wire [1:0] compare_result;

	Basic_ALU uut(
		.A(A),
		.B(B),
		.Out(Out),
		.overflow(overflow),
		.control(control)
	);

	initial begin
		$monitor("A=%d; B =%d; control = %b; Out = %d; overflow = %b", A, B, control, Out, overflow);
		// test addition
		#0  A = 32'd10; B = 32'd10; control = 4'b0001;
		#10 A = 32'hFFFF_FFFF; B = 32'h0001;
		#10 A = 32'h0001; B = 32'hFFFF;

		// test subtraction
		#10 A = 32'd20; B = 32'd20; control = 3'b0010;
		#10 A = 32'd30; B = 32'd5;
		#10 A = 32'hFFFF; B = 32'hFFFF;

		// test bitwise and
		#10 A = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
			B = 32'b1010_1010_1010_1010_1010_1010_1010_1010;
			control = 4'b0011;

		// test bitwise or
		#10 A = 32'b1010_1010_1010_1010_1010_1010_1010_1010;
			B = 32'b0101_0101_0101_0101_0101_0101_0101_0101;
			control = 4'b0100;

		// test bitwise xnor
		#10 A = 32'hFFFF;
			B = 32'hFFFF;
			control = 4'b0101;

		// test compare
		#10 A = 10; B = 20; control = 4'b0110;
		#10 A = 20; B = 5;
		#10 A = 2; B = 2;

		// test logical shift left
		#10 A = 32'b1111_1111_1111_1111_1111_1111_1111_1111; control = 4'b0111;

		// test logical shift right
		#10 A = 32'b1111_0000_1111_1010_1111_0000_1111_1010; control = 4'b1000;

		// test default beahvior
		#10 control = 4'b1111;

		#100 $stop;
	end
endmodule
