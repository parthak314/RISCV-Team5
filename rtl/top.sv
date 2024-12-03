`include "./fetch/fetch_top.sv"
`include "./data/data_top.sv"
`include "./execute/execute_top.sv"
`include "./memory/memory_top.sv"

module top #(
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic trigger,
    output logic [31:0] a0
);

// Fetch Wires
logic [1:0] PCSrc;
logic [DATA_WIDTH-1:0] Instr;
logic [DATA_WIDTH-1:0] PCPlus4;

// Data Wires
logic Zero, Negative; // negative, zero flags
logic MemWrite;
logic ALUSrc;
logic [1:0] ResultSrc;
logic [3:0] ALUControl;
logic [DATA_WIDTH-1:0] Result;
logic [DATA_WIDTH-1:0] RD1, RD2;
logic [DATA_WIDTH-1:0] ImmExt;

// Execute Wires
logic [DATA_WIDTH-1:0] ALUResult;

fetch_top fetch_top_mod (
    .clk(clk),
    .rst(rst),
    .Result(Result),
    .PCSrc(PCSrc),
    .ImmExt(ImmExt),
    .Instr(Instr),
    .PCPlus4(PCPlus4)
);

data_top data_top_mod (
    .clk(clk),
    .rst(rst),
    .trigger(trigger),
    .instr(Instr),
    .result(Result),
    .zero(Zero),
    .negative(Negative),
    .PCSrc(PCSrc),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUControl(ALUControl),
    .ALUSrc(ALUSrc),
    .rd1(RD1),
    .rd2(RD2),
    .ImmExt(ImmExt),
    .a0(a0)
);

execute_top execute_top_mod (
    .ALUControl(ALUControl),
    .ALUSrc(ALUSrc),
    .RD1(RD1),
    .RD2(RD2),
    .ImmExt(ImmExt),
    .ALUResult(ALUResult),
    .Zero(Zero),
    .Negative(Negative)
);

memory_top memory_top_mod (
    .clk(clk),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .PCPlus4(PCPlus4),
    .ImmExt(ImmExt),
    .ALUResult(ALUResult),
    .WriteData(RD2),
    .Result(Result)
);

endmodule
