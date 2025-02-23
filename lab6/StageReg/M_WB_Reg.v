`timescale 1ns / 1ps

module M_WB_Reg
(
    input clk,
    input rst,
    input WRegEn_M,
    input [63:0] Dout_M,
    input [2:0] WReg1_M,

    output reg WRegEn_WB,
    output [63:0] Dout_WB,
    output reg [2:0] WReg1_WB
);

    assign Dout_WB = Dout_M;

    always @(posedge clk) begin
        if (rst) begin
            WRegEn_WB <= 0;
            WReg1_WB <= 3'd0;
        end
        else begin
            WRegEn_WB <= WRegEn_M;
            WReg1_WB <= WReg1_M;
        end
    end

endmodule