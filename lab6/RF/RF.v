module RF
(
    // input clk,              // Clock
    input rst,              // Reset
    input Write_Enable,     // Write Enable
    input [63:0] rW_Data,     // Data to Be Written
    input [2:0] rW_Addr,      // Write Data Address
    input [2:0] rA_Addr,    // Output Data Address for Port A
    input [2:0] rB_Addr,    // Output Data Address for Port B

    output reg [63:0] rA_Data,  // Output Data Port for Port A
    output reg [63:0] rB_Data   // Output Data Port for Port B
);

    reg [63:0] RF [7:0];    // The Register File itself Contains 8 Registers, 64-bit Each
	integer i;

    always @(*) begin
        // RF[0] = 64'b0;  // Register 0 hardcodes 0

        if(rst) begin
            for (i = 0; i < 8; i = i + 1) begin
                RF[i] = 64'b0;  // Writes 0 to All Register File Locations
            end
        end else if(Write_Enable) begin
            RF[rW_Addr] = rW_Data
        end

        // Port A and Port B Data Output with Internal Forwarding Register File
        if(rA_Addr == rW_Addr && rB_Addr != rW_Addr && rW_Addr != 0) begin
            rA_Data = rW_Addr;
            rB_Data = RF[rB_Addr];
        end else if(rB_Addr == rW_Addr && rA_Addr != rW_Addr && rW_Addr != 0) begin
            rA_Data = RF[rA_Addr];
            rB_Data = rW_Addr;
        end else if(rB_Addr == rW_Addr && rA_Addr == rW_Addr && rW_Addr != 0) begin
            rA_Data = rW_Addr;
            rB_Data = rW_Addr;
        end else begin
            rA_Data = RF[rA_Addr];
            rB_Data = RF[rB_Addr];
        end
    end
endmodule