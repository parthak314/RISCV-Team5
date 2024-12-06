typedef enum logic [2:0] {
    NONE    = 3'b000,
    BEQ     = 3'b001,
    BNE     = 3'b010,
                        // 3'b011 unused
    BLT     = 3'b100,
    BGE     = 3'b101,
    BLTU    = 3'b110,
    BGEU    = 3'b111
} branch_operation;

module branch_logic (
    input branch_operation branch,
    input logic jump,
    input logic zero,
    input logic negative,

    output logic PCSrc
);

    always_comb begin
        case(branch)
            NONE:   PCSrc = 0;
            BEQ:    PCSrc = zero;
            BNE:    PCSrc = ~zero;
            BLT:    PCSrc = negative;
            BGE:    PCSrc = ~negative;
    
            default: PCSrc = 0;
        endcase

        PCSrc = PCSrc | jump;
    end

endmodule
