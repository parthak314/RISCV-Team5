/* verilator lint_off UNUSED */
module signextend #(
    parameter   DATA_WIDTH = 32
)(
    input   logic [DATA_WIDTH-1:0]  instr,
    input   logic [2:0]             ImmSrc,    
    output  logic [DATA_WIDTH-1:0]  ImmOp
);

    always_comb begin
            case (ImmSrc)
                3'b000:    ImmOp = {{20{instr[31]}}, instr[31:20]}; // I-type
                3'b001:    ImmOp = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
                3'b010:    ImmOp = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
                3'b011:    ImmOp = {instr[31:12], 12'b0}; // U-type
                3'b100:    ImmOp = {{12{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21]}; // J-type
                default:    ImmOp = {{20{instr[31]}}, instr[31:20]};
            endcase
    end

endmodule
