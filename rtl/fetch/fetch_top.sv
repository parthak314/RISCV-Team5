module fetch_top #(
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic PCSrcE,
    input logic [DATA_WIDTH-1:0] PCTarget,

    output logic [DATA_WIDTH-1:0] InstrD,
    output logic [DATA_WIDTH-1:0] PCD,
    output logic [DATA_WIDTH-1:0] PCPlus4D

);

    wire [DATA_WIDTH-1:0]           pc_reg_in;
    wire [DATA_WIDTH-1:0]           pc_reg_out;
    wire [DATA_WIDTH-1:0]           PCPlus4_wire;
    wire [DATA_WIDTH-1:0]           instr_wire;

    mux mux_pc (
        .in0 (PCPlus4_wire),
        .in1 (PCTarget),
        .sel (PCSrcE),
        .out (pc_reg_in)
    );

    adder adder_PCPlus4 (
        .in0(pc_reg_out),
        .in1(4),
        .out(PCPlus4_wire)
    );

    pc_register pc_register_mod (
        .clk(clk),
        .PCin(pc_reg_in),
        .PCout(pc_reg_out)
    );

    instr_mem instr_mem_mod (
        .addr(pc_reg_out),
        .instr(instr_wire)
    );

    fetch_pipeline_regfile fetch_pipeline_reg (
        .clk(clk),

        .Instr_i(instr_wire),
        .PC_i(pc_reg_out),
        .PCPlus4_i(PCPlus4_wire),

        .Instr_o(InstrD),
        .PC_o(PCD),
        .PCPlus4_o(PCPlus4D)
    );

endmodule
