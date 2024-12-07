module execute_top #(
    parameter   DATA_WIDTH = 32,
                ADDR_WIDTH = 5
) (
    input logic                     clk,
    input logic                     stall,
    input logic                     reset,

    input logic                     RegWriteE,
    input logic [1:0]               ResultSrcE,
    input logic                     MemWriteE,
    input logic [1:0]               JumpE,
    input logic [2:0]               BranchE,
    input logic [3:0]               ALUControlE,
    input logic                     ALUSrcE,
    input logic [1:0]               UpperOpE,
    input logic [2:0]               MemoryOpE,
    input logic [DATA_WIDTH-1:0]    RD1E,
    input logic [DATA_WIDTH-1:0]    RD2E,
    input logic [DATA_WIDTH-1:0]    PCE,
    input logic [ADDR_WIDTH-1:0]    Rs1E,
    input logic [ADDR_WIDTH-1:0]    Rs2E,
    input logic [ADDR_WIDTH-1:0]    RdE,
    input logic [DATA_WIDTH-1:0]    ImmExtE,
    input logic [DATA_WIDTH-1:0]    PCPlus4E,

    input logic                     RegWriteW,  // for hazard unit
    input logic [4:0]               RdW,        // ^^^
    input logic [DATA_WIDTH-1:0]    ResultW,    // ^^^

    output logic                    RegWriteM,
    output logic [1:0]              ResultSrcM,
    output logic                    MemWriteM,
    output logic [2:0]              MemoryOpM,
    output logic [DATA_WIDTH-1:0]   ALUResultM,
    output logic [DATA_WIDTH-1:0]   WriteDataM,
    output logic [ADDR_WIDTH-1:0]   RdM,
    output logic [DATA_WIDTH-1:0]   PCPlus4M,

    output logic [DATA_WIDTH-1:0]   PCTargetE,  // not pipelined, feeds back to fetch stage
    output logic                    PCSrcE      // ^^^

);

    wire [1:0]                      ForwardA_Wire; // from haz unit
    wire [1:0]                      ForwardB_Wire; // ^^^
    wire [DATA_WIDTH-1:0]           RD1_Wire;
    wire [DATA_WIDTH-1:0]           RD2_Wire;
    wire [DATA_WIDTH-1:0]           ALU_SrcA_Wire;
    wire [DATA_WIDTH-1:0]           ALU_SrcB_Wire;
    wire [DATA_WIDTH-1:0]           ALUResult_Wire;
    wire                            Zero_Wire;
    wire                            Negative_Wire;
    wire [DATA_WIDTH-1:0]           PCAdder_SrcA_Wire;

    mux3 forwardA_hazard (
        .in0(RD1E),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardA_Wire),
        .out(RD1_Wire)
    );

    mux3 forwardB_hazard (
        .in0(RD2E),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardB_Wire),
        .out(RD2_Wire)
    );

    mux3 upper_operation_mux (
        .in0(RD1_Wire),
        .in1(0),
        .in2(PCE),
        .sel(UpperOpE),
        .out(ALU_SrcA_Wire)
    );

    mux mux_SrcB (
        .in0(RD2_Wire),
        .in1(ImmExtE),
        .sel(ALUSrcE),
        .out(ALU_SrcB_Wire)
    );

    alu alu_mod (
        .ALUControl(ALUControlE),
        .SrcA(ALU_SrcA_Wire),
        .SrcB(ALU_SrcB_Wire),
        .ALUResult(ALUResult_Wire),
        .ZeroFlag(Zero_Wire),
        .NegativeFlag(Negative_Wire)
    );

    mux mux_jalr (
        .in0(PCE),
        .in1(RD1_Wire),
        .sel(JumpE == 2'b10),
        .out(PCAdder_SrcA_Wire)
    );

    adder adder_PC (
        .in0(PCAdder_SrcA_Wire),
        .in1(ImmExtE),
        .out(PCTargetE)
    );

    branch_logic branch_logic_mod (
        .Branch(BranchE),
        .Jump(JumpE),
        .Zero(Zero_Wire),
        .Negative(Negative_Wire),
        .PCSrc(PCSrcE)
    );

    execute_pipeline_regfile execute_pipeline_reg (
        .en(~stall),
        .clk(clk),
        .clear(reset),

        .RegWrite_i(RegWriteE),
        .ResultSrc_i(ResultSrcE),
        .MemWrite_i(MemWriteE),
        .MemoryOp_i(MemoryOpE),
        .ALUResult_i(ALUResult_Wire),
        .WriteData_i(RD2E),
        .Rd_i(RdE),
        .PCPlus4_i(PCPlus4E),

        .RegWrite_o(RegWriteM),
        .ResultSrc_o(ResultSrcM),
        .MemWrite_o(MemWriteM),
        .MemoryOp_o(MemoryOpM),
        .ALUResult_o(ALUResultM),
        .WriteData_o(WriteDataM),
        .Rd_o(RdM),
        .PCPlus4_o(PCPlus4M)
    );

    hazard_unit hazard_unit_mod (        
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RdM(RdM),
        .RdW(RdW),
        
        .ForwardAE(ForwardA_Wire),
        .ForwardBE(ForwardB_Wire)

    );

endmodule
