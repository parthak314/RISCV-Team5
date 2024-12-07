`include "./memory/ram2port.sv"
`include "./memory/two_way_cache_top.sv"

module memory_top #(
    parameter   DATA_WIDTH = 32,
                RAM_ADDR_WIDTH = 32 // though we only use 17 bits of this
) (
    input logic                     clk,
    input logic                     AddrMode, // address mode: 0 for word, 1 for byte
    input logic [1:0]               ResultSrc, // Connects to control unit
    input logic                     MemWrite, // Connects to control unit
    input logic [DATA_WIDTH-1:0]    PCPlus4,
    input logic [DATA_WIDTH-1:0]    ImmExt,
    input logic [DATA_WIDTH-1:0]    ALUResult, //ALUResult should be 32 bit as the ALU output is 32 bit but i have my Address 
    input logic [DATA_WIDTH-1:0]    WriteData, //Connects to reg file
    output logic [DATA_WIDTH-1:0]   Result // Connects to WD3 of reg
);
    
logic [DATA_WIDTH-1:0]  ReadData; // Connects to Mux

// input and output from ram to cache
logic                   RAMWriteEnable;
logic [DATA_WIDTH-1:0]  RAMWriteData;
logic [DATA_WIDTH-1:0]  RAMWriteAddr;
logic [DATA_WIDTH-1:0]  RAMReadData;

two_way_cache_top cache_top_mod (
    .clk(clk),
    .addr_mode(AddrMode),
    .wd(WriteData),
    .we(MemWrite),
    .addr(ALUResult),
    .rd(ReadData),
    .rd_from_ram(RAMReadData),
    .wd_to_ram(RAMWriteData),
    .we_to_ram(RAMWriteEnable),
    .w_addr_to_ram(RAMWriteAddr)
);

// if evicted, write to RAM
// note we don't need addr_mode for ram as we are handling it all in cache controller
// always read and write 32-bit word to ram
// TODO: potentially add a read enable to prevent reading when no miss
ram2port ram_mod (
    .clk(clk),
    .w_addr(RAMWriteAddr),
    .wd(RAMWriteData),
    .we(RAMWriteEnable),
    .r_addr(ALUResult),
    .rd(RAMReadData)
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
