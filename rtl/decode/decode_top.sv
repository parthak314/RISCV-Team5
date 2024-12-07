module decode_top #(
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     stall,
    input logic                     reset,

    input logic [DATA_WIDTH-1:0]    InstrD,
    input logic [DATA_WIDTH-1:0]    PCD,
    input logic [DATA_WIDTH-1:0]    PCPlus4D,

    input logic                     RegWriteW,
    input logic [DATA_WIDTH-1:0]    ResultW,
    input logic [4:0]               RdW,

    input logic                     PCSrcE,
    // used to drive the flush. if PCSrc = 1 then the next instr is invalid bc jump was taken

    output logic                    RegWriteE,
    output logic [1:0]              ResultSrcE,
    output logic                    MemWriteE,
    output logic [1:0]              JumpE,
    output logic [2:0]              BranchE,
    output logic [3:0]              ALUControlE,
    output logic                    ALUSrcE,
    output logic [1:0]              UpperOpE,
    output logic [2:0]              MemoryOpE,
    output logic [DATA_WIDTH-1:0]   RD1E,
    output logic [DATA_WIDTH-1:0]   RD2E,
    output logic [DATA_WIDTH-1:0]   PCE,
    output logic [4:0]              Rs1E,
    output logic [4:0]              Rs2E,
    output logic [4:0]              RdE,
    output logic [DATA_WIDTH-1:0]   ImmExtE,
    output logic [DATA_WIDTH-1:0]   PCPlus4E,

    output logic [DATA_WIDTH-1:0]   a0

);

    wire                    RegWrite_Wire;
    wire [1:0]              ResultSrc_Wire;
    wire                    MemWrite_Wire;
    wire [1:0]              Jump_Wire;
    wire [2:0]              Branch_Wire;
    wire [3:0]              ALUControl_Wire;
    wire                    ALUSrc_Wire;
    wire [2:0]              MemoryOp_Wire;
    wire [1:0]              UpperOp_Wire;
    wire [2:0]              ImmSrc_Wire;
    wire [DATA_WIDTH-1:0]   RD1_Wire;
    wire [DATA_WIDTH-1:0]   RD2_Wire;
    wire [DATA_WIDTH-1:0]   ImmExt_Wire;

control_unit control_unit_mod (
    .op(InstrD[6:0]),
    .func3(InstrD[14:12]),
    .func7(InstrD[30]),

    .RegWriteD(RegWrite_Wire),
    .ResultSrcD(ResultSrc_Wire),
    .MemWriteD(MemWrite_Wire),
    .JumpD(Jump_Wire),
    .BranchD(Branch_Wire),
    .ALUControlD(ALUControl_Wire),
    .ALUSrcD(ALUSrc_Wire),
    .UpperOpD(UpperOp_Wire),
    .MemoryOpD(MemoryOp_Wire),
    .ImmSrcD(ImmSrc_Wire)
);

register_file register_file_mod (
    .clk(clk),
    .A1(InstrD[19:15]),
    .A2(InstrD[24:20]),
    .A3(RdW),
    .WE3(RegWriteW),
    .WD3(ResultW),

    .RD1(RD1_Wire),
    .RD2(RD2_Wire),
    .a0(a0)
);

sign_ext sign_ext_mod (
    .raw_instruction(InstrD[31:7]),
    .ImmSrc(ImmSrc_Wire),
    .ImmExt(ImmExt_Wire)
);

decode_pipeline_regfile decode_pipeline_reg (
    .en(~stall),
    .clk(clk),
    .clear(PCSrcE | reset),

    .RegWrite_i(RegWrite_Wire),
    .ResultSrc_i(ResultSrc_Wire),
    .MemWrite_i(MemWrite_Wire),
    .Jump_i(Jump_Wire),
    .Branch_i(Branch_Wire),
    .ALUControl_i(ALUControl_Wire),
    .ALUSrc_i(ALUSrc_Wire),
    .MemoryOp_i(MemoryOp_Wire),
    .UpperOp_i(UpperOp_Wire),
    .RD1_i(RD1_Wire),
    .RD2_i(RD2_Wire),
    .PC_i(PCD),             // no wire, goes directly from input -> output
    .Rs1_i(InstrD[19:15]),
    .Rs2_i(InstrD[24:20]),
    .Rd_i(InstrD[11:7]),    // no wire, goes directly from instruction -> output
    .ImmExt_i(ImmExt_Wire),
    .PCPlus4_i(PCPlus4D),   // no wire, goes directly from input -> output
    
    .RegWrite_o(RegWriteE),
    .ResultSrc_o(ResultSrcE),
    .MemWrite_o(MemWriteE),
    .Jump_o(JumpE),
    .Branch_o(BranchE),
    .ALUControl_o(ALUControlE),
    .ALUSrc_o(ALUSrcE),
    .MemoryOp_o(MemoryOpE),
    .UpperOp_o(UpperOpE),
    .RD1_o(RD1E),
    .RD2_o(RD2E),
    .PC_o(PCE),
    .Rs1_o(Rs1E),
    .Rs2_o(Rs2E),
    .Rd_o(RdE),
    .ImmExt_o(ImmExtE),
    .PCPlus4_o(PCPlus4E)
);

endmodule
