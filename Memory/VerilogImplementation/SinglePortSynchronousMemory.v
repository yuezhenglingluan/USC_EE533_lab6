module SinglePortSynchronousMemory(
    input Write_Enable, // Write Enable
    input Read_Enable,  // Read Enable
    input [31:0] Data,  // Data input
    input [8:0] Addr,   // Address input
);

    reg [31:0] BRAM [511:0];    // 64 bit wide BRAM with 256 entries

    always @(*) begin
        if(Write_Enable && ~Read_Enable) begin
            // If Write Enable is True Write Data to BRAM
            BRAM[Addr] = Data;
        end
        if(Read_Enable && ~Write_Enable) begin
            // If Read Enable is True Read Data from BRAM
            Data = BRAM[Addr];
        end
        // Else don't do anything
    end
endmodule