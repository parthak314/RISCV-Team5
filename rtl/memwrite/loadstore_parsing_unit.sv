typedef enum logic [2:0] {
    BYTE            = 3'b000,
    HALF            = 3'b001,
    WORD            = 3'b010,
    BYTE_UNSIGNED   = 3'b011,
    HALF_UNSIGNED   = 3'b100
} memory_operation;

module loadstore_parsing_unit #(
    parameter DATA_WIDTH = 32
) (
    input logic [2:0] MemoryOp,
    input logic [DATA_WIDTH-1:0] RAM_Out,
    input logic [DATA_WIDTH-1:0] WriteData,

    output logic [DATA_WIDTH-1:0] RAM_In,
    output logic [DATA_WIDTH-1:0] ReadData
);

    // LOAD logic, drives ReadData
    always_comb begin
        case(MemoryOp)
            BYTE:           ReadData    = {{24{RAM_Out[7]}}, RAM_Out[7:0]};     // byte is sign extended
            HALF:           ReadData    = {{16{RAM_Out[15]}}, RAM_Out[15:0]};   // half-word is sign extended
            WORD:           ReadData    = RAM_Out[31:0];
            BYTE_UNSIGNED:  ReadData    = {{24'b0}, RAM_Out[7:0]};              // unsigned so zero extended
            HALF_UNSIGNED:  ReadData    = {{16'b0}, RAM_Out[15:0]};             // unsigned
            
            default: ReadData = RAM_Out;
        endcase
    end

    // STORE logic, drives RAM_In
    always_comb begin
        case(MemoryOp)
            BYTE:  RAM_In    = {RAM_Out[31:8], WriteData[7:0]};      // if storing byte, keep bits 13:8 unchanged
            HALF:  RAM_In    = {RAM_Out[31:16], WriteData[15:0]};    // if storing half, keep bits 31:16 unchanged
            WORD:  RAM_In    = WriteData[31:0];
            
            default: RAM_In = RAM_Out;
        endcase
    end

endmodule
