interface memwrite_fetch #(
    parameter   DATA_WIDTH = 32,
                ADDR_WIDTH = 5
    );
    logic                   RegWriteW;
    logic [ADDR_WIDTH-1:0]  RdW;
    logic [DATA_WIDTH-1:0]  ResultW;
endinterface
