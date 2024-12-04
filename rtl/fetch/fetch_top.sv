`include "./fetch/instr_mem.sv"
`include "./fetch/pc_register.sv"
`include "./fetch/fetch_pipeline_regfile.sv"

module fetch_top #(
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic en, // en for pipeline register
    input logic rst,
    input logic [1:0] PCSrcE,
    input logic [DATA_WIDTH-1:0] ResultW,

    // from decode_top
    input logic [DATA_WIDTH-1:0] PCE,
    input logic [DATA_WIDTH-1:0] RdE,
    input logic [DATA_WIDTH-1:0] ImmExtE,


    output logic [DATA_WIDTH-1:0] InstrD,
    output logic [DATA_WIDTH-1:0] PCD,
    output logic [DATA_WIDTH-1:0] PCPlus4D

);
    wire [DATA_WIDTH-1:0]           PCF_in;
    wire [DATA_WIDTH-1:0]           PCF_out;
    wire [DATA_WIDTH-1:0]           PCPlus4_wire;
    wire [DATA_WIDTH-1:0]           Instr_wire;
    wire [DATA_WIDTH-1:0]           PCTargetE_wire;

    mux_4x2 mux_pc (
        .in0 (PCPlus4_wire),
        .in1 (PCTargetE_wire),
        .in2 (ResultW),
        .in3 (PCF_out),
        .sel (PCSrcE),
        .out (PCF_in)
    );

    adder adder_PCPlus4 (
        .in0(PCF_out),
        .in1(4),
        .out(PCPlus4_wire)
    );

    adder adder_PCPlusImm (
        .in0(PCE),
        .in1(ImmExtE),
        .out(PCTargetE_wire)
    );

    pc_register pc_register_mod (
        .clk(clk),
        .rst(rst),
        .PCin(PCF_in),
        .PCout(PCF_out)
    );

    instr_mem instr_mem_mod (
        .addr(PCF_out),
        .instr(Instr_wire)
    );

    fetch_pipeline_regfile fetch_pipeline_reg (
        .clk(clk),
        .en(en),

        .Instr_i(Instr_wire),
        .PC_i(PCF_out),
        .PCPlus4_i(PCPlus4_wire),

        .Instr_o(InstrD),
        .PC_o(PCD),
        .PCPlus4_o(PCPlus4D)
    );

endmodule
