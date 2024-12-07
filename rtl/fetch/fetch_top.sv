module fetch_top #(
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     PCSrc,
    input logic [DATA_WIDTH-1:0]    PCTarget,

    output logic [DATA_WIDTH-1:0]   InstrD,
    output logic [DATA_WIDTH-1:0]   PCD,
    output logic [DATA_WIDTH-1:0]   PCPlus4D

);

    wire [DATA_WIDTH-1:0]           PC_Reg_In;
    wire [DATA_WIDTH-1:0]           PC_Reg_Out;
    wire [DATA_WIDTH-1:0]           PCPlus4_Wire;
    wire [DATA_WIDTH-1:0]           Instr_Wire;

    mux mux_pc (
        .in0 (PCPlus4_Wire),
        .in1 (PCTarget),
        .sel (PCSrc),
        .out (PC_Reg_In)
    );

    adder adder_PCPlus4 (
        .in0(PC_Reg_Out),
        .in1(4),
        .out(PCPlus4_Wire)
    );

    pc_register pc_register_mod (
        .clk(clk),
        .PCin(PC_Reg_In),
        .PCout(PC_Reg_Out)
    );

    instr_mem instr_mem_mod (
        .addr(PC_Reg_Out),
        .instr(Instr_Wire)
    );

    fetch_pipeline_regfile fetch_pipeline_reg (
        .clk(clk),

        .Instr_i(Instr_Wire),
        .PC_i(PC_Reg_Out),
        .PCPlus4_i(PCPlus4_Wire),

        .Instr_o(InstrD),
        .PC_o(PCD),
        .PCPlus4_o(PCPlus4D)
    );

endmodule
