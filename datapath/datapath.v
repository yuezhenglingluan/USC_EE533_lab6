// Instruction Memory
module instr_mem(
    input [31:0] addr,
    output [31:0] instr
);
    reg [31:0] mem[0:127]; 
    initial $readmemh("program.hex", mem);
    assign instr = mem[addr[31:2]];
endmodule

// Data Memory
module data_mem(
    input clk,
    input [31:0] addr,
    input [31:0] write_data,
    input mem_write,
    output [31:0] read_data
);
    reg [31:0] mem[0:127];
    always @(posedge clk) if (mem_write) mem[addr[31:2]] <= write_data;
    assign read_data = mem[addr[31:2]];
endmodule

// Register File
module reg_file(
    input clk,
    input [4:0] rs1, rs2, rd,
    input [31:0] wb_data,
    input reg_write,
    output [31:0] rv1, rv2
);
    reg [31:0] regs[0:31];
    always @(posedge clk) if (reg_write) regs[rd] <= wb_data;
    assign rv1 = regs[rs1];
    assign rv2 = regs[rs2];
endmodule

// Pipeline Registers
module IF_ID(
    input clk,
    input [31:0] instr_in, pc_plus_4_in,
    output reg [31:0] instr_out, pc_plus_4_out
);
    always @(posedge clk) {instr_out, pc_plus_4_out} <= {instr_in, pc_plus_4_in};
endmodule

module ID_EX(
    input clk,
    input [31:0] rv1_in, rv2_in, imm_in,
    input [4:0] rd_in,
    output reg [31:0] rv1_out, rv2_out, imm_out,
    output reg [4:0] rd_out
);
    always @(posedge clk) {rv1_out, rv2_out, imm_out, rd_out} <= {rv1_in, rv2_in, imm_in, rd_in};
endmodule

module EX_MEM(
    input clk,
    input [31:0] alu_res_in, rv2_in,
    input [4:0] rd_in,
    output reg [31:0] alu_res_out, rv2_out,
    output reg [4:0] rd_out
);
    always @(posedge clk) {alu_res_out, rv2_out, rd_out} <= {alu_res_in, rv2_in, rd_in};
endmodule

module MEM_WB(
    input clk,
    input [31:0] mem_data_in, alu_res_in,
    input [4:0] rd_in,
    output reg [31:0] mem_data_out, alu_res_out,
    output reg [4:0] rd_out
);
    always @(posedge clk) {mem_data_out, alu_res_out, rd_out} <= {mem_data_in, alu_res_in, rd_in};
endmodule

// Top-level Datapath
module pipeline(
    input clk,
    input reset
);
    // IF Stage
    reg [31:0] PC;
    wire [31:0] instr, pc_plus_4 = PC + 4;
    instr_mem imem(PC, instr);

    // IF/ID Register
    wire [31:0] ifid_instr, ifid_pc4;
    IF_ID ifid_reg(clk, instr, pc_plus_4, ifid_instr, ifid_pc4);

    // ID Stage
    wire [4:0] rs1 = ifid_instr[25:21];
    wire [4:0] rs2 = ifid_instr[20:16];
    wire [4:0] rd = ifid_instr[15:11];
    wire [31:0] imm = {{16{ifid_instr[15]}}, ifid_instr[15:0]};
    wire [31:0] rv1, rv2;
    reg_file rf(clk, rs1, rs2, memwb_rd, wb_data, 1'b1, rv1, rv2);

    // ID/EX Register
    wire [31:0] idex_rv1, idex_rv2, idex_imm;
    wire [4:0] idex_rd;
    ID_EX idex_reg(clk, rv1, rv2, imm, rd, idex_rv1, idex_rv2, idex_imm, idex_rd);

    // EX Stage (Simplified ALU)
    wire [31:0] alu_res = idex_rv1 + idex_imm; // Simple adder for testing

    // EX/MEM Register
    wire [31:0] exmem_alu, exmem_rv2;
    wire [4:0] exmem_rd;
    EX_MEM exmem_reg(clk, alu_res, idex_rv2, idex_rd, exmem_alu, exmem_rv2, exmem_rd);

    // MEM Stage
    wire [31:0] mem_data;
    //connect to mem

    // MEM/WB Register
    wire [31:0] memwb_mem, memwb_alu;
    wire [4:0] memwb_rd;
    MEM_WB memwb_reg(clk, mem_data, exmem_alu, exmem_rd, memwb_mem, memwb_alu, memwb_rd);

    // WB Stage
    wire [31:0] wb_data = memwb_alu; // Simple ALU result forwarding

    // PC Update
    always @(posedge clk)
        PC <= reset ? 0 : pc_plus_4;
endmodule