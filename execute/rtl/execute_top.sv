module execute_top #(
    parameter DATA_WIDTH = 32
) (
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
    output logic                    PCPlus4M,

    output logic [DATA_WIDTH-1:0]   PCTargetE,  // not pipelined
    output logic                    PCSrcE,     // not pipelined

);

    wire ZeroE;
    wire [DATA_WIDTH-1:0] SrcBE;

    alu alu_mod (
        .ALUControl(),
        .SrcA(),
        .SrcB(),
        .ALUResult()
    );

    mux mux_SrcB (
        .in0(),
        .in1(),
        .sel(),
        .out()
    );

    adder adder_PC (
        .in0(),
        .in1(),
        .out(),
    );

    execute_pipeline_regfile pipeline_reg (
        .clk()

        .RegWrite_i(),
        .ResultsSrc_i(),
        .MemWrite_i(),
        .ALUResult_i(),
        .WriteData_i(),
        .Rd_i(),
        .PCPlus4_i(),

        .RegWrite_o(),
        .ResultsSrc_o(),
        .MemWrite_o(),
        .ALUResult_o(),
        .WriteData_o(),
        .Rd_o(),
        .PCPlus4_o(),
    )

endmodule
