`include "./fetch/fetch_top.sv"
`include "./decode/decode_top.sv"
`include "./execute/execute_top.sv"
`include "./memory/memory_top.sv"

module top #(
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic trigger,
    output logic [DATA_WIDTH-1:0] a0
);

// Fetch Wires
logic PCSrc;
logic [DATA_WIDTH-1:0] InstrA;
logic [DATA_WIDTH-1:0] InstrB;

// Data Wires
// logic Zero, Negative; // negative, zero flags
logic [1:0] MemWrite;
logic [1:0] ALUSrc;
logic [1:0] ResultSrc;
logic [7:0] ALUControl;
logic [DATA_WIDTH-1:0] ResultA, ResultB;
logic [DATA_WIDTH-1:0] RD1A, RD2A, RD1B, RD2B;
logic [DATA_WIDTH-1:0] ImmExtA, ImmExtB;

// Execute Wires
logic [DATA_WIDTH-1:0] ALUResultA, ALUResultB;

fetch_top fetch_top_mod (
    .clk            (clk),
    .rst            (rst),
    .PCSrc          (PCSrc),
    .InstrA         (InstrA),
    .InstrB         (InstrB)
);

decode_top decode_top_mod (
    .rst            (rst),
    .clk            (clk),
    .trigger        (trigger),
    .instrA         (InstrA),
    .instrB         (InstrB),
    .resultA        (ResultA),
    .resultB        (ResultB),
    // .zero           (Zero),
    // .negative       (Negative),
    .PCSrc          (PCSrc),
    .ResultSrc      (ResultSrc),
    .MemWrite       (MemWrite),
    .ALUControl     (ALUControl),
    .ALUSrc         (ALUSrc),
    .rd1A           (RD1A),
    .rd2A           (RD2A),
    .rd1B           (RD1B),
    .rd2B           (RD2B),
    .ImmExtA        (ImmExtA),
    .ImmExtB        (ImmExtB),
    .a0             (a0)
);

execute_top execute_top_mod (
    .ALUControl     (ALUControl),
    .ALUSrc         (ALUSrc),
    .RD1A           (RD1A),
    .RD2A           (RD2A),
    .RD1B           (RD1B),
    .RD2B           (RD2B),
    .ImmExtA        (ImmExtA),
    .ImmExtB        (ImmExtB),
    .ALUResultA     (ALUResultA),
    .ALUResultB     (ALUResultB)
    // .Zero(Zero),
    // .Negative(Negative)
);

memory_top memory_top_mod (
    .clk            (clk),
    .ResultSrc      (ResultSrc),
    .MemWrite       (MemWrite),
    .ALUResultA     (ALUResultA),
    .ALUResultB     (ALUResultB),
    .wdataA         (RD2A),
    .wdataB         (RD2B),
    .ResultA        (ResultA),
    .ResultB        (ResultB)
);

endmodule
