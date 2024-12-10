`include "./decode/control.sv"
`include "./decode/reg_file.sv"
`include "./decode/signextend.sv"

module decode_top #(
    parameter DATA_WIDTH = 32
)(
    input   logic                     rst,
    input   logic                     clk,
    input   logic                     trigger,
    input   logic   [DATA_WIDTH-1:0]  instrA,
    input   logic   [DATA_WIDTH-1:0]  instrB,
    input   logic   [DATA_WIDTH-1:0]  resultA,
    input   logic   [DATA_WIDTH-1:0]  resultB,
    // input   logic   [1:0]             zero,
    // input   logic   [1:0]             negative,
    output  logic                     IncrSrc,
    output  logic                     PCSrc,
    output  logic   [1:0]             ResultSrc,
    output  logic   [1:0]             MemWrite,
    output  logic   [7:0]             ALUControl,
    output  logic   [1:0]             ALUSrc,

    output  logic   [DATA_WIDTH-1:0]  rd1A,
    output  logic   [DATA_WIDTH-1:0]  rd2A,
    output  logic   [DATA_WIDTH-1:0]  rd1B,
    output  logic   [DATA_WIDTH-1:0]  rd2B,
    output  logic   [DATA_WIDTH-1:0]  ImmExtA, 
    output  logic   [DATA_WIDTH-1:0]  ImmExtB, 
    output  logic   [DATA_WIDTH-1:0]  a0  
);

    logic   [1:0]   RegWrite;
    logic   [5:0]   ImmSrc;

control control_unit (
    .opA            (instrA[6:0]),
    .funct3A        (instrA[14:12]),
    .funct7A        (instrA[30]),
    .opB            (instrB[6:0]),
    .funct3B        (instrB[14:12]),
    .funct7B        (instrB[30]),
    // .zero           (zero),
    // .negative       (negative),
    .trigger        (trigger),
    .IncrSrc        (IncrSrc),
    .PCSrc          (PCSrc),
    .ResultSrc      (ResultSrc),
    .MemWrite       (MemWrite),
    .ALUControl     (ALUControl),
    .ALUSrc         (ALUSrc),
    .ImmSrc         (ImmSrc),
    .RegWrite       (RegWrite)
);

reg_file register_file (
    .clk            (clk),
    .reset          (rst),
    .write_enable   (RegWrite),
    .raddr1A        (instrA[19:15]),
    .raddr2A        (instrA[24:20]),
    .waddrA         (instrA[11:7]),
    .raddr1B        (instrB[19:15]),
    .raddr2B        (instrB[24:20]),
    .waddrB         (instrB[11:7]),
    .wdataA         (resultA),
    .wdataB         (resultB),
    .rdata1A        (rd1A),
    .rdata2A        (rd2A),
    .rdata1B        (rd1B),
    .rdata2B        (rd2B),
    .a0             (a0)
);

signextend sign_extension (
    .instrA         (instrA),
    .instrB         (instrB),
    .ImmSrc         (ImmSrc),
    .ImmOpA         (ImmExtA),
    .ImmOpB         (ImmExtB),
);

endmodule
