module execute_top #(
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     RegWriteE,
    input logic [1:0]               ResultsSrcE,
    input logic                     MemWriteE,
    input logic                     JumpE,
    input logic                     BranchE,
    input logic [2:0]               ALUControlE,
    input logic                     ALUSrcE,
    input logic [DATA_WIDTH-1:0]    RD1E,
    input logic [DATA_WIDTH-1:0]    RD2E,
    input logic [DATA_WIDTH-1:0]    PCE,
    input logic [4:0]               RdE,
    input logic [DATA_WIDTH-1:0]    ImmExtE,
    input logic [DATA_WIDTH-1:0]    PCPlus4E,

    output logic                    RegWriteM,
    output logic [1:0]              ResultsSrcM,
    output logic                    MemWriteM,
    output logic [DATA_WIDTH-1:0]   ALUResultM,
    output logic [DATA_WIDTH-1:0]   WriteDataM,
    output logic [4:0]              RdM,    
    output logic [DATA_WIDTH-1:0]   PCPlus4M,

    output logic [DATA_WIDTH-1:0]   PCTargetE,  // not pipelined
    output logic                    PCSrcE     // not pipelined

);

    wire                            zero_wire;
    wire                            negative_wire;
    wire [DATA_WIDTH-1:0]           srcB_wire;
    wire [DATA_WIDTH-1:0]           aluResult_wire;

    alu alu_mod (
        .ALUControl(ALUControlE),
        .SrcA(RD1E),
        .SrcB(srcB_wire),
        .ALUResult(aluResult_wire),
        .ZeroFlag(zero_wire),
        .NegativeFlag(negative_wire)
    );

    mux mux_SrcB (
        .in0(RD2E),
        .in1(ImmExtE),
        .sel(ALUSrcE),
        .out(srcB_wire)
    );

    adder adder_PC (
        .in0(PCE),
        .in1(ImmExtE),
        .out(PCTargetE)
    );

    branch_logic branch_logic_mod (
        .branch({2'b0, BranchE}), // change to just BranchE once implemented as 3-bit in control unit
        .jump(JumpE),
        .zero(zero_wire),
        .negative(negative_wire),
        .PCSrc(PCSrcE)
    );

    execute_pipeline_regfile pipeline_reg (
        .clk(clk),

        .RegWrite_i(RegWriteE),
        .ResultsSrc_i(ResultsSrcE),
        .MemWrite_i(MemWriteE),
        .ALUResult_i(aluResult_wire),
        .WriteData_i(RD2E),
        .Rd_i(RdE),
        .PCPlus4_i(PCPlus4E),

        .RegWrite_o(RegWriteM),
        .ResultsSrc_o(ResultsSrcM),
        .MemWrite_o(MemWriteM),
        .ALUResult_o(ALUResultM),
        .WriteData_o(WriteDataM),
        .Rd_o(RdM),
        .PCPlus4_o(PCPlus4M)
    );

endmodule
