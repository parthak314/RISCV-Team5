module decode_pipelined_top #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 5
)(
    // general inputs
    input   logic                   rst,
    input   logic                   clk,
    input   logic                   clr,

    // system inputs
    input   logic                   trigger,
    input   logic [DATA_WIDTH-1:0]  PCD,
    input   logic [DATA_WIDTH-1:0]  instrD,
    input   logic [DATA_WIDTH-1:0]  PCPlus4D,
    input   logic [DATA_WIDTH-1:0]  resultW,

    // Hazard unit inputs
    input   logic                   FlushE,

    // system outputs
    output  logic [DATA_WIDTH-1:0]  a0,  

    // Hazard unit outputs
    output  logic [ADDR_WIDTH-1:0]  Rs1D,
    output  logic [ADDR_WIDTH-1:0]  Rs2D,

    // control unit outputs
    output  logic                   RegWriteE,
    output  logic                   ResultSrcE,
    output  logic                   MemWriteE,
    output  logic [1:0]             JumpE,
    output  logic [2:0]             BranchE,
    output  logic [3:0]             ALUControlE,
    output  logic                   ALUSrcE,

    // pipeline reg outputs
    output  logic [DATA_WIDTH-1:0]  Rd1E,
    output  logic [DATA_WIDTH-1:0]  Rd2E,
    output  logic [DATA_WIDTH-1:0]  PCE,
    output  logic [ADDR_WIDTH-1:0]  Rs1E,
    output  logic [ADDR_WIDTH-1:0]  Rs2E,
    output  logic [ADDR_WIDTH-1:0]  RdE,
    output  logic [DATA_WIDTH-1:0]  ImmExtE,
    output  logic [DATA_WIDTH-1:0]  PCPlus4E
);

    logic   [2:0]            ImmSrc;
    logic   [DATA_WIDTH-1:0] ImmExtD;
    logic                    RegWriteD;
    logic                    ResultSrcD;
    logic                    MemWriteD;
    logic   [1:0]            JumpD;
    logic   [2:0]            BranchD;
    logic   [3:0]            ALUControlD;
    logic                    ALUSrcD;
    logic   [DATA_WIDTH-1:0] Rd1D;
    logic   [DATA_WIDTH-1:0] Rd2D;

control_pipelined control_unit_pipelined (
    .op             (instrD[6:0]),
    .funct3         (instrD[14:12]),
    .funct7         (instrD[30]),
    .trigger        (trigger),
    .ResultSrc      (ResultSrcD),
    .MemWrite       (MemWriteD),
    .ALUControl     (ALUControlD),
    .ALUSrc         (ALUSrcD),
    .ImmSrc         (ImmSrcD),
    .RegWrite       (RegWriteD),
    .Jump           (JumpD),
    .Branch         (BranchD)
);

reg_file register_file (
    .clk            (clk),
    .reset          (rst),
    .write_enable   (RegWriteD),
    .read_addr1     (instrD[19:15]),
    .read_addr2     (instrD[24:20]),
    .write_addr     (instrD[11:7]),
    .write_data     (resultW),
    .read_data1     (Rd1D),
    .read_data2     (Rd2D),
    .a0             (a0)
);

signextend sign_extension (
    .instr          (instrD),
    .ImmSrc         (ImmSrc),
    .ImmOp          (ImmExtD)
);

decode_pipeline_reg pipeline_register (
    .clk            (clk),
    .clr            (clr),
    .RegWriteD      (RegWriteD),
    .ResultSrcD     (ResultSrcD),
    .MemWriteD      (MemWriteD),    
    .JumpD          (JumpD),
    .BranchD        (BranchD),
    .ALUControlD    (ALUControlD),
    .ALUSrcD        (ALUSrcD),
    .Rd1D           (Rd1D),
    .Rd2D           (Rd2D),
    .PCD            (PCD),
    .Rs1D           (Rs1D),
    .Rs2D           (Rs2D),
    .RdD            (RdD),
    .ImmExtD        (ImmExtD),
    .PCPlus4D       (PCPlus4D),
    .RegWriteE      (RegWriteE),
    .ResultSrcE     (ResultSrcE),
    .MemWriteE      (MemWriteE),    
    .JumpE          (JumpE),
    .BranchE        (BranchE),
    .ALUControlE    (ALUControlE),
    .ALUSrcE        (ALUSrcE),
    .Rd1E           (Rd1E),
    .Rd2E           (Rd2E),
    .PCE            (PCE),
    .Rs1E           (Rs1E),
    .Rs2E           (Rs2E),
    .RdE            (RdE),
    .ImmExtE        (ImmExtE),
    .PCPlus4E       (PCPlus4E),

);

endmodule
