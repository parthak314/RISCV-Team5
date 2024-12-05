module decode_pipeline_reg #(
    parameter DATA_WIDTH = 32,
              ADDR_WIDTH = 5
)(
    input   logic                   clk,   
    input   logic                   clr, 

    // input control signals       
    input   logic                   RegWriteD,
    input   logic [1:0]             ResultSrcD,
    input   logic                   MemWriteD,
    input   logic [1:0]             JumpD,
    input   logic [2:0]             BranchD,
    input   logic [3:0]             ALUControlD,
    input   logic                   ALUSrcD,

    // other inputs
    input   logic [DATA_WIDTH-1:0]  Rd1D,
    input   logic [DATA_WIDTH-1:0]  Rd2D,
    input   logic [DATA_WIDTH-1:0]  PCD,
    input   logic [ADDR_WIDTH-1:0]  Rs1D,
    input   logic [ADDR_WIDTH-1:0]  Rs2D,
    input   logic [ADDR_WIDTH-1:0]  RdD,
    input   logic [DATA_WIDTH-1:0]  ImmExtD,
    input   logic [DATA_WIDTH-1:0]  PCPlus4D,

    // output control signals
    output  logic                   RegWriteE,
    output  logic                   ResultSrcE,
    output  logic                   MemWriteE,
    output  logic [1:0]             JumpE,
    output  logic [2:0]             BranchE,
    output  logic [3:0]             ALUControlE,
    output  logic                   ALUSrcE,

    // other outputs
    output   logic [DATA_WIDTH-1:0]  Rd1E,
    output   logic [DATA_WIDTH-1:0]  Rd2E,
    output   logic [DATA_WIDTH-1:0]  PCE,
    output   logic [ADDR_WIDTH-1:0]  Rs1E,
    output   logic [ADDR_WIDTH-1:0]  Rs2E,
    output   logic [ADDR_WIDTH-1:0]  RdE,
    output   logic [DATA_WIDTH-1:0]  ImmExtE,
    output   logic [DATA_WIDTH-1:0]  PCPlus4E

);

always_ff @(posedge clk) begin
    if (clr) begin
        // assign all outputs to zero
        {RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE, 
         Rd1E, Rd2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E} <= '0;
    end else begin
        // assign inputs to outputs
        {RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE, 
         Rd1E, Rd2D, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E} <= 
         {RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, 
          Rd1D, Rd2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D};
    end
end



endmodule
