module memory_pipeline_regfile #(
    parameter   DATA_WIDTH = 32,
                ADDR_WIDTH = 5
) (
    input logic                     en,
    input logic                     clk,
    input logic                     clear,
    
    input logic                     cache_miss_i,
    input logic                     RegWrite_i,
    input logic [1:0]               ResultSrc_i,
    input logic [DATA_WIDTH-1:0]    ALUResult_i,
    input logic [DATA_WIDTH-1:0]    ReadData_i,
    input logic [ADDR_WIDTH-1:0]    Rd_i,
    input logic [DATA_WIDTH-1:0]    PCPlus4_i,

    output logic                    cache_miss_o,
    output logic                    RegWrite_o,
    output logic [1:0]              ResultSrc_o,
    output logic [DATA_WIDTH-1:0]   ALUResult_o,
    output logic [DATA_WIDTH-1:0]   ReadData_o,
    output logic [ADDR_WIDTH-1:0]   Rd_o,
    output logic [DATA_WIDTH-1:0]   PCPlus4_o
);

    always_ff @ (negedge clk) begin

        cache_miss_o    <= cache_miss_i;

        if (en & !clear) begin
            RegWrite_o      <= RegWrite_i;
            ResultSrc_o     <= ResultSrc_i;
            ALUResult_o     <= ALUResult_i;
            ReadData_o      <= ReadData_i;
            Rd_o            <= Rd_i;
            PCPlus4_o       <= PCPlus4_i;     
        end

        else if (clear) begin
            cache_miss_o    <= 0;
            RegWrite_o      <= 0;
            ResultSrc_o     <= 0;
            ALUResult_o     <= 0;
            ReadData_o      <= 0;
            Rd_o            <= 0;
            PCPlus4_o       <= 0;
        end

    end

endmodule
