module execute_pipeline_regfile #(
    parameter   DATA_WIDTH = 32
) (
    input logic                     clk,

    input logic                     RegWrite_i,
    input logic [1:0]               ResultsSrc_i,
    input logic                     MemWrite_i,
    input logic [DATA_WIDTH-1:0]    ALUResult_i,
    input logic [DATA_WIDTH-1:0]    WriteData_i,
    input logic [4:0]               Rd_i,
    input logic [DATA_WIDTH-1:0]    PCPlus4_i,
    
    output logic                    RegWrite_o,
    output logic [1:0]              ResultsSrc_o,
    output logic                    MemWrite_o,
    output logic [DATA_WIDTH-1:0]   ALUResult_o,
    output logic [DATA_WIDTH-1:0]   WriteData_o,
    output logic [4:0]              Rd_o,
    output logic [DATA_WIDTH-1:0]   PCPlus4_o
);

    always_ff @ (negedge clk) begin

        RegWrite_o      <= RegWrite_i;
        ResultsSrc_o    <= ResultsSrc_i;
        MemWrite_o      <= MemWrite_i;
        ALUResult_o     <= ALUResult_i;
        WriteData_o     <= WriteData_i;
        Rd_o            <= Rd_i;
        PCPlus4_o       <= PCPlus4_i;
        
    end

endmodule

/*
TO REMOVE PIPELINING AND RETURN TO SINGLE-CYCLE:
- remove/comment out clock variable
- change "always_ff @ (negedge clk)" -- to -> "always_comb"
*/
