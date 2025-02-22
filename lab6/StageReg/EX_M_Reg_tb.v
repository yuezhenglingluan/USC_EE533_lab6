`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:35:26 02/21/2025
// Design Name:   EX_M_Reg
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/EX_M_Reg_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: EX_M_Reg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module EX_M_Reg_tb;

	// Inputs
	reg clk;
	reg rst;
	reg WRegEn_EX;
	reg WMemEn_EX;
	reg [63:0] R1_out_EX;
	reg [63:0] R2_out_EX;
	reg [2:0] WReg1_EX;

	// Outputs
	wire WRegEn_M;
	wire WMemEn_M;
	wire [7:0] R1_out_M;
	wire [63:0] R2_out_M;
	wire [2:0] WReg1_M;

	// Instantiate the Unit Under Test (UUT)
	EX_M_Reg uut (
		.clk(clk), 
		.rst(rst), 
		.WRegEn_EX(WRegEn_EX), 
		.WMemEn_EX(WMemEn_EX), 
		.R1_out_EX(R1_out_EX), 
		.R2_out_EX(R2_out_EX), 
		.WReg1_EX(WReg1_EX), 
		.WRegEn_M(WRegEn_M), 
		.WMemEn_M(WMemEn_M), 
		.R1_out_M(R1_out_M), 
		.R2_out_M(R2_out_M), 
		.WReg1_M(WReg1_M)
	);

	always #50 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 1;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		@(posedge clk);
		WRegEn_EX = 1;
		WMemEn_EX = 0;
		R1_out_EX = 64'd4;
		R2_out_EX = 64'd4;
		WReg1_EX = 3'd2;

		@(posedge clk);
		WRegEn_EX = 1;
		WMemEn_EX = 0;
		R1_out_EX = 64'd4;
		R2_out_EX = 64'd4;
		WReg1_EX = 3'd3;

		@(posedge clk);
		WRegEn_EX = 0;
		WMemEn_EX = 0;
		R1_out_EX = 64'd4;
		R2_out_EX = 64'd4;
		WReg1_EX = 3'd0;

		@(posedge clk);
		WRegEn_EX = 0;
		WMemEn_EX = 0;
		R1_out_EX = 64'd4;
		R2_out_EX = 64'd4;
		WReg1_EX = 3'd0;

		@(posedge clk);
		WRegEn_EX = 0;
		WMemEn_EX = 0;
		R1_out_EX = 64'd4;
		R2_out_EX = 64'd4;
		WReg1_EX = 3'd0;

		@(posedge clk);
		WRegEn_EX = 0;
		WMemEn_EX = 1;
		R1_out_EX = 64'd4;
		R2_out_EX = 64'd4;
		WReg1_EX = 3'd0;

		@(posedge clk);

		@(posedge clk);
		$stop;

	end
      
endmodule

