module Basic_ALU(
	input [31:0] A, B,
	output wire [31:0] Out,
	output wire overflow,
	input [3:0] control // control Signals
);

    reg [31:0] Negative_B, compare_result;
    always @(*) begin
        case (control)
            4'b0001: {overflow, Out} = A + B;   // Add
            4'b0010: {overflow, Out} = A - B;   // Subtract
            4'b0011: Out = A & B;               // bitwise and
            4'b0100: Out = A | B;               // bitwise or
            4'b0101: Out = A ~^ B;              // bitwise xnor
            4'b0110: begin                      // Compare A and B
                Negative_B = ~B + 1;
                compare_result = A + Negative_B;
                if (compare_result == 0) Out = 32'd1;           // A = B
                else if (compare_result[31] == 1) Out = 32'd2;  //A < B
                else if (compare_result[31] == 0) Out = 32'd3;  //A > B
            end
            4'b0111: Out = A << 1;              // Logical shift left
            4'b1000: Out = A >> 1;              // Logical shift right
            default: Out = 0;                   // Set default output to 0
        endcase
    end
endmodule
