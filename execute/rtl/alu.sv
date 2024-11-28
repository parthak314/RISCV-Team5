typedef enum logic [2:0] {
    ADD = 3'b000,
    SUB = 3'b001,
    AND = 3'b010,
    OR  = 3'b011,
    XOR = 3'b100
    // SLL = // shift left logical
    // SRL = // shift right logical
    // SRA = // shift right arithmetic (msb extended)
    // SLT = // set less than
    // SLTU = // set less than unsigned (zero extended)
} control_operation;

module alu #(
    parameter   DATA_WIDTH = 32
) (
    input   control_operation           ALUControl,
    input   logic [DATA_WIDTH-1:0]      SrcA,
    input   logic [DATA_WIDTH-1:0]      SrcB,
    output  logic [DATA_WIDTH-1:0]      ALUResult,
    output  logic                       ZeroFlag,
    output  logic                       NegativeFlag
);

    always_comb begin
        case (ALUControl)
            ADD:    ALUResult = SrcA + SrcB;
            SUB:    ALUResult = SrcA - SrcB;
            AND:    ALUResult = SrcA & SrcB;
            OR:     ALUResult = SrcA | SrcB;
            XOR:    ALUResult = SrcA ^ SrcB;

            default: ALUResult = 0;
        endcase

        assign ZeroFlag = (ALUResult == 0);
        assign NegativeFlag = (ALUResult[DATA_WIDTH-1] == 1); // negative if MSB = 1
    end

endmodule
