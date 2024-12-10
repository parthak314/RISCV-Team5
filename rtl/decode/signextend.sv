/* verilator lint_off UNUSED */
module signextend #(
    parameter   DATA_WIDTH = 32
)(
    input   logic [DATA_WIDTH-1:0]  instrA,
    input   logic [DATA_WIDTH-1:0]  instrB,
    input   logic [5:0]             ImmSrc,    
    output  logic [DATA_WIDTH-1:0]  ImmOpA,
    output  logic [DATA_WIDTH-1:0]  ImmOpB
);

    always_comb begin
        case (ImmSrc[5:3])
            3'b000:    ImmOpA = {{20{instrA[31]}}, instrA[31:20]}; // I-type
            // 3'b001:    ImmOp = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
            // 3'b010:    ImmOp = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            // 3'b011:    ImmOp = {instr[31:12], 12'b0}; // U-type
            // 3'b100:    ImmOp = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type
            default:   ImmOpA = instrA;
        endcase
        case (ImmSrc[2:0])
            3'b000:    ImmOpB = {{20{instrB[31]}}, instrB[31:20]}; // I-type
            default:   ImmOpB = instrB;
        endcase
    end

endmodule
