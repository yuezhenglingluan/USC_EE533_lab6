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
            4'b0000: begin // Addition
                {Overflow, ALU_Reg} = A + B;
            end
            4'b0001: begin // Subtraction
                {Overflow, ALU_Reg} = A - B;
            end
            4'b0010: ALU_Reg = A & B;              // Bitwise AND
            4'b0011: ALU_Reg = A | B;              // Bitwise OR
            4'b0100: ALU_Reg = A ^~ B;             // Bitwise XNOR
            4'b0101: ALU_Reg = (A == B) ? 64'b1 : 64'b0; // Compare (Equality)
            4'b0110: ALU_Reg = A << B[5:0];        // Logical Left Shift
            4'b0111: ALU_Reg = A >> B[5:0];        // Logical Right Shift
            4'b1000: ALU_Reg = substring_match(A, B); // Substring Compare
            4'b1001: ALU_Reg = shift_then_compare(A, B); // Shift-then-Compare
            default: ALU_Reg = 64'b0;
        endcase
        
        // Zero Flag
        Zero_Flag = (ALU_Reg == 64'b0) ? 1'b1 : 1'b0;
        
        // Store output in register
        ALU_Out = ALU_Reg;
    end
    
    // Function to check if B is a substring of A
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
    
    // Function to shift A and then compare with B
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