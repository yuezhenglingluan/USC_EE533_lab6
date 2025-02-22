`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:03:48 02/21/2025
// Design Name:   M_WB_Reg
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/M_WB_Reg_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: M_WB_Reg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module M_WB_Reg_tb;

	// Inputs
	reg clk;
	reg rst;
	reg WRegEn_M;
	reg [63:0] Dout_M;
	reg [2:0] WReg1_M;

	// Outputs
	wire WRegEn_WB;
	wire [63:0] Dout_WB;
	wire [2:0] WReg1_WB;

	// Instantiate the Unit Under Test (UUT)
	M_WB_Reg uut (
		.clk(clk),
		.rst(rst),
		.WRegEn_M(WRegEn_M),
		.Dout_M(Dout_M),
		.WReg1_M(WReg1_M),
		.WRegEn_WB(WRegEn_WB),
		.Dout_WB(Dout_WB),
		.WReg1_WB(WReg1_WB)
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
		WRegEn_M = 1;
		Dout_M = 64'd4;
		WReg1_M = 3'd2;

		@(posedge clk);
		WRegEn_M = 1;
		Dout_M = 64'd4;
		WReg1_M = 3'd3;

		@(posedge clk);
		WRegEn_M = 0;
		Dout_M = 64'd4;
		WReg1_M = 3'd0;

		@(posedge clk);
		WRegEn_M = 0;
		Dout_M = 64'd4;
		WReg1_M = 3'd0;

		@(posedge clk);
		WRegEn_M = 0;
		Dout_M = 64'd4;
		WReg1_M = 3'd0;

		@(posedge clk);
		WRegEn_M = 0;
		Dout_M = 64'd4;
		WReg1_M = 3'd0;

		@(posedge clk);

		@(posedge clk);
		$stop;

	end
      
endmodule

