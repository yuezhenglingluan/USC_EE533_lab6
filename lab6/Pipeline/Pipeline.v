////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 10.1
//  \   \         Application : sch2verilog
//  /   /         Filename : Pipeline.vf
// /___/   /\     Timestamp : 02/21/2025 22:24:18
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: C:\Xilinx\10.1\ISE\bin\nt\unwrapped\sch2verilog.exe -intstyle ise -family virtex2p -w "E:/Documents and Settings/student/EE533_Lsb6/Pipeline.sch" Pipeline.vf
//Design Name: Pipeline
//Device: virtex2p
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 1ns / 1ps

module Pipeline(ALU_OP, 
                clk, 
                ONE, 
                rst, 
                Dout_M, 
                Dout_WB, 
                PC, 
                PC_next, 
                Reg1_ID, 
                Reg2_ID, 
                R1_out_EX, 
                R1_out_ID, 
                R1_out_M, 
                R2_out_EX, 
                R2_out_ID, 
                R2_out_M, 
                WMemEn_EX, 
                WMemEn_ID, 
                WMemEn_M, 
                WRegEn_EX, 
                WRegEn_ID, 
                WRegEn_M, 
                WRegEn_WB, 
                WReg1_EX, 
                WReg1_ID, 
                WReg1_M, 
                WReg1_WB);

    input [3:0] ALU_OP;
    input clk;
    input [63:0] ONE;
    input rst;
   output [63:0] Dout_M;
   output [63:0] Dout_WB;
   output [63:0] PC;
   output [63:0] PC_next;
   output [2:0] Reg1_ID;
   output [2:0] Reg2_ID;
   output [63:0] R1_out_EX;
   output [63:0] R1_out_ID;
   output [7:0] R1_out_M;
   output [63:0] R2_out_EX;
   output [63:0] R2_out_ID;
   output [63:0] R2_out_M;
   output WMemEn_EX;
   output WMemEn_ID;
   output WMemEn_M;
   output WRegEn_EX;
   output WRegEn_ID;
   output WRegEn_M;
   output WRegEn_WB;
   output [2:0] WReg1_EX;
   output [2:0] WReg1_ID;
   output [2:0] WReg1_M;
   output [2:0] WReg1_WB;
   
   wire [31:0] Instr;
   wire [2:0] WReg1_WB_DUMMY;
   wire [2:0] WReg1_EX_DUMMY;
   wire WRegEn_M_DUMMY;
   wire [63:0] R2_out_M_DUMMY;
   wire [2:0] Reg2_ID_DUMMY;
   wire WMemEn_ID_DUMMY;
   wire [63:0] Dout_M_DUMMY;
   wire WRegEn_ID_DUMMY;
   wire [63:0] PC_DUMMY;
   wire [63:0] R2_out_EX_DUMMY;
   wire [63:0] R1_out_ID_DUMMY;
   wire [2:0] WReg1_M_DUMMY;
   wire WRegEn_WB_DUMMY;
   wire WMemEn_EX_DUMMY;
   wire [2:0] WReg1_ID_DUMMY;
   wire WRegEn_EX_DUMMY;
   wire [63:0] Dout_WB_DUMMY;
   wire WMemEn_M_DUMMY;
   wire [7:0] R1_out_M_DUMMY;
   wire [63:0] R1_out_EX_DUMMY;
   wire [63:0] PC_next_DUMMY;
   wire [63:0] R2_out_ID_DUMMY;
   wire [2:0] Reg1_ID_DUMMY;
   
   assign Dout_M[63:0] = Dout_M_DUMMY[63:0];
   assign Dout_WB[63:0] = Dout_WB_DUMMY[63:0];
   assign PC[63:0] = PC_DUMMY[63:0];
   assign PC_next[63:0] = PC_next_DUMMY[63:0];
   assign Reg1_ID[2:0] = Reg1_ID_DUMMY[2:0];
   assign Reg2_ID[2:0] = Reg2_ID_DUMMY[2:0];
   assign R1_out_EX[63:0] = R1_out_EX_DUMMY[63:0];
   assign R1_out_ID[63:0] = R1_out_ID_DUMMY[63:0];
   assign R1_out_M[7:0] = R1_out_M_DUMMY[7:0];
   assign R2_out_EX[63:0] = R2_out_EX_DUMMY[63:0];
   assign R2_out_ID[63:0] = R2_out_ID_DUMMY[63:0];
   assign R2_out_M[63:0] = R2_out_M_DUMMY[63:0];
   assign WMemEn_EX = WMemEn_EX_DUMMY;
   assign WMemEn_ID = WMemEn_ID_DUMMY;
   assign WMemEn_M = WMemEn_M_DUMMY;
   assign WRegEn_EX = WRegEn_EX_DUMMY;
   assign WRegEn_ID = WRegEn_ID_DUMMY;
   assign WRegEn_M = WRegEn_M_DUMMY;
   assign WRegEn_WB = WRegEn_WB_DUMMY;
   assign WReg1_EX[2:0] = WReg1_EX_DUMMY[2:0];
   assign WReg1_ID[2:0] = WReg1_ID_DUMMY[2:0];
   assign WReg1_M[2:0] = WReg1_M_DUMMY[2:0];
   assign WReg1_WB[2:0] = WReg1_WB_DUMMY[2:0];
   ALU XLXI_1 (.A(PC_DUMMY[63:0]), 
               .ALU_OP(ALU_OP[3:0]), 
               .B(ONE[63:0]), 
               .ALU_Out(PC_next_DUMMY[63:0]), 
               .Overflow(), 
               .Zero_Flag());
   Instr_Mem XLXI_2 (.addr(PC_DUMMY[8:0]), 
                     .clk(clk), 
                     .dout(Instr[31:0]));
   IF_ID_Reg XLXI_3 (.clk(clk), 
                     .Reg1_IF(Instr[29:27]), 
                     .Reg2_IF(Instr[26:24]), 
                     .rst(rst), 
                     .Unused_IF(Instr[20:0]), 
                     .WMemEn_IF(Instr[31]), 
                     .WRegEn_IF(Instr[30]), 
                     .WReg1_IF(Instr[23:21]), 
                     .Reg1_ID(Reg1_ID_DUMMY[2:0]), 
                     .Reg2_ID(Reg2_ID_DUMMY[2:0]), 
                     .Unused_ID(), 
                     .WMemEn_ID(WMemEn_ID_DUMMY), 
                     .WRegEn_ID(WRegEn_ID_DUMMY), 
                     .WReg1_ID(WReg1_ID_DUMMY[2:0]));
   PC XLXI_4 (.clk(clk), 
              .PC_next(PC_next_DUMMY[63:0]), 
              .rst(rst), 
              .PC(PC_DUMMY[63:0]));
   RF XLXI_5 (.clk(clk), 
              .rst(rst), 
              .r0addr(Reg1_ID_DUMMY[2:0]), 
              .r1addr(Reg2_ID_DUMMY[2:0]), 
              .waddr(WReg1_WB_DUMMY[2:0]), 
              .wdata(Dout_WB_DUMMY[63:0]), 
              .wena(WRegEn_WB_DUMMY), 
              .r0data(R1_out_ID_DUMMY[63:0]), 
              .r1data(R2_out_ID_DUMMY[63:0]));
   ID_EX_Reg XLXI_6 (.clk(clk), 
                     .rst(rst), 
                     .R1_out_ID(R1_out_ID_DUMMY[63:0]), 
                     .R2_out_ID(R2_out_ID_DUMMY[63:0]), 
                     .WMemEn_ID(WMemEn_ID_DUMMY), 
                     .WRegEn_ID(WRegEn_ID_DUMMY), 
                     .WReg1_ID(WReg1_ID_DUMMY[2:0]), 
                     .R1_out_EX(R1_out_EX_DUMMY[63:0]), 
                     .R2_out_EX(R2_out_EX_DUMMY[63:0]), 
                     .WMemEn_EX(WMemEn_EX_DUMMY), 
                     .WRegEn_EX(WRegEn_EX_DUMMY), 
                     .WReg1_EX(WReg1_EX_DUMMY[2:0]));
   EX_M_Reg XLXI_7 (.clk(clk), 
                    .rst(rst), 
                    .R1_out_EX(R1_out_EX_DUMMY[63:0]), 
                    .R2_out_EX(R2_out_EX_DUMMY[63:0]), 
                    .WMemEn_EX(WMemEn_EX_DUMMY), 
                    .WRegEn_EX(WRegEn_EX_DUMMY), 
                    .WReg1_EX(WReg1_EX_DUMMY[2:0]), 
                    .R1_out_M(R1_out_M_DUMMY[7:0]), 
                    .R2_out_M(R2_out_M_DUMMY[63:0]), 
                    .WMemEn_M(WMemEn_M_DUMMY), 
                    .WRegEn_M(WRegEn_M_DUMMY), 
                    .WReg1_M(WReg1_M_DUMMY[2:0]));
   Data_Mem XLXI_8 (.addra(R1_out_M_DUMMY[7:0]), 
                    .addrb(R1_out_M_DUMMY[7:0]), 
                    .clka(clk), 
                    .clkb(clk), 
                    .dina(R2_out_M_DUMMY[63:0]), 
                    .wea(WMemEn_M_DUMMY), 
                    .doutb(Dout_M_DUMMY[63:0]));
   M_WB_Reg XLXI_9 (.clk(clk), 
                    .Dout_M(Dout_M_DUMMY[63:0]), 
                    .rst(rst), 
                    .WRegEn_M(WRegEn_M_DUMMY), 
                    .WReg1_M(WReg1_M_DUMMY[2:0]), 
                    .Dout_WB(Dout_WB_DUMMY[63:0]), 
                    .WRegEn_WB(WRegEn_WB_DUMMY), 
                    .WReg1_WB(WReg1_WB_DUMMY[2:0]));
endmodule
