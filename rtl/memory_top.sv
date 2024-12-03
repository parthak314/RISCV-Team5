module memory_top #(
    parameter DATA_WIDTH = 32     
) (
    input logic                     clk,
    input logic [1:0]               ResultSrc, // Connects to control unit
    input logic                     MemWrite, // Connects to control unit
    input logic [DATA_WIDTH-1:0]    PCPlus4,
    input logic [DATA_WIDTH-1:0]    ImmExt,
    input logic [DATA_WIDTH-1:0]    ALUResult, //ALUResult should be 32 bit as the ALU output is 32 bit but i have my Address 
    input logic [DATA_WIDTH-1:0]    WriteData, //Connects to reg file
    output logic [DATA_WIDTH-1:0]   Result // Connects to WD3 of reg
);
    
logic [DATA_WIDTH-1:0] ReadData; // Connects to Mux

datamem data_mem_mod (
    .a(ALUResult),
    .wd(WriteData),
    .clk(clk),
    .we(MemWrite),
    .rd(ReadData)
);

mux_4x2 result_mux (
    .in0(ALUResult),
    .in1(ReadData),
    .in2(PCPlus4),
    .in3(ImmExt),
    .sel(ResultSrc),
    .out(Result)
);


endmodule
