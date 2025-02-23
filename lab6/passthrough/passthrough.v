`timescale 1ns/1ps

`define UDP_REG_ADDR_WIDTH 16
`define CPCI_NF2_DATA_WIDTH 16
`define IDS_BLOCK_TAG 1
`define IDS_REG_ADDR_WIDTH 16

module passthrough
   #(
      parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH = DATA_WIDTH/8,
      parameter UDP_REG_SRC_WIDTH = 2
   )
    (
        out_data,
        out_ctrl,
        out_wr,
        out_rdy,
        in_data,
        in_ctrl,
        in_wr,
        in_rdy,
        reg_req_in,
        reg_ack_in,
        reg_rd_wr_L_in,
        reg_addr_in,
        reg_data_in,
        reg_src_in,
        reg_req_out,
        reg_ack_out,
        reg_rd_wr_L_out,
        reg_addr_out,
        reg_data_out,
        reg_src_out,
        clk,
        reset
    );
    (
      input  [DATA_WIDTH-1:0]             in_data,
      input  [CTRL_WIDTH-1:0]             in_ctrl,
      input                               in_wr,
      output                              in_rdy,

      output [DATA_WIDTH-1:0]             out_data,
      output [CTRL_WIDTH-1:0]             out_ctrl,
      output                              out_wr,
      input                               out_rdy,
      
      // --- Register interface
      input                               reg_req_in,
      input                               reg_ack_in,
      input                               reg_rd_wr_L_in,
      input  [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_in,
      input  [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_in,
      input  [UDP_REG_SRC_WIDTH-1:0]      reg_src_in,

      output                              reg_req_out,
      output                              reg_ack_out,
      output                              reg_rd_wr_L_out,
      output  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_out,
      output  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_out,
      output  [UDP_REG_SRC_WIDTH-1:0]     reg_src_out,

      // misc
      input                                reset,
      input                                clk
   );

   assign out_data = in_data;
   assign out_ctrl = in_ctrl;
   assign out_wr = in_wr;
   assign out_rdy = in_rdy;

   assign reg_req_out = reg_req_in;
   assign reg_ack_out = reg_ack_in;
   assign reg_rd_wr_L_out = reg_rd_wr_L_in;
   assign reg_addr_out = reg_addr_in;
   assign reg_data_out = reg_data_in;
   assign reg_src_out = reg_src_in;

   Pipeline pipeline
   (
        .ALU_OP             (), 
        .clk                (), 
        .ONE                (), 
        .rst                (), 
        .Dout_M             (), 
        .Dout_WB            (), 
        .PC                 (), 
        .PC_next            (), 
        .Reg1_ID            (), 
        .Reg2_ID            (), 
        .R1_out_EX          (), 
        .R1_out_ID          (), 
        .R1_out_M           (),   
        .R2_out_EX          (), 
        .R2_out_ID          (), 
        .R2_out_M           (), 
        .WMemEn_EX          (), 
        .WMemEn_ID          (), 
        .WMemEn_M           (), 
        .WRegEn_EX          (), 
        .WRegEn_ID          (), 
        .WRegEn_M           (), 
        .WRegEn_WB          (), 
        .WReg1_EX           (), 
        .WReg1_ID           (), 
        .WReg1_M            (), 
        .WReg1_WB           ()
   );

endmodule