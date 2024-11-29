module top #(
    parameter DATA_WIDTH = 32     
) (
    logic input clk
);
    
logic [DATA_WIDTH-1:0] ALUResult; //ALUResult should be 32 bit as the ALU output is 32 bit but i have my Address 
logic [DATA_WIDTH-1:0] WriteData; //Connects to reg file
logic [DATA_WIDTH-1:0] ALUcompare; //This is the wire that muxes with ReadData
logic [DATA_WIDTH-1:0] ReadData; // Connects to Mux
logic [DATA_WIDTH-1:0] MemWrite; // Connects to control unit 
logic [DATA_WIDTH-1:0] ResultSrc; // Connects to control unit
logic [DATA_WIDTH-1:0] Result; // Connects to WD3 of reg

datamem mydata (
    .a(ALUResult),
    .wd(WriteData),
    .clk(clk),
    .we(MemWrite),
    .rd(ReadData)
);

mux mymux (
    .in0(ALUcompare),
    .in1(ReadData),
    .sel(ResultSrc),
    .out(Result)
)


endmodule
