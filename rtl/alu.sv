typedef enum logic [3:0] {
    ADD = 4'b0000,
    SUB = 4'b0001,
    AND = 4'b0010,
    OR  = 4'b0011,
    XOR = 4'b0100,
    SLL = 4'b0101, // shift left logical
    SRL = 4'b0110, // shift right logical
    SRA = 4'b0111, // shift right arithmetic (msb extended)
    SLT = 4'b1000, // set less than
    SLTU = 4'b1001 // set less than unsigned (zero extended)
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
            SLL:    ALUResult = rs1 << rs2;
            SRL:    ALUResult = rs1 >> rs2;
            SRA:    ALUResult = rs1 >>> rs2;
            SLT:    ALUResult = (rs1 < rs2) ? 1'b1 : 1'b0;
            SLTU:   ALUResult = ($signed(rs1) < $signed(rs2)) ? 1'b1 : 1'b0;
            default: ALUResult = 0;
        endcase

        assign ZeroFlag = (ALUResult == 0);
        assign NegativeFlag = (ALUResult[DATA_WIDTH-1] == 1); // negative if MSB = 1
    end

endmodule
