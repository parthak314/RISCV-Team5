module memwrite_top #(
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

    wire                    RAM_ReadEnable_Wire;
    wire                    RAM_WriteEnable_Wire;
    wire [DATA_WIDTH-1:0]   RAM_WriteAddr_Wire;
    wire [DATA_WIDTH-1:0]   RAM_WriteDataIn_Wire;

    wire [DATA_WIDTH-1:0]   RAM_ReadDataOut_Wire;
    wire [DATA_WIDTH-1:0]   ReadDataM_Wire;

    wire [DATA_WIDTH-1:0]   Parse_ReadData_Wire;
    wire [DATA_WIDTH-1:0]   Parse_WriteData_Wire;
    wire [1:0]              ByteOffset_Wire;

    wire [1:0]              ResultSrcW_Wire;
    wire [DATA_WIDTH-1:0]   ALUResultW_Wire;
    wire [DATA_WIDTH-1:0]   ReadDataW_Wire;
    wire [DATA_WIDTH-1:0]   PCPlus4W_Wire;


    // only access cache when we are reading or writing to memory (prevent unnecessary evictions)
    logic   CacheAccessEnable; 
    assign  CacheAccessEnable = (ResultsSrcM == 2'b01 || MemWriteM);

    assign  ReadDataM = ReadDataM_Wire;

    two_way_cache_top cache_top (
        .clk(clk),
        .en(CacheAccessEnable),
        // .addr_mode(MemoryOpM == 3'b000 | MemoryOpM == 3'b011), // addr_mode = 1 if byte or byte unsigned operation
        .wd(Parse_WriteData_Wire),
        .we(MemWriteM),
        .addr(ALUResultM),

        .rd_from_ram(RAM_ReadDataOut_Wire),
        .re_from_ram(RAM_ReadEnable_Wire),

        .wd_to_ram(RAM_WriteDataIn_Wire),
        .we_to_ram(RAM_WriteEnable_Wire),
        .w_addr_to_ram(RAM_WriteAddr_Wire),

        .offset(ByteOffset_Wire),
        .rd(Parse_ReadData_Wire)
    );

    loadstore_parsing_unit parse_unit (
        .MemoryOp(MemoryOpM),
        .ByteOffset(ByteOffset_Wire),
        .MemReadOutData(Parse_ReadData_Wire),
        .WriteData(WriteDataM),
        .MemWriteInData(Parse_WriteData_Wire),
        .ReadData(ReadDataM_Wire)
    );

    dram_main_mem main_memory_ram (
        .clk(clk),
        .w_addr(RAM_WriteAddr_Wire),
        .wd(RAM_WriteDataIn_Wire),
        .we(RAM_WriteEnable_Wire),
        .r_addr({ALUResultM[31:2], 2'b0}), // always read from ram in 32 bit word blocks (byte addressing handled in cache only)
        .re(RAM_ReadEnable_Wire),
        .rd(RAM_ReadDataOut_Wire)
    );

    memwrite_pipeline_regfile memwrite_pipeline_reg (
        .en(~stall),
        .clk(clk),
        .clear(reset),
        
        .RegWrite_i(RegWriteM),
        .ResultSrc_i(ResultsSrcM),
        .ALUResult_i(ALUResultM),
        .ReadData_i(ReadDataM_Wire),
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
