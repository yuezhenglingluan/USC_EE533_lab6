`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:18:38 02/19/2025
// Design Name:   ALU
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/ALU_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_tb;

	// Inputs
	reg [63:0] A;
	reg [63:0] B;
	reg [3:0] aluctrl;
	reg clk;

	// Outputs
	wire [63:0] ALU_Out;
	wire Zero_Flag;
	wire Overflow;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.A(A), 
		.B(B), 
		.aluctrl(aluctrl), 
		.clk(clk), 
		.ALU_Out(ALU_Out), 
		.Zero_Flag(Zero_Flag), 
		.Overflow(Overflow)
	);

	always #50 clk = ~clk;

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		aluctrl = 0;
		clk = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		A = 64'd1;
		B = 64'd3;
		aluctrl = 4'b0000;
		#100;
		
		A = 64'd4;
		B = 64'd2;
		aluctrl = 4'b0001;
		#100;
		
		A = 64'd5;
		B = 64'd7;
		aluctrl = 4'b0010;
		#100;

		A = 64'd8;
		B = 64'd3;
		aluctrl = 4'b0011;
		#100;

		A = 64'd13;
		B = 64'd3;
		aluctrl = 4'b0100;
		#100;

		A = 64'd5;
		B = 64'd5;
		aluctrl = 4'b0101;
		#100;

		A = 64'd4;
		B = 64'd2;
		aluctrl = 4'b0110;
		#100;

		A = 64'd256;
		B = 64'd4;
		aluctrl = 4'b0111;
		#100;

		A = 64'd15;
		B = 64'd3;
		aluctrl = 4'b1000;
		#100;

		A = 64'd15;
		B = 64'd5;
		aluctrl = 4'b1001;
		#100;

		$stop;

	end
      
endmodule

