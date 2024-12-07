typedef enum logic [2:0] {
    NONE    = 3'b000,
    BEQ     = 3'b001,
    BNE     = 3'b010,
    BLT     = 3'b011,
    BGE     = 3'b100,
    BLTU    = 3'b101,
    BGEU    = 3'b110
} branch_operation;

module branch_logic (
    input branch_operation  Branch,
    input logic [1:0]       Jump,
    input logic             Zero,
    input logic             Negative,

    output logic            PCSrc
);

    always_comb begin
        case(Branch)
            NONE:   PCSrc = 0;
            BEQ:    PCSrc = Zero;
            BNE:    PCSrc = ~Zero;
            BLT:    PCSrc = Negative;
            BGE:    PCSrc = ~Negative;
    
            default: PCSrc = 0;
        endcase

        PCSrc = PCSrc | (Jump != 2'b00);
    end

endmodule
