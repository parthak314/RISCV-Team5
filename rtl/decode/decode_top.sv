module decode_top #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 5
)(
    // General inputs
    input   logic                   rst,
    input   logic                   clk,

    // System inputs
    input   logic                   trigger,
    input   logic [DATA_WIDTH-1:0]  PCD,
    input   logic [DATA_WIDTH-1:0]  instrD,
    input   logic [DATA_WIDTH-1:0]  PCPlus4D,
    input   logic [DATA_WIDTH-1:0]  resultW,

    // Hazard unit inputs
    input   logic                   FlushE,

    // System outputs
    output  logic [DATA_WIDTH-1:0]  a0,  

    // Hazard unit outputs
    output  logic [ADDR_WIDTH-1:0]  Rs1D,
    output  logic [ADDR_WIDTH-1:0]  Rs2D,

    // Control unit outputs
    output  logic                   RegWriteE,
    output  logic [1:0]             ResultSrcE, // Ensure 2 bits for consistency
    output  logic                   MemWriteE,
    output  logic [1:0]             JumpE,      // Match sizes
    output  logic [2:0]             BranchE,
    output  logic [3:0]             ALUControlE,
    output  logic                   ALUSrcE,

    // Pipeline register outputs
    output  logic [DATA_WIDTH-1:0]  Rd1E,
    output  logic [DATA_WIDTH-1:0]  Rd2E,
    output  logic [DATA_WIDTH-1:0]  PCE,
    output  logic [ADDR_WIDTH-1:0]  Rs1E,
    output  logic [ADDR_WIDTH-1:0]  Rs2E,
    output  logic [ADDR_WIDTH-1:0]  RdE,
    output  logic [DATA_WIDTH-1:0]  ImmExtE,
    output  logic [DATA_WIDTH-1:0]  PCPlus4E
);

    // Internal signals
    logic   [2:0]            ImmSrc;
    logic   [DATA_WIDTH-1:0] ImmExtD;
    logic                    RegWriteD;
    logic   [1:0]            ResultSrcD; // Updated to match width of ResultSrcE
    logic                    MemWriteD;
    logic   [1:0]            JumpD;      // Updated to match width of JumpE
    logic   [2:0]            BranchD;
    logic   [3:0]            ALUControlD;
    logic                    ALUSrcD;
    logic   [DATA_WIDTH-1:0] Rd1D;
    logic   [DATA_WIDTH-1:0] Rd2D;

    // Control Unit Instantiation
    control_unit control_unit_mod (
        .op             (instrD[6:0]),
        .funct3         (instrD[14:12]),
        .funct7         (instrD[30]),
        .trigger        (trigger),
        .ResultSrc      (ResultSrcD),
        .MemWrite       (MemWriteD),
        .ALUControl     (ALUControlD),
        .ALUSrc         (ALUSrcD),
        .ImmSrc         (ImmSrc),
        .RegWrite       (RegWriteD),
        .Jump           (JumpD),
        .Branch         (BranchD)
    );

    // Register File Instantiation
    reg_file register_file (
        .clk            (clk),
        .reset          (rst),
        .write_enable   (RegWriteE), // Use pipeline-registered RegWrite
        .read_addr1     (instrD[19:15]),
        .read_addr2     (instrD[24:20]),
        .write_addr     (instrD[11:7]),
        .write_data     (resultW),
        .read_data1     (Rd1D),
        .read_data2     (Rd2D),
        .a0             (a0)
    );

    // Sign Extension Instantiation
    sign_extend sign_extension (
        .instr          (instrD),
        .ImmSrc         (ImmSrc),
        .ImmOp          (ImmExtD)
    );

    // Decode Pipeline Register Instantiation
    decode_pipeline_regfile decode_pipeline_reg (
        .clk            (clk),
        .clr            (rst || FlushE), // Clear signal derived from rst or FlushE
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
        .Rs1D           (instrD[19:15]), // Assign directly from instruction
        .Rs2D           (instrD[24:20]),
        .RdD            (instrD[11:7]),
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
        .PCPlus4E       (PCPlus4E)
    );

endmodule
