
module register_file (
    input clk,
    input [1:0] read_addr1, read_addr2,
    output reg [63:0] read_data1, read_data2,
    input [1:0] write_addr,
    input [63:0] write_data,
    input write_enable
);

reg [63:0] registers [0:3]; // 4 registers, 64-bit each

// Asynchronous reads
always @(*) begin
    read_data1 = registers[read_addr1];
    read_data2 = registers[read_addr2];
end

// Synchronous write
always @(posedge clk) begin
    if (write_enable)
        registers[write_addr] <= write_data;
end

endmodule