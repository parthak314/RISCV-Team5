interface interfaceD #(
    parameter   DATA_WIDTH = 32
    );
    logic [DATA_WIDTH-1:0] InstrD;
    logic [DATA_WIDTH-1:0] PCD;
    logic [DATA_WIDTH-1:0] PCPlus4D;
endinterface
