module fetch_top # (
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic trigger, // needed for f1 fsm. Acts as an ~en input
    input logic [1:0] PCSrc, // mux sel line: 0 = pc + 4, 1 = branch (pc + imm), 2 = jump (from aluresult)
    input logic [DATA_WIDTH-1:0] Result, // result from ALU
    input logic [DATA_WIDTH-1:0] ImmExt, // output of extended imm
    output logic [DATA_WIDTH-1:0] Instr, // output instruction from instr_mem
    output logic [DATA_WIDTH-1:0] PCPlus4
);

    logic [DATA_WIDTH-1:0] PCTarget, PCNext, PC, PCTrigger;

    mux_4x2 mux_pc (
        .in0 (PCPlus4),
        .in1 (PCTarget),
        .in2 (Result),
        .in3(0), // spare mux position. Not implemented, but can be used for PC reset
        .sel (PCSrc),
        .out (PCNext)
    );

    // mux after mux_pc to determine if we should progress
    // or just stall at the current pc ie PCNext = PC
    mux mux_trigger (
        .in0 (PCNext),
        .in1 (PC),
        .sel (trigger),
        .out (PCTrigger)
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
        .PCTrigger (PCTrigger),
        .out_PC (PC)
    );

    instr_mem instr_mem_mod (
        .addr(PC),
        .instr(Instr)
    );

endmodule
