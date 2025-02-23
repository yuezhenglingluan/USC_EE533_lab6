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
    output [63:0] R1_out_EX,
    output [63:0] R2_out_EX,
    output reg [2:0] WReg1_EX
);

    assign R1_out_EX = R1_out_ID;
    assign R2_out_EX = R2_out_ID;

    always @(posedge clk) begin
        if (rst) begin
            WRegEn_EX <= 0;
            WMemEn_EX <= 0;
            WReg1_EX <= 0;
        end
        else begin
            WRegEn_EX <= WRegEn_ID;
            WMemEn_EX <= WMemEn_ID;
            WReg1_EX <= WReg1_ID;
        end
    end

endmodule