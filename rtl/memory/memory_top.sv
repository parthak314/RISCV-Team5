module memory_top #(
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     stall,
    input logic                     reset,

    input logic                     RegWriteM,
    input logic [1:0]               ResultsSrcM,
    input logic                     MemWriteM,
    input logic [2:0]               MemoryOpM,
    input logic [DATA_WIDTH-1:0]    ALUResultM,
    input logic [DATA_WIDTH-1:0]    WriteDataM,
    input logic [4:0]               RdM,
    input logic [DATA_WIDTH-1:0]    PCPlus4M,

    output logic [DATA_WIDTH-1:0]   ReadDataM, // to feed back into execute stage for data hazard forwarding

    output logic                    RegWriteW,
    output logic [4:0]              RdW,
    output logic [DATA_WIDTH-1:0]   ResultW
);

    wire [DATA_WIDTH-1:0]   ALUResultW_Wire;
    wire [DATA_WIDTH-1:0]   RAM_Input_Wire;
    wire [DATA_WIDTH-1:0]   RAM_Output_Wire;
    wire [1:0]              ResultSrcW_Wire;
    wire [DATA_WIDTH-1:0]   PCPlus4W_Wire;
    wire [DATA_WIDTH-1:0]   ParseUnit_DataOut_Wire;
    wire [DATA_WIDTH-1:0]   ReadDataW_Wire;

    assign ReadDataM = ParseUnit_DataOut_Wire;

    data_mem mem (
        .clk(clk),
        .A(ALUResultM),
        .WD(RAM_Input_Wire),
        .WE(MemWriteM),
        .RD(RAM_Output_Wire)
    );

    loadstore_parsing_unit parsing_unit (
        .MemoryOp(MemoryOpM),
        .RAM_Out(RAM_Output_Wire),
        .WriteData(WriteDataM),
        .RAM_In(RAM_Input_Wire),
        .ReadData(ParseUnit_DataOut_Wire)
    );

    memory_pipeline_regfile memory_pipeline_reg (
        .en(~stall),
        .clk(clk),
        .clear(reset),
        
        .RegWrite_i(RegWriteM),
        .ResultSrc_i(ResultsSrcM),
        .ALUResult_i(ALUResultM),
        .ReadData_i(ParseUnit_DataOut_Wire),
        .Rd_i(RdM),
        .PCPlus4_i(PCPlus4M),

        .RegWrite_o(RegWriteW),
        .ResultSrc_o(ResultSrcW_Wire),
        .ALUResult_o(ALUResultW_Wire),
        .ReadData_o(ReadDataW_Wire),
        .Rd_o(RdW),
        .PCPlus4_o(PCPlus4W_Wire)
    );

    mux3 result_writeback_mux (
        .in0(ALUResultW_Wire),
        .in1(ReadDataW_Wire),
        .in2(PCPlus4W_Wire),
        .sel(ResultSrcW_Wire),
        .out(ResultW)
    );

endmodule
