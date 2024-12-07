module decode_pipeline_regfile #(
    parameter   DATA_WIDTH = 32,
                ADDR_WIDTH = 5
) (
    input logic                     clk,
    input logic                     flush,

    input logic                     RegWrite_i,
    input logic [1:0]               ResultSrc_i,
    input logic                     MemWrite_i,
    input logic [1:0]               Jump_i,
    input logic [2:0]               Branch_i,
    input logic [3:0]               ALUControl_i,
    input logic                     ALUSrc_i,
    input logic [1:0]               UpperOp_i,
    input logic [2:0]               MemoryOp_i,
    input logic [DATA_WIDTH-1:0]    RD1_i,
    input logic [DATA_WIDTH-1:0]    RD2_i,
    input logic [DATA_WIDTH-1:0]    PC_i,
    input logic [ADDR_WIDTH-1:0]    Rs1_i,
    input logic [ADDR_WIDTH-1:0]    Rs2_i,
    input logic [ADDR_WIDTH-1:0]    Rd_i,
    input logic [DATA_WIDTH-1:0]    ImmExt_i,
    input logic [DATA_WIDTH-1:0]    PCPlus4_i,

    output logic                    RegWrite_o,
    output logic [1:0]              ResultSrc_o,
    output logic                    MemWrite_o,
    output logic [1:0]              Jump_o,
    output logic [2:0]              Branch_o,
    output logic [3:0]              ALUControl_o,
    output logic                    ALUSrc_o,
    output logic [1:0]              UpperOp_o,
    output logic [2:0]              MemoryOp_o,
    output logic [DATA_WIDTH-1:0]   RD1_o,
    output logic [DATA_WIDTH-1:0]   RD2_o,
    output logic [DATA_WIDTH-1:0]   PC_o,
    output logic [ADDR_WIDTH-1:0]   Rs1_o,
    output logic [ADDR_WIDTH-1:0]   Rs2_o,
    output logic [ADDR_WIDTH-1:0]   Rd_o,
    output logic [DATA_WIDTH-1:0]   ImmExt_o,
    output logic [DATA_WIDTH-1:0]   PCPlus4_o

);

    always_ff @ (negedge clk) begin

        if (flush == 1) begin
            RegWrite_o      <= 0;
            ResultSrc_o     <= 0;
            MemWrite_o      <= 0;
            Jump_o          <= 0;
            Branch_o        <= 0;
            ALUControl_o    <= 0;
            ALUSrc_o        <= 0;
            UpperOp_o       <= 0;
            MemoryOp_o      <= 0;
            RD1_o           <= 0;
            RD2_o           <= 0;
            PC_o            <= 0;
            Rs1_o           <= 0;
            Rs2_o           <= 0;
            Rd_o            <= 0;
            ImmExt_o        <= 0;
            PCPlus4_o       <= 0;
        end
        
        else if (flush == 0) begin
            RegWrite_o      <= RegWrite_i;
            ResultSrc_o     <= ResultSrc_i;
            MemWrite_o      <= MemWrite_i;
            Jump_o          <= Jump_i;
            Branch_o        <= Branch_i;
            ALUControl_o    <= ALUControl_i;
            ALUSrc_o        <= ALUSrc_i;
            UpperOp_o       <= UpperOp_i;
            MemoryOp_o      <= MemoryOp_i;
            RD1_o           <= RD1_i;
            RD2_o           <= RD2_i;
            PC_o            <= PC_i;
            Rs1_o           <= Rs1_i;
            Rs2_o           <= Rs2_i;
            Rd_o            <= Rd_i;
            ImmExt_o        <= ImmExt_i;
            PCPlus4_o       <= PCPlus4_i;        
        end
    end

endmodule
