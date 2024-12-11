`include "./memory/datamem.sv"

module memory_top #(
    parameter DATA_WIDTH = 32     
) (
    input logic                     clk,
    input logic [1:0]               ResultSrc, 
    input logic [1:0]               MemWrite, 
    input logic [DATA_WIDTH-1:0]    ALUResultA,
    input logic [DATA_WIDTH-1:0]    ALUResultB,
    input logic [DATA_WIDTH-1:0]    wdataA, 
    input logic [DATA_WIDTH-1:0]    wdataB, 
    output logic [DATA_WIDTH-1:0]   ResultA,
    output logic [DATA_WIDTH-1:0]   ResultB
);
    
    logic [DATA_WIDTH-1:0] ReadDataA;
    logic [DATA_WIDTH-1:0] ReadDataB;


datamem data_mem_mod (
    .clk            (clk),
    .write_enable   (MemWrite),
    .addrA          (ALUResultA),
    .addrB          (ALUResultB),
    .wdataA         (wdataA),
    .wdataB         (wdataB),
    .rdataA         (ReadDataA),
    .rdataB         (ReadDataB)
);

mux resultA_mux (
    .in0    (ALUResultA),
    .in1    (ReadDataA),
    .sel    (ResultSrc[1]),
    .out    (ResultA)
);

mux resultB_mux (
    .in0    (ALUResultB),
    .in1    (ReadDataB),
    .sel    (ResultSrc[0]),
    .out    (ResultB)
);

endmodule
