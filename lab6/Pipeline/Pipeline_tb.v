`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:27:30 02/21/2025
// Design Name:   Pipeline
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/EE533_Lab_6/Pipeline_tb.v
// Project Name:  EE533_Lab_6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Pipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Pipeline_tb;

	// Inputs
	reg [3:0] ALU_OP;
	reg clk;
	reg [63:0] ONE;
	reg rst;

	// Outputs
	wire [63:0] Dout_M;
	wire [63:0] Dout_WB;
	wire [63:0] PC;
	wire [63:0] PC_next;
	wire [2:0] Reg1_ID;
	wire [2:0] Reg2_ID;
	wire [63:0] R1_out_EX;
	wire [63:0] R1_out_ID;
	wire [7:0] R1_out_M;
	wire [63:0] R2_out_EX;
	wire [63:0] R2_out_ID;
	wire [63:0] R2_out_M;
	wire WMemEn_EX;
	wire WMemEn_ID;
	wire WMemEn_M;
	wire WRegEn_EX;
	wire WRegEn_ID;
	wire WRegEn_M;
	wire WRegEn_WB;
	wire [2:0] WReg1_EX;
	wire [2:0] WReg1_ID;
	wire [2:0] WReg1_M;
	wire [2:0] WReg1_WB;

	// Instantiate the Unit Under Test (UUT)
	Pipeline uut (
		.ALU_OP(ALU_OP), 
		.clk(clk), 
		.ONE(ONE), 
		.rst(rst), 
		.Dout_M(Dout_M), 
		.Dout_WB(Dout_WB), 
		.PC(PC), 
		.PC_next(PC_next), 
		.Reg1_ID(Reg1_ID), 
		.Reg2_ID(Reg2_ID), 
		.R1_out_EX(R1_out_EX), 
		.R1_out_ID(R1_out_ID), 
		.R1_out_M(R1_out_M), 
		.R2_out_EX(R2_out_EX), 
		.R2_out_ID(R2_out_ID), 
		.R2_out_M(R2_out_M), 
		.WMemEn_EX(WMemEn_EX), 
		.WMemEn_ID(WMemEn_ID), 
		.WMemEn_M(WMemEn_M), 
		.WRegEn_EX(WRegEn_EX), 
		.WRegEn_ID(WRegEn_ID), 
		.WRegEn_M(WRegEn_M), 
		.WRegEn_WB(WRegEn_WB), 
		.WReg1_EX(WReg1_EX), 
		.WReg1_ID(WReg1_ID), 
		.WReg1_M(WReg1_M), 
		.WReg1_WB(WReg1_WB)
	);

	always #50 clk = ~clk;

	initial begin
		// Initialize Inputs
		ALU_OP = 0;
		clk = 1;
		ONE = 1;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);

		@(posedge clk);
		$stop;

	end
      
endmodule