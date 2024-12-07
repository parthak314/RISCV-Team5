module execute_pipeline_regfile #(
    parameter   DATA_WIDTH = 32,
                ADDR_WIDTH = 5
) (
    input logic                     en,
    input logic                     clk,
    input logic                     clear,

    input logic                     RegWrite_i,
    input logic [1:0]               ResultSrc_i,
    input logic                     MemWrite_i,
    input logic [2:0]               MemoryOp_i,
    input logic [DATA_WIDTH-1:0]    ALUResult_i,
    input logic [DATA_WIDTH-1:0]    WriteData_i,
    input logic [ADDR_WIDTH-1:0]    Rd_i,
    input logic [DATA_WIDTH-1:0]    PCPlus4_i,
    
    output logic                    RegWrite_o,
    output logic [1:0]              ResultSrc_o,
    output logic                    MemWrite_o,
    output logic [2:0]              MemoryOp_o,
    output logic [DATA_WIDTH-1:0]   ALUResult_o,
    output logic [DATA_WIDTH-1:0]   WriteData_o,
    output logic [ADDR_WIDTH-1:0]   Rd_o,
    output logic [DATA_WIDTH-1:0]   PCPlus4_o
);

    always_ff @ (negedge clk) begin

        if (en & !clear) begin
            RegWrite_o      <= RegWrite_i;
            ResultSrc_o     <= ResultSrc_i;
            MemWrite_o      <= MemWrite_i;
            MemoryOp_o      <= MemoryOp_i;
            ALUResult_o     <= ALUResult_i;
            WriteData_o     <= WriteData_i;
            Rd_o            <= Rd_i;
            PCPlus4_o       <= PCPlus4_i;    
        end

        else if (clear) begin
            RegWrite_o      <= 0;
            ResultSrc_o     <= 0;
            MemWrite_o      <= 0;
            MemoryOp_o      <= 0;
            ALUResult_o     <= 0;
            WriteData_o     <= 0;
            Rd_o            <= 0;
            PCPlus4_o       <= 0;
        end

    end

endmodule
