module memwrite_pipeline_regfile # (
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     RegWriteM,
    input logic                     RdM,
    input logic [DATA_WIDTH-1:0]    PCPlus4M,
    input logic [1:0]               ResultSrcM,
    input logic [DATA_WIDTH-1:0]    ALUResultM,
    input logic [DATA_WIDTH-1:0]    ReadDataM,
    output logic [DATA_WIDTH-1:0]   ALUresultW,
    output logic [DATA_WIDTH-1:0]   ReadDataW,
    output logic [DATA_WIDTH-1:0]   PCPlus4W,
    output logic [1:0]              ResultSrcW,
    output logic                    RegWriteW,
    output logic                    RdW
);

    always_ff @ (posedge clk) begin
        ALUresultW   <= ALUResultM;
        ReadDataW    <= ReadDataM;
        ResultSrcW   <= ResultSrcM;
        RegWriteW    <= RegWriteM;
        PCPlus4W     <= PCPlus4M;
        RdW          <= RdM;
    end

endmodule
