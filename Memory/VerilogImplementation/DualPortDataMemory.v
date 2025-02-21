module DualPortDataMemory(
    input Write_Enable,     // Write Enable
    input Read_Enable,      // Read Enable
    input [63:0] rW_Data,   // Data to Be Written
    input [7:0] rW_Addr,    // Write Data Address
    input [63:0] rR_Data,   // Data to Be Read
    input [7:0] rR_Addr,    // Read Data Address
);

    reg [63:0] BRAM [255:0];    // 64 bit wide BRAM with 256 entries

    always @(*) begin
        if(Write_Enable && ~Read_Enable) begin
            rW_Data = BRAM[rW_Addr];
        end
        if(Read_Enable && ~Write_Enable) begin
            rR_Data = BRAM[rR_Addr];
        end
        if(Write_Enable && Read_Enable) begin
            rW_Data = BRAM[rW_Addr];
            rR_Data = BRAM[rR_Addr];
        end
    end
endmodule