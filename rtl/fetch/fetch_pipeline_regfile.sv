module fetch_pipeline_regfile #(
    parameter   DATA_WIDTH = 32
) (
    input logic clk,
    input logic en, // en can be disabled for stall
    input logic [DATA_WIDTH-1:0] Instr_i,
    input logic [DATA_WIDTH-1:0] PC_i,
    input logic [DATA_WIDTH-1:0] PCPlus4_i,

    output logic [DATA_WIDTH-1:0] Instr_o,
    output logic [DATA_WIDTH-1:0] PC_o,
    output logic [DATA_WIDTH-1:0] PCPlus4_o

);

    always_ff @ (negedge clk) begin
        if (en) begin
            Instr_o     <= Instr_i;
            PC_o        <= PC_i;
            PCPlus4_o   <= PCPlus4_i;
        end;
    end

endmodule

/*
TO REMOVE PIPELINING AND RETURN TO SINGLE-CYCLE:
- remove/comment out clock variable
- change "always_ff @ (negedge clk)" -- to -> "always_comb"
*/
