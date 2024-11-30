module execute_top #(
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     JumpE,
    input logic [2:0]               BranchE,
    input logic [3:0]               ALUControl,
    input logic                     ALUSrc,
    input logic [DATA_WIDTH-1:0]    RD1,
    input logic [DATA_WIDTH-1:0]    RD2,
    input logic [DATA_WIDTH-1:0]    ImmExt,

    output logic [DATA_WIDTH-1:0]   ALUResult,
    output logic                    Zero,
    output logic                    Negative
);
    wire [DATA_WIDTH-1:0]           srcB_wire;

    alu alu_mod (
        .ALUControl(ALUControl),
        .SrcA(RD1),
        .SrcB(srcB_wire),
        .ALUResult(ALUResult),
        .ZeroFlag(Zero),
        .NegativeFlag(Negative)
    );

    mux mux_SrcB (
        .in0(RD2),
        .in1(ImmExt),
        .sel(ALUSrc),
        .out(srcB_wire)
    );

endmodule
