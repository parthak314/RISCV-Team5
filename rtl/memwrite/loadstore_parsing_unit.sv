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
    input logic [2:0]               MemoryOp,
    input logic [1:0]               ByteOffset, // 0, 1, 2, 3 - if word assume 0, if half assume 0 or 2, byte can be 0, 1, 2, 3
    input logic [DATA_WIDTH-1:0]    MemReadOutData,
    input logic [DATA_WIDTH-1:0]    WriteData,          // desired write-in data before parse operation

    output logic [DATA_WIDTH-1:0]   MemWriteInData,     // actual write-in data after appropriate parsing
    output logic [DATA_WIDTH-1:0]   ReadData
);

    // LOAD logic, drives ReadData
    always_comb begin
        case(MemoryOp)
            WORD:           ReadData    = MemReadOutData[31:0];

            BYTE:           ReadData    = {{24'b0}, MemReadOutData[ByteOffset*8 +: 8]};     // sign extended below
            HALF:           ReadData    = {{16'b0}, MemReadOutData[ByteOffset*8 +: 16]};    // ^^^
            BYTE_UNSIGNED:  ReadData    = {{24'b0}, MemReadOutData[ByteOffset*8 +: 8]};     // unsigned so zero extended
            HALF_UNSIGNED:  ReadData    = {{16'b0}, MemReadOutData[ByteOffset*8 +: 16]};    // ^^^
            
            default: ReadData = MemReadOutData;
        endcase

        if (MemoryOp == BYTE) ReadData[31:8] = {24{ReadData[7]}};   // byte is sign extended for lb
        if (MemoryOp == HALF) ReadData[31:16] = {16{ReadData[15]}};  // half-word is sign extend for lh
    end

    // STORE logic, drives MemWriteInData
    always_comb begin
        case(MemoryOp)
            WORD:  MemWriteInData    = WriteData[31:0];

            BYTE: begin
                case (ByteOffset) // handle different offsets for SB
                    2'b00:      MemWriteInData = {MemReadOutData[31:8], WriteData[7:0]};
                    2'b01:      MemWriteInData = {MemReadOutData[31:16], WriteData[7:0], MemReadOutData[7:0]};
                    2'b10:      MemWriteInData = {MemReadOutData[31:24], WriteData[7:0], MemReadOutData[15:0]};
                    2'b11:      MemWriteInData = {WriteData[7:0], MemReadOutData[23:0]};
                    default: begin
                        MemWriteInData = {MemReadOutData[31:8], WriteData[7:0]};
                        $display("PARSE UNIT STORE BYTE: INVALID BYTE OFFSET PROVIDED");
                    end
                endcase
            end
        
            HALF: begin
                case (ByteOffset)
                    2'b00:      MemWriteInData = {MemReadOutData[31:16], WriteData[15:0]};
                    2'b10:      MemWriteInData = {WriteData[15:0], MemReadOutData[15:0]};
                    default: begin
                        MemWriteInData = {MemReadOutData[31:16], WriteData[15:0]};
                        $display("PARSE UNIT STORE HALF: INVALID BYTE OFFSET PROVIDED. MUST BE 0 OR 2");
                    end
                endcase
            end
            
            default: MemWriteInData = MemReadOutData;
        endcase
    end

endmodule
