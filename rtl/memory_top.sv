module memory_top #(
    parameter DATA_WIDTH = 32     
) (
    input logic                     clk,
    input logic                     ResultSrc, // Connects to control unit
    input logic                     MemWrite, // Connects to control unit
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

mux mymux (
    .in0(ALUResult),
    .in1(ReadData),
    .sel(ResultSrc),
    .out(Result)
)


endmodule
