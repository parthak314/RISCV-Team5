`include "./execute/alu.sv"

module execute_top #(
    parameter DATA_WIDTH = 32
) (
    input logic [7:0]               ALUControl,
    input logic [1:0]               ALUSrc,
    input logic [DATA_WIDTH-1:0]    RD1A,
    input logic [DATA_WIDTH-1:0]    RD2A,
    input logic [DATA_WIDTH-1:0]    RD1B,
    input logic [DATA_WIDTH-1:0]    RD2B,
    input logic [DATA_WIDTH-1:0]    ImmExtA,
    input logic [DATA_WIDTH-1:0]    ImmExtB,

    output logic [DATA_WIDTH-1:0]   ALUResultA,
    output logic [DATA_WIDTH-1:0]   ALUResultB,
    // output logic                    Zero,
    // output logic                    Negative
);
    wire [DATA_WIDTH-1:0]           SrcBA;
    wire [DATA_WIDTH-1:0]           SrcBB;

    alu alu_modA (
        .ALUControl(ALUControl[7:4]),
        .SrcA(RD1A),
        .SrcB(SrcBA),
        .ALUResult(ALUResultA)
        // .ZeroFlag(Zero),
        // .NegativeFlag(Negative)
    );

    alu alu_modB (
        .ALUControl(ALUControl[3:0]),
        .SrcA(RD1B),
        .SrcB(SrcBB),
        .ALUResult(ALUResultB)
        // .ZeroFlag(Zero),
        // .NegativeFlag(Negative)
    );

    mux mux_A_SrcB (
        .in0(RD2A),
        .in1(ImmExtA),
        .sel(ALUSrc[1]),
        .out(SrcBA)
    );

    mux mux_B_SrcB (
        .in0(RD2B),
        .in1(ImmExtB),
        .sel(ALUSrc[0]),
        .out(SrcBB)
    );

endmodule
