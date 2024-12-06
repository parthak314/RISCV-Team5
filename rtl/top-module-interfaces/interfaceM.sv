interface execute_memwrite #(
    parameter   DATA_WIDTH = 32,
                ADDR_WIDTH = 5
    );
    logic                   RegWriteM;
    logic [1:0]             ResultSrcM;
    logic                   MemWriteM;
    logic [2:0]             MemoryOpM;
    logic [DATA_WIDTH-1:0]  ALUResultM;
    logic [DATA_WIDTH-1:0]  WriteDataM;
    logic [ADDR_WIDTH-1:0]  RdM;
    logic [DATA_WIDTH-1:0]  PCPlus4M;
endinterface
