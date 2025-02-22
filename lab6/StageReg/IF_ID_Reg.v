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