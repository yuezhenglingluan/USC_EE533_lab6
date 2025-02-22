`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:04:47 02/21/2025
// Design Name:   ID_EX_Reg
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/ID_EX_Reg_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ID_EX_Reg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ID_EX_Reg_tb;

	// Inputs
	reg clk;
	reg rst;
	reg WRegEn_ID;
	reg WMemEn_ID;
	reg [63:0] R1_out_ID;
	reg [63:0] R2_out_ID;
	reg [2:0] WReg1_ID;

	// Outputs
	wire WRegEn_EX;
	wire WMemEn_EX;
	wire [63:0] R1_out_EX;
	wire [63:0] R2_out_EX;
	wire [2:0] WReg1_EX;

	// Instantiate the Unit Under Test (UUT)
	ID_EX_Reg uut (
		.clk(clk), 
		.rst(rst), 
		.WRegEn_ID(WRegEn_ID), 
		.WMemEn_ID(WMemEn_ID), 
		.R1_out_ID(R1_out_ID), 
		.R2_out_ID(R2_out_ID), 
		.WReg1_ID(WReg1_ID), 
		.WRegEn_EX(WRegEn_EX), 
		.WMemEn_EX(WMemEn_EX), 
		.R1_out_EX(R1_out_EX), 
		.R2_out_EX(R2_out_EX), 
		.WReg1_EX(WReg1_EX)
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
		WRegEn_ID = 1;
		WMemEn_ID = 0;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd2;

		@(posedge clk);
		WRegEn_ID = 1;
		WMemEn_ID = 0;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd3;

		@(posedge clk);
		WRegEn_ID = 0;
		WMemEn_ID = 0;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd0;

		@(posedge clk);
		WRegEn_ID = 0;
		WMemEn_ID = 0;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd0;

		@(posedge clk);
		WRegEn_ID = 0;
		WMemEn_ID = 0;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd0;

		@(posedge clk);
		WRegEn_ID = 0;
		WMemEn_ID = 1;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd0;

		@(posedge clk);

		@(posedge clk);
		$stop;

	end
      
endmodule

