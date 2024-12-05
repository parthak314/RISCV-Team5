module memwrite_top #(
    parameter DATA_WIDTH = 32     
) (
    input logic                     clk,
    input logic                     RegWriteM,
    input logic                     RdM,
    input logic [DATA_WIDTH-1:0]    PCPlus4M,
    input logic [1:0]               ResultSrcM,
    input logic [DATA_WIDTH-1:0]    ALUResultM,
    input logic [DATA_WIDTH-1:0]    WriteDataM,
    input logic                     MemWriteM,
    output logic                    RegWriteW,
    output logic                    RdW,
    output logic [DATA_WIDTH-1:0]   ResultW
);

logic [DATA_WIDTH-1:0]   ALUresultW;
logic [DATA_WIDTH-1:0]   ReadDataW;
logic [DATA_WIDTH-1:0]   PCPlus4W;
logic [1:0]              ResultSrcW;
logic [DATA_WIDTH-1:0]   ReadData;

data_ram ram (
    .a(ALUResultM),
    .wd(WriteDataM),
    .clk(clk),
    .we(MemWriteM),
    .rd(ReadData)
);

memwrite_pipeline_regfile memwrite_pipeline_reg (
    .clk(clk),
    .RegWriteM(RegWriteM),
    .RdM(RdM),
    .PCPlus4M(PCPlus4M),
    .ResultSrcM(ResultSrcM),
    .ALUResultM(ALUResultM),
    .ReadDataM(ReadData),
    .ALUresultW(ALUresultW),
    .ReadDataW(ReadDataW),
    .PCPlus4W(PCPlus4W),
    .ResultSrcW(ResultSrcW),
    .RegWriteW(RegWriteW),
    .RdW(RdW)
);

mux4 result_mux (
    .in0(ALUresultW),
    .in1(ReadDataW),
    .in2(PCPlus4W),
    .in3(0),
    .sel(ResultSrcW),
    .out(ResultW)
);


endmodule
