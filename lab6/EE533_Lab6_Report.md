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

![Screenshot 2025-02-19 152920](C:\Users\StepF\Pictures\Screenshots\Screenshot 2025-02-19 152920.png)

## 2. Building Register File and Memories

### 2.1 Register File

* Verilog

```verilog
module RF
(
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

    always @(*) begin
        if (rst == 1)
        begin
            for (i = 0; i < 8; i = i + 1) begin
                RF[i] = 64'b0;
            end
        end
        else if (wena == 1)
        begin
            RF[waddr] = wdata;
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
		.rst(rst), 
		.wena(wena), 
		.wdata(wdata), 
		.waddr(waddr), 
		.r0addr(r0addr), 
		.r1addr(r1addr), 
		.r0data(r0data), 
		.r1data(r1data)
	);

	initial begin
		// Initialize Inputs
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

![Screenshot 2025-02-20 133019](C:\Users\StepF\Documents\GitHub\USC_EE533_lab6\lab6\Pic\Screenshot 2025-02-20 133019.png)

### 2.2 IP Core based single-port BRAM for Instruction Memory

* Width: 32
* Depth: 512
* Verilog

```verilog
/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used             *
*     solely for design, simulation, implementation and creation of            *
*     design files limited to Xilinx devices or technologies. Use              *
*     with non-Xilinx devices or technologies is expressly prohibited          *
*     and immediately terminates your license.                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"            *
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                  *
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION          *
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION              *
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS                *
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                  *
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE         *
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY                 *
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                  *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          *
*     FOR A PARTICULAR PURPOSE.                                                *
*                                                                              *
*     Xilinx products are not intended for use in life support                 *
*     appliances, devices, or systems. Use in such applications are            *
*     expressly prohibited.                                                    *
*                                                                              *
*     (c) Copyright 1995-2007 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/
// The synthesis directives "translate_off/translate_on" specified below are
// supported by Xilinx, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file Instr_Mem.v when simulating
// the core, Instr_Mem. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

`timescale 1ns/1ps

module Instr_Mem(
	addr,
	clk,
	dout);


input [8 : 0] addr;
input clk;
output [31 : 0] dout;

// synthesis translate_off

      BLKMEMSP_V6_2 #(
		.c_addr_width(9),
		.c_default_data("0"),
		.c_depth(512),
		.c_enable_rlocs(0),
		.c_has_default_data(1),
		.c_has_din(0),
		.c_has_en(0),
		.c_has_limit_data_pitch(0),
		.c_has_nd(0),
		.c_has_rdy(0),
		.c_has_rfd(0),
		.c_has_sinit(0),
		.c_has_we(0),
		.c_limit_data_pitch(18),
		.c_mem_init_file("mif_file_16_1"),
		.c_pipe_stages(0),
		.c_reg_inputs(0),
		.c_sinit_value("0"),
		.c_width(32),
		.c_write_mode(0),
		.c_ybottom_addr("0"),
		.c_yclk_is_rising(1),
		.c_yen_is_high(1),
		.c_yhierarchy("hierarchy1"),
		.c_ymake_bmm(0),
		.c_yprimitive_type("16kx1"),
		.c_ysinit_is_high(1),
		.c_ytop_addr("1024"),
		.c_yuse_single_primitive(0),
		.c_ywe_is_high(1),
		.c_yydisable_warnings(1))
	inst (
		.ADDR(addr),
		.CLK(clk),
		.DOUT(dout),
		.DIN(),
		.EN(),
		.ND(),
		.RFD(),
		.RDY(),
		.SINIT(),
		.WE());


// synthesis translate_on

// XST black box declaration
// box_type "black_box"
// synthesis attribute box_type of Instr_Mem is "black_box"

endmodule
```

* Screenshot

![Screenshot 2025-02-20 135316](C:\Users\StepF\Documents\GitHub\USC_EE533_lab6\lab6\Pic\Screenshot 2025-02-20 135316.png)

### 2.3 IP Core based dual-port BRAM for Data Memory

* Width: 64
* Depth: 256
* Verilog

```verilog
/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used             *
*     solely for design, simulation, implementation and creation of            *
*     design files limited to Xilinx devices or technologies. Use              *
*     with non-Xilinx devices or technologies is expressly prohibited          *
*     and immediately terminates your license.                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"            *
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                  *
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION          *
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION              *
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS                *
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                  *
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE         *
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY                 *
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                  *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          *
*     FOR A PARTICULAR PURPOSE.                                                *
*                                                                              *
*     Xilinx products are not intended for use in life support                 *
*     appliances, devices, or systems. Use in such applications are            *
*     expressly prohibited.                                                    *
*                                                                              *
*     (c) Copyright 1995-2007 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/
// The synthesis directives "translate_off/translate_on" specified below are
// supported by Xilinx, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file Data_Mem.v when simulating
// the core, Data_Mem. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

`timescale 1ns/1ps

module Data_Mem(
	addra,
	addrb,
	clka,
	clkb,
	dina,
	doutb,
	wea);


input [7 : 0] addra;
input [7 : 0] addrb;
input clka;
input clkb;
input [63 : 0] dina;
output [63 : 0] doutb;
input wea;

// synthesis translate_off

      BLKMEMDP_V6_3 #(
		.c_addra_width(8),
		.c_addrb_width(8),
		.c_default_data("0"),
		.c_depth_a(256),
		.c_depth_b(256),
		.c_enable_rlocs(0),
		.c_has_default_data(1),
		.c_has_dina(1),
		.c_has_dinb(0),
		.c_has_douta(0),
		.c_has_doutb(1),
		.c_has_ena(0),
		.c_has_enb(0),
		.c_has_limit_data_pitch(0),
		.c_has_nda(0),
		.c_has_ndb(0),
		.c_has_rdya(0),
		.c_has_rdyb(0),
		.c_has_rfda(0),
		.c_has_rfdb(0),
		.c_has_sinita(0),
		.c_has_sinitb(0),
		.c_has_wea(1),
		.c_has_web(0),
		.c_limit_data_pitch(18),
		.c_mem_init_file("mif_file_16_1"),
		.c_pipe_stages_a(0),
		.c_pipe_stages_b(0),
		.c_reg_inputsa(0),
		.c_reg_inputsb(0),
		.c_sim_collision_check("NONE"),
		.c_sinita_value("0"),
		.c_sinitb_value("0"),
		.c_width_a(64),
		.c_width_b(64),
		.c_write_modea(1),
		.c_write_modeb(0),
		.c_ybottom_addr("0"),
		.c_yclka_is_rising(1),
		.c_yclkb_is_rising(1),
		.c_yena_is_high(1),
		.c_yenb_is_high(1),
		.c_yhierarchy("hierarchy1"),
		.c_ymake_bmm(0),
		.c_yprimitive_type("16kx1"),
		.c_ysinita_is_high(1),
		.c_ysinitb_is_high(1),
		.c_ytop_addr("1024"),
		.c_yuse_single_primitive(0),
		.c_ywea_is_high(1),
		.c_yweb_is_high(1),
		.c_yydisable_warnings(1))
	inst (
		.ADDRA(addra),
		.ADDRB(addrb),
		.CLKA(clka),
		.CLKB(clkb),
		.DINA(dina),
		.DOUTB(doutb),
		.WEA(wea),
		.DINB(),
		.DOUTA(),
		.ENA(),
		.ENB(),
		.NDA(),
		.NDB(),
		.RFDA(),
		.RFDB(),
		.RDYA(),
		.RDYB(),
		.SINITA(),
		.SINITB(),
		.WEB());


// synthesis translate_on

// XST black box declaration
// box_type "black_box"
// synthesis attribute box_type of Data_Mem is "black_box"

endmodule
```

* Screenshot

![Screenshot 2025-02-20 140401](C:\Users\StepF\Documents\GitHub\USC_EE533_lab6\lab6\Pic\Screenshot 2025-02-20 140401.png)

## 3. Building Pipeline Datapath

### 3.1 PC reg

* Verilog

```verilog
`timescale 1ns / 1ps

module PC
(
    input clk,
    input rst,
    input [63:0] PC_next,

    output reg [63:0] PC
);

    always @(posedge clk) begin
        if (rst)
            PC <= 63'b0;
        else
            PC <= PC_next;
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
// Create Date:   13:50:22 02/21/2025
// Design Name:   PC
// Module Name:   E:/Documents and Settings/student/EE533_Lsb6/PC_tb.v
// Project Name:  EE533_Lsb6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PC_tb;

	// Inputs
	reg clk;
	reg rst;
    reg [63:0] PC_next;

	// Outputs
    wire [63:0] PC;

	// Instantiate the Unit Under Test (UUT)
	PC uut (
		.clk(clk), 
		.rst(rst), 
		.PC_next(PC_next), 
		.PC(PC)
	);
	
	always #50 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 1;
		rst = 1;
		PC_next = 0;

		// Wait 100 ns for global reset to finish
		#100;
        rst = 0;
        
		// Add stimulus here
        @(posedge clk);
        PC_next = 64'd1;

        @(posedge clk);
        PC_next = 64'd2;

        @(posedge clk);
        PC_next = 64'd3;
        
        @(posedge clk);
        PC_next = 64'd4;

        $stop;

	end
      
endmodule
```

* Screenshot

![Screenshot 2025-02-21 141421](C:\Users\StepF\Documents\GitHub\ee533\lab 6\Pic\Screenshot 2025-02-21 141421.png)

### 3.2 IF_ID_Reg

* Verilog

```verilog
`timescale 1ns / 1ps

module IF_ID_Reg
(
    input clk,
    input rst,
    input WMemEn_IF,
    input WRegEn_IF,
    input [2:0] Reg1_IF,
    input [2:0] Reg2_IF,
    input [2:0] WReg1_IF,
    input [20:0] Unused_IF,

    output reg WMemEn_ID,
    output reg WRegEn_ID,
    output reg [2:0] Reg1_ID,
    output reg [2:0] Reg2_ID,
    output reg [2:0] WReg1_ID,
    output reg [20:0] Unused_ID
);

    always @(posedge clk) begin
        if (rst) begin
            WMemEn_ID <= 1'd0;
            WRegEn_ID <= 1'd0;
            Reg1_ID <= 3'd0;
            Reg2_ID <= 3'd0;
            WReg1_ID <= 3'd0;
            Unused_ID <= 20'd0;
        end
        else begin
            WMemEn_ID <= WMemEn_IF;
            WRegEn_ID <= WRegEn_IF;
            Reg1_ID <= Reg1_IF;
            Reg2_ID <= Reg2_IF;
            WReg1_ID <= WReg1_IF;
            Unused_ID <= Unused_IF;
        end
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
```

* Screenshot

![Screenshot 2025-02-21 144844](C:\Users\StepF\Documents\GitHub\ee533\lab 6\Pic\Screenshot 2025-02-21 144844.png)

### 3.3 ID_EX_Reg

* Verilog

```verilog
`timescale 1ns / 1ps

module ID_EX_Reg
(
    input clk,
    input rst,
    input WRegEn_ID,
    input WMemEn_ID,
    input [63:0] R1_out_ID,
    input [63:0] R2_out_ID,
    input [2:0] WReg1_ID,

    output reg WRegEn_EX,
    output reg WMemEn_EX,
    output reg [63:0] R1_out_EX,
    output reg [63:0] R2_out_EX,
    output reg [2:0] WReg1_EX
);

    always @(posedge clk) begin
        if (rst) begin
            WRegEn_EX <= 0;
            WMemEn_EX <= 0;
            R1_out_EX <= 0;
            R2_out_EX <= 0;
            WReg1_EX <= 0;
        end
        else begin
            WRegEn_EX <= WRegEn_ID;
            WMemEn_EX <= WMemEn_ID;
            R1_out_EX <= R1_out_ID;
            R2_out_EX <= R2_out_ID;
            WReg1_EX <= WReg1_ID;
        end
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
		WRegEn_ID = 0;
		WMemEn_ID = 1;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd2;

		@(posedge clk);
		WRegEn_ID = 0;
		WMemEn_ID = 1;
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
		WRegEn_ID = 1;
		WMemEn_ID = 0;
		R1_out_ID = 64'd4;
		R2_out_ID = 64'd4;
		WReg1_ID = 3'd0;

        @(posedge clk);
        
        @(posedge clk);
		$stop;

	end
      
endmodule
```

* Screenshot

![Screenshot 2025-02-21 154546](C:\Users\StepF\Documents\GitHub\ee533\lab 6\Pic\Screenshot 2025-02-21 154546.png)

### 3.4 EX_M_Reg

* Verilog

```verilog
`timescale 1ns / 1ps

module EX_M_Reg
(
    input clk,
    input rst,
    input WRegEn_EX,
    input WMemEn_EX,
    input [63:0] R1_out_EX,
    input [63:0] R2_out_EX,
    input [2:0] WReg1_EX,

    output reg WRegEn_M,
    output reg WMemEn_M,
    output reg [7:0] R1_out_M,
    output reg [63:0] R2_out_M,
    output reg [2:0] WReg1_M
);

    always @(posedge clk) begin
        if (rst) begin
            WRegEn_M <= 0;
            WMemEn_M <= 0;
            R1_out_M <= 8'd0;
            R2_out_M <= 64'd0;
            WReg1_M <= 3'b0;
        end
        else begin
            WRegEn_M <= WRegEn_EX;
            WMemEn_M <= WMemEn_EX;
            R1_out_M <= R1_out_EX[7:0];
            R2_out_M <= R2_out_EX;
            WReg1_M <= WReg1_EX;
        end
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
```

* Verilog

![Screenshot 2025-02-21 155657](C:\Users\StepF\Documents\GitHub\ee533\lab 6\Pic\Screenshot 2025-02-21 155657.png)

### 3.5 M_WB_Reg

* Verilog

```verilog
`timescale 1ns / 1ps

module M_WB_Reg
(
    input clk,
    input rst,
    input WRegEn_M,
    input [63:0] Dout_M,
    input [2:0] WReg1_M,

    output reg WRegEn_WB,
    output reg [63:0] Dout_WB,
    output reg [2:0] WReg1_WB
);

    always @(posedge clk) begin
        if (rst) begin
            WRegEn_WB <= 0;
            Dout_WB <= 64'd0;
            WReg1_WB <= 3'd0;
        end
        else begin
            WRegEn_WB <= WRegEn_M;
            Dout_WB <= Dout_M;
            WReg1_WB <= WReg1_M;
        end
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
```

* Screenshot

![Screenshot 2025-02-21 161440](C:\Users\StepF\Documents\GitHub\ee533\lab 6\Pic\Screenshot 2025-02-21 161440.png)

### 3.6 Pipeline Datapath

