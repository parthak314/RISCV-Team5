module data_top #(
    parameter DATA_WIDTH = 32
)(
    input   logic                     rst,
    input   logic                     clk,
    input   logic   [DATA_WIDTH-1:0]  instr,
    input   logic   [DATA_WIDTH-1:0]  result,
    input   logic                     zero,
    input   logic                     negative,
    output  logic                     PCSrc,
    output  logic   [1:0]             ResultSrc,
    output  logic                     MemWrite,
    output  logic   [3:0]             ALUControl,
    output  logic                     ALUSrc,
    output  logic   [DATA_WIDTH-1:0]  rd1,
    output  logic   [DATA_WIDTH-1:0]  rd2,
    output  logic   [DATA_WIDTH-1:0]  ImmExt, 
    output  logic   [DATA_WIDTH-1:0]  a0  
);

    logic           RegWrite;
    logic   [2:0]   ImmSrc;

control control_unit (
    .op             (instr[6:0]),
    .funct3         (instr[14:12]),
    .funct7         (instr[30]),
    .zero           (zero),
    .negative       (negative),
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
    .read_addr1     (instr[19:15]),
    .read_addr2     (instr[24:20]),
    .write_addr     (instr[11:7]),
    .write_data     (result),
    .read_data1     (rd1),
    .read_data2     (rd2),
    .a0             (a0)
);

signextend sign_extension (
    .instr          (instr),
    .ImmSrc         (ImmSrc),
    .ImmOp          (ImmExt)
);

endmodule
