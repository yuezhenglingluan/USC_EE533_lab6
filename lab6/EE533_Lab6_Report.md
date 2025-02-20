# EE533_Lab6_Report

## 1. Extending Synchronous Adder into ALU

### 1.1 Verilog of 64-bit ALU

```verilog
module ALU (
    input  [63:0] A,
    input  [63:0] B,
    input  [3:0]  aluctrl,
    input         clk,
    output reg [63:0] ALU_Out,
    output reg Zero_Flag,
    output reg Overflow
);
    
    reg [63:0] ALU_Reg;
    
    always @(posedge clk) begin
        case (aluctrl)
            4'b0000: begin
                {Overflow, ALU_Reg} = A + B;
            end
            4'b0001: begin
                {Overflow, ALU_Reg} = A - B;
            end
            4'b0010: ALU_Reg = A & B;              
            4'b0011: ALU_Reg = A | B;              
            4'b0100: ALU_Reg = A ^~ B;             
            4'b0101: ALU_Reg = (A == B) ? 64'b1 : 64'b0; 
            4'b0110: ALU_Reg = A << B[5:0];       
            4'b0111: ALU_Reg = A >> B[5:0];    
            4'b1000: ALU_Reg = substring_match(A, B);
            4'b1001: ALU_Reg = shift_then_compare(A, B);
            default: ALU_Reg = 64'b0;
        endcase
        
        Zero_Flag = (ALU_Reg == 64'b0) ? 1'b1 : 1'b0;
        
        ALU_Out = ALU_Reg;
    end
    
    function [63:0] substring_match;
        input [63:0] A, B;
        integer i;
        begin
            substring_match = 64'b0;
            for (i = 0; i < 64; i = i + 1) begin
                if ((A >> i) & B == B) begin
                    substring_match = 64'b1;
                end
            end
        end
    endfunction
    
    function [63:0] shift_then_compare;
        input [63:0] A, B;
        integer i;
        begin
            shift_then_compare = 64'b0;
            for (i = 0; i < 64; i = i + 1) begin
                if ((A >> i) == B) begin
                    shift_then_compare = 64'b1;
                end
            end
        end
    endfunction
endmodule
```

### 1.2 ALU Control Signal Table

| aluctrl |     Operation      |  A   |  B   | Expected Output |
| :-----: | :----------------: | :--: | :--: | :-------------: |
| 4'b0000 |        ADD         |  1   |  3   |        4        |
| 4'b0001 |        SUB         |  4   |  2   |        2        |
| 4'b0010 |        AND         |  5   |  7   |        5        |
| 4'b0011 |         OR         |  8   |  3   |       11        |
| 4'b0100 |        XNOR        |  13  |  3   |       -15       |
| 4'b0101 |      Compare       |  5   |  5   |        1        |
| 4'b0110 |     Left Shift     |  4   |  2   |       16        |
| 4'b0111 |    Right Shift     | 256  |  4   |       16        |
| 4'b1000 | Substring Compare  |  15  |  3   |        1        |
| 4'b1001 | Shift-then-Compare |  15  |  3   |        0        |



### 1.3 ALU Testbench

* Verilog

```verilog
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

```

* Screenshot
![alt text](<Pic/Screenshot 2025-02-19 152802.png>)
## 2. Building Register File and Memories

### 2.1 Register File

* Verilog

```verilog
module RF
(
    input clk,
    input rst,
    input wena,
    input [63:0] wdata,
    input [2:0] waddr,
    input [2:0] r0addr,
    input [2:0] r1addr,

    output reg [63:0] r0data,
    output reg [63:0] r1data
);

    reg [63:0] RF [7:0];
	 
	integer i;

    always @(posedge clk) begin
        if (rst == 1)
        begin
            for (i = 0; i < 8; i = i + 1) begin
                RF[i] <= 64'b0;
            end
        end
        else if (wena == 1)
        begin
            RF[waddr] <= wdata;
        end
    end

    always @(*) begin
        r0data = RF[r0addr];
        r1data = RF[r1addr];
    end

endmodule
```

* Testbench

```verilog
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:33:48 02/19/2025
// Design Name:   RF
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/RF_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RF
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RF_tb;

	// Inputs
	reg clk;
	reg rst;
	reg wena;
	reg [63:0] wdata;
	reg [2:0] waddr;
	reg [2:0] r0addr;
	reg [2:0] r1addr;

	// Outputs
	wire [63:0] r0data;
	wire [63:0] r1data;

	// Instantiate the Unit Under Test (UUT)
	RF uut (
		.clk(clk), 
		.rst(rst), 
		.wena(wena), 
		.wdata(wdata), 
		.waddr(waddr), 
		.r0addr(r0addr), 
		.r1addr(r1addr), 
		.r0data(r0data), 
		.r1data(r1data)
	);

    always #50 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 1;
		rst = 1;
		wena = 0;
		wdata = 0;
		waddr = 0;
		r0addr = 0;
		r1addr = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
        wena = 1;
        waddr = 3'd1;
        wdata = 64'd17;
        r0addr = 3'b000;
        r1addr = 3'b001;
        #100;

        wena = 1;
        waddr = 3'd2;
        wdata = 64'd85;
        r0addr = 3'd1;
        r1addr = 3'd1;
        #100;

        wena = 0;
        waddr = 3'd2;
        wdata = 64'd17;
        r0addr = 3'd2;
        r1addr = 3'd3;
        #100;

        wena = 1;
        waddr = 3'd3;
        wdata = 64'd17;
        r0addr = 3'd0;
        r1addr = 3'd2;
        #100;

        wena = 1;
        waddr = 3'd4;
        wdata = 64'd7;
        r0addr = 3'd2;
        r1addr = 3'd3;
        #100;

        wena = 1;
        waddr = 3'd5;
        wdata = 64'd14;
        r0addr = 3'd4;
        r1addr = 3'd3;
        #100;

        wena = 1;
        waddr = 3'd6;
        wdata = 64'd9;
        r0addr = 3'd1;
        r1addr = 3'd4;
        #100;

        wena = 1;
        waddr = 3'd7;
        wdata = 64'd31;
        r0addr = 3'd5;
        r1addr = 3'd6;
        #100;

        $stop;
	end
      
endmodule
```

* Screenshot
![alt text](<Pic/Screenshot 2025-02-19 165544.png>)

## 3. Building Pipeline Datapath

