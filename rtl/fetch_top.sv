module fetch_top # (
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic [1:0] PCSrc, // mux sel line: 0 = pc + 4, 1 = branch (pc + imm), 2 = jump (from aluresult), 3 = pc (stall)
    input logic [DATA_WIDTH-1:0] Result, // result from ALU
    input logic [DATA_WIDTH-1:0] ImmExt, // output of extended imm
    output logic [DATA_WIDTH-1:0] Instr, // output instruction from instr_mem
    output logic [DATA_WIDTH-1:0] PCPlus4
);

    logic [DATA_WIDTH-1:0] PCTarget, PCNext, PC;

    mux_4x2 mux_pc (
        .in0 (PCPlus4),
        .in1 (PCTarget),
        .in2 (Result),
        .in3(PC),
        .sel (PCSrc),
        .out (PCNext)
    );

    adder adder_branch_pc (
        .in0 (PC),
        .in1 (ImmExt),
        .out (PCTarget)
    );

    adder adder_pcplus4 (
        .in0 (PC),
        .in1 (4),
        .out (PCPlus4)
    );

    pc_register pc_reg (
        .clk (clk),
        .rst (rst),
        .PCNext (PCNext),
        .out_PC (PC)
    );

    instr_mem instr_mem_mod (
        .addr(PC),
        .instr(Instr)
    );

endmodule
