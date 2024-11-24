module alu #(
    parameter   DATA_WIDTH = 32,
                CONTROL_WIDTH = 3
) (
    input   logic [CONTROL_WIDTH-1:0]   ALUControl,
    input   logic [DATA_WIDTH-1:0]      SrcA,
    input   logic [DATA_WIDTH-1:0]      SrcB,
    output  logic [DATA_WIDTH-1:0]      ALUResult,
    output  logic                       EQ
);

    enum logic [CONTROL_WIDTH-1:0] {
        ADD = 3'b000,
        SUB = 3'b001,
        AND = 3'b010,
        OR  = 3'b011,
        XOR = 3'b100,
        // SLL = // shift left logical
        // SRL = // shift right logical
        // SRA = // shift right arithmetic (msb extended)
        // SLT = // set less than
        // SLTU = // set less than unsigned (zero extended)
    } control_operation;

    always_comb begin
        case (control_operation(ALUControl))
            ADD:    ALUResult = SrcA + SrcB;
            SUB:    ALUResult = SrcA - SrcB;
            AND:    ALUResult = SrcA & SrcB;
            OR:     ALUResult = SrcA | SrcB;
            XOR:    ALUResult = SrcA ^ SrcB;

            default: ALUResult = 0;
        endcase
    end

endmodule
