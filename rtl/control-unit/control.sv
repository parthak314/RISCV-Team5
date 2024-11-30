module control #(
) (
    input   logic   [6:0]   op, // opcode to define instruction type, last 7 bits of instr
    input   logic   [2:0]   func3, // instruction defined under instr type
    input   logic           funct7, // 2nd MSB of instr
    input   logic           zero, // to check if branch is equal
    output  logic           PCsrc, 
    output  logic           ResultSrc,
    output  logic           MemWrite,
    output  logic   [2:0]   ALUctrl,
    output  logic           ALUSrc,
    output  logic   [1:0]   ImmSrc,
    output  logic           RegWrite
);
    logic   branch;
    logic   ALUOp;

    always_comb begin
        case (op)
            7'b0110011: begin end // R-type
            7'b0010011: begin RegWrite = 1'b1; ImmSrc = 1'b1; ALUsrc = 1'b1; branch = 1'b0; ALUctrl = 3'b000; end // I-type
            7'b0100011: begin end // S-type
            7'b1100011: begin RegWrite = 1'b0; ImmSrc = 1'b1; ALUsrc = 1'b0; branch = 1'b1; ALUctrl = 3'b001; end // B-type
            7'b1101111: begin end // J-type
            7'b0110111: begin end // U-type (lui)
            7'b0010111: begin end // U-type (auipc)
            default: begin RegWrite = 1'b1; ImmSrc = 1'b0; ALUsrc = 1'b1; branch = 1'b0; ALUctrl = 3'b000; end
        endcase
    PCsrc = branch && zero;
    end

endmodule