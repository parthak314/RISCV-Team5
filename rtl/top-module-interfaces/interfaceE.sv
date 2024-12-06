interface interfaceE #(
    parameter   DATA_WIDTH = 32,
                ADDR_WIDTH = 5
    );
    logic                   RegWriteE;
    logic [1:0]             ResultSrcE;
    logic                   MemWriteE;
    logic [1:0]             JumpE;
    logic [2:0]             BranchE;
    logic [3:0]             ALUControlE;
    logic                   ALUSrcE;
    logic [1:0]             UpperOpE;
    logic [2:0]             MemoryOpE;
    logic [DATA_WIDTH-1:0]  RD1E;
    logic [DATA_WIDTH-1:0]  RD2E;
    logic [DATA_WIDTH-1:0]  PCE;
    logic [ADDR_WIDTH-1:0]  Rs1E;
    logic [ADDR_WIDTH-1:0]  Rs2E;
    logic [ADDR_WIDTH-1:0]  RdE;
    logic [DATA_WIDTH-1:0]  ImmExtE;
    logic [DATA_WIDTH-1:0]  PCPlus4E;
endinterface
