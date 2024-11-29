module fetch_top # (
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic PCsrc, // mux sel line: select PC + Imm if 1, else select PC + 4 (increment by 4 bytes)
    input logic [DATA_WIDTH-1:0] ImmOp,
    output logic [DATA_WIDTH-1:0] Instr
);

    logic [DATA_WIDTH-1:0] PCTarget, PCPlus4, PCNext, PC;

    mux mux_pc (
        .in0 (PCPlus4),
        .in1 (PCTarget),
        .sel (PCsrc),
        .out (PCNext)
    );

    adder adder_branch_pc (
        .in0 (PC),
        .in1 (ImmOp),
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
