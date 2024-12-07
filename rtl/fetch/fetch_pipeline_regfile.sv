module fetch_pipeline_regfile #(
    parameter   DATA_WIDTH = 32
) (
    input logic                     en,
    input logic                     clk,
    input logic                     clear,

    input logic [DATA_WIDTH-1:0]    Instr_i,
    input logic [DATA_WIDTH-1:0]    PC_i,
    input logic [DATA_WIDTH-1:0]    PCPlus4_i,

    output logic [DATA_WIDTH-1:0]   Instr_o,
    output logic [DATA_WIDTH-1:0]   PC_o,
    output logic [DATA_WIDTH-1:0]   PCPlus4_o

);

    always_ff @ (negedge clk) begin

        if (en & !clear) begin
            Instr_o     <= Instr_i;
            PC_o        <= PC_i;
            PCPlus4_o   <= PCPlus4_i;    
        end

        else if (clear) begin
            Instr_o     <= 0;
            PC_o        <= 0;
            PCPlus4_o   <= 0;
        end

    end

endmodule
