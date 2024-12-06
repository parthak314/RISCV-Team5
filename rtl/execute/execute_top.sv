module execute_top #(
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input interfaceE                BusInput,
    input logic                     RegWriteW,  // for hazard unit
    input logic [4:0]               RdW,        // ^^^
    input logic [DATA_WIDTH-1:0]    ResultW,    // ^^^

    output interfaceM               BusOutput,
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
    wire                            PCSrc_Override_Wire;

    mux3 forwardA_hazard (
        .in0(BusInput.RD1E),
        .in1(ResultW),
        .in2(BusOutput.ALUResultM),
        .sel(ForwardA_Wire),
        .out(RD1_Wire)
    );

    mux3 forwardB_hazard (
        .in0(BusInput.RD2E),
        .in1(ResultW),
        .in2(BusOutput.ALUResultM),
        .sel(ForwardB_Wire),
        .out(RD2_Wire)
    );

    mux3 upper_operation_mux (
        .in0(RD1_Wire),
        .in1(0),
        .in2(BusInput.PCE),
        .sel(BusInput.UpperOpE),
        .out(ALU_SrcA_Wire)
    );

    mux mux_SrcB (
        .in0(RD2_Wire),
        .in1(BusInput.ImmExtE),
        .sel(BusInput.ALUSrcE),
        .out(ALU_SrcB_Wire)
    );

    alu alu_mod (
        .ALUControl(BusInput.ALUControlE),
        .SrcA(ALU_SrcA_Wire),
        .SrcB(ALU_SrcB_Wire),
        .ALUResult(ALUResult_Wire),
        .ZeroFlag(Zero_Wire),
        .NegativeFlag(Negative_Wire)
    );



    mux mux_jalr (
        .in0(BusInput.PCE),
        .in1(RD1_Wire),
        .sel(BusInput.JalrFlagE),
        .out(PCAdder_SrcA_Wire)
    );

    adder adder_PC (
        .in0(PCAdder_SrcA_Wire),
        .in1(BusInput.ImmExtE),
        .out(PCTargetE)
    );

    branch_logic branch_logic_mod (
        .Branch(BusInput.BranchE),
        .Jump(BusInput.JumpE),
        .Zero(Zero_Wire),
        .Negative(Negative_Wire),
        .PCSrcOverride(PCSrc_Override_Wire),
        .PCSrc(PCSrcE)
    );

    execute_pipeline_regfile execute_pipeline_reg (
        .clk(clk),
        .flush(PCSrc_Override_Wire),

        .RegWrite_i(BusInput.RegWriteE),
        .ResultSrc_i(BusInput.ResultSrcE),
        .MemWrite_i(BusInput.MemWriteE),
        .MemoryOp_i(BusInput.MemoryOpE),
        .ALUResult_i(ALUResult_Wire),
        .WriteData_i(BusInput.RD2E),
        .Rd_i(BusInput.RdE),
        .PCPlus4_i(BusInput.PCPlus4E),

        .RegWrite_o(BusOutput.RegWriteM),
        .ResultSrc_o(BusOutput.ResultSrcM),
        .MemWrite_o(BusOutput.MemWriteM),
        .MemoryOp_o(BusOutput.MemoryOpM),
        .ALUResult_o(BusOutput.ALUResultM),
        .WriteData_o(BusOutput.WriteDataM),
        .Rd_o(BusOutput.RdM),
        .PCPlus4_o(PCPlus4M)
    );

    hazard_unit hazard_unit_mod (
        .clk(clk),
        .PCSrc(PCSrcE),
        .PCSrcOverride(PCSrc_Override_Wire),
        
        .Rs1E(BusInput.Rs1E),
        .Rs2E(BusInput.Rs2E),
        
        .RegWriteM(BusOutput.RegWriteM),
        .RegWriteW(RegWriteW),
        .RdM(BusOutput.RdM),
        .RdW(RdW),
        
        .ForwardAE(ForwardA_Wire),
        .ForwardBE(ForwardB_Wire)

    );

endmodule