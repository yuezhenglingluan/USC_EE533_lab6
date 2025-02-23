`timescale 1ns / 1ps

module IF_ID_Reg
(
    input WMemEn_IF,
    input WRegEn_IF,
    input [2:0] Reg1_IF,
    input [2:0] Reg2_IF,
    input [2:0] WReg1_IF,
    input [20:0] Unused_IF,

    output WMemEn_ID,
    output WRegEn_ID,
    output [2:0] Reg1_ID,
    output [2:0] Reg2_ID,
    output [2:0] WReg1_ID,
    output [20:0] Unused_ID
);

    assign WMemEn_ID = WMemEn_IF;
    assign WRegEn_ID = WRegEn_IF;
    assign Reg1_ID = Reg1_IF;
    assign Reg2_ID = Reg2_IF;
    assign WReg1_ID = WReg1_IF;
    assign Unused_ID = Unused_IF;

endmodule