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