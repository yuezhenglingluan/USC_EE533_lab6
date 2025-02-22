`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:46:12 02/21/2025
// Design Name:   Data_Mem
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/Data_Mem_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Data_Mem
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Data_Mem_tb;

	// Inputs
	reg [7:0] addra;
	reg [7:0] addrb;
	reg clka;
	reg clkb;
	reg [63:0] dina;
	reg wea;

	// Outputs
	wire [63:0] doutb;

	// Instantiate the Unit Under Test (UUT)
	Data_Mem uut (
		.addra(addra), 
		.addrb(addrb), 
		.clka(clka), 
		.clkb(clkb), 
		.dina(dina), 
		.doutb(doutb), 
		.wea(wea)
	);

	always #50 clka = ~clka;
	always #50 clkb = ~clkb;

	initial begin
		// Initialize Inputs
		addra = 8'd255;
		addrb = 8'd255;
		clka = 1;
		clkb = 1;
		dina = 0;
		wea = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		@(posedge clka);
		addra = 8'd0;
		addrb = 8'd0;

		@(posedge clka);
		addra = 8'd1;
		addrb = 8'd1;

		@(posedge clka);
		addra = 8'd2;
		addrb = 8'd2;

		@(posedge clka);
		addra = 8'd3;
		addrb = 8'd3;

		@(posedge clka);
		addra = 8'd4;
		addrb = 8'd4;

		@(posedge clka);

		@(posedge clka);
		$stop;

	end
      
endmodule

