module data_top #(
    parameter D_WIDTH = 32
)(
    input   logic   [D_WIDTH-1:0]  instr,
    input   logic                  rst,
    input   logic                  clk,
    input   logic   [D_WIDTH-1:0]  result,
    input   logic                  zero,
    input   logic                  negative,
    output  logic                  PCsrc,
    output  logic   [1:0]          ResultSrc,
    output  logic                  MemWrite,
    output  logic   [3:0]          ALUcontrol,
    output  logic                  ALUSrc,
    output  logic   [D_WIDTH-1:0]  rd1,
    output  logic   [D_WIDTH-1:0]  rd2,
    output  logic   [D_WIDTH-1:0]  ImmExt    
);

    logic           RegWrite;
    logic   [2:0]   ImmSrc;

control control_unit (
    .op             (instr[6:0]),
    .funct3         (instr[14:12]),
    .funct7         (instr[30]),
    .zero           (zero),
    .negative       (negative),
    .PCsrc          (PCsrc),
    .ResultSrc      (ResultSrc),
    .MemWrite       (MemWrite),
    .ALUcontrol     (ALUcontrol),
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
    .read_data2     (rd2)
);

signextend sign_extension (
    .instr          (instr),
    .ImmSrc         (ImmSrc),
    .ImmOp          (ImmExt)
);

endmodule
