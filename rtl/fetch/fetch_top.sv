`include "./fetch/instr_mem.sv"
`include "./fetch/pc_register.sv"

module fetch_top # (
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic PCSrc, // mux sel line: 0 = pcIncr, 1 = PC (stall)
    output logic [DATA_WIDTH-1:0] InstrA, // output instruction from instr_mem
    output logic [DATA_WIDTH-1:0] InstrB
);

    logic [DATA_WIDTH-1:0] PCNext, PC;

    mux mux_pc (
        .in0 (PC + 8),
        .in1 (PC),
        .sel (PCSrc),
        .out (PCNext)
    );

    pc_register pc_reg (
        .clk (clk),
        .rst (rst),
        .PCNext (PCNext),
        .out_PC (PC)
    );

    instr_mem instr_mem_mod (
        .addr(PC),
        .instrA (InstrA),
        .instrB (InstrB)
    );

endmodule
