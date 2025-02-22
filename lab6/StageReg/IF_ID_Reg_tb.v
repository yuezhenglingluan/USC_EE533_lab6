`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:30:43 02/21/2025
// Design Name:   IF_ID_Reg
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/IF_ID_Reg_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IF_ID_Reg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IF_ID_Reg_tb;

	// Inputs
	reg clk;
	reg rst;
	reg WMemEn_IF;
	reg WRegEn_IF;
    reg [2:0] Reg1_IF;
    reg [2:0] Reg2_IF;
    reg [2:0] WReg1_IF;
    reg [20:0] Unused_IF;

	// Outputs
	wire WMemEn_ID;
    wire WRegEn_ID;
    wire [2:0] Reg1_ID;
    wire [2:0] Reg2_ID;
    wire [2:0] WReg1_ID;
    wire [20:0] Unused_ID;

	// Instantiate the Unit Under Test (UUT)
	IF_ID_Reg uut (
		.clk(clk),
		.rst(rst),
		.WMemEn_IF(WMemEn_IF),
		.WRegEn_IF(WRegEn_IF),
		.Reg1_IF(Reg1_IF),
		.Reg2_IF(Reg2_IF),
		.WReg1_IF(WReg1_IF),
		.Unused_IF(Unused_IF),
		.WMemEn_ID(WMemEn_ID),
		.WRegEn_ID(WRegEn_ID),
		.Reg1_ID(Reg1_ID),
		.Reg2_ID(Reg2_ID),
		.WReg1_ID(WReg1_ID),
		.Unused_ID(Unused_ID)
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
		WMemEn_IF = 1'b0;
		WRegEn_IF = 1'b1;
    	Reg1_IF = 3'd0;
    	Reg2_IF = 3'd0;
    	WReg1_IF = 3'd2;
    	Unused_IF = 21'd0;

		@(posedge clk);
		WMemEn_IF = 1'b0;
		WRegEn_IF = 1'b1;
    	Reg1_IF = 3'd0;
    	Reg2_IF = 3'd0;
    	WReg1_IF = 3'd3;
    	Unused_IF = 21'd0;

		@(posedge clk);
		WMemEn_IF = 1'b0;
		WRegEn_IF = 1'b0;
    	Reg1_IF = 3'd0;
    	Reg2_IF = 3'd0;
    	WReg1_IF = 3'd0;
    	Unused_IF = 21'd0;

		@(posedge clk);
		WMemEn_IF = 1'b0;
		WRegEn_IF = 1'b0;
    	Reg1_IF = 3'd0;
    	Reg2_IF = 3'd0;
    	WReg1_IF = 3'd0;
    	Unused_IF = 21'd0;

		@(posedge clk);
		WMemEn_IF = 1'b0;
		WRegEn_IF = 1'b0;
    	Reg1_IF = 3'd0;
    	Reg2_IF = 3'd0;
    	WReg1_IF = 3'd0;
    	Unused_IF = 21'd0;

		@(posedge clk);
		WMemEn_IF = 1'b1;
		WRegEn_IF = 1'b0;
    	Reg1_IF = 3'd2;
    	Reg2_IF = 3'd3;
    	WReg1_IF = 3'd0;
    	Unused_IF = 21'd0;

		$stop;

	end
      
endmodule

