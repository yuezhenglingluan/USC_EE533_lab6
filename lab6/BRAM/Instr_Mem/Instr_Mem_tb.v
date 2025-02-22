`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:39:36 02/21/2025
// Design Name:   Instr_Mem
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/Instr_Mem_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Instr_Mem
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Instr_Mem_tb;

	// Inputs
	reg [8:0] addr;
	reg clk;

	// Outputs
	wire [31:0] dout;

	// Instantiate the Unit Under Test (UUT)
	Instr_Mem uut (
		.addr(addr), 
		.clk(clk), 
		.dout(dout)
	);

	always #50 clk = ~clk;

	initial begin
		// Initialize Inputs
		addr = 9'd255;
		clk = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		@(posedge clk);
		addr = 9'd0;

		@(posedge clk);
		addr = 9'd1;

		@(posedge clk);
		addr = 9'd2;

		@(posedge clk);
		addr = 9'd3;

		@(posedge clk);
		addr = 9'd4;

		@(posedge clk);
		addr = 9'd5;

		@(posedge clk);

		@(posedge clk);
		$stop;

	end
      
endmodule

