module control #(
) (
    input   logic   [6:0]   op, // opcode to define instruction type, last 7 bits of instr
    input   logic   [2:0]   funct3, // instruction defined under instr type
    input   logic           funct7, // 2nd MSB of instr
    input   logic           zero, // flag for when 2 entities are equal
    input   logic           negative, // flag for when a value is negative
    input   logic           trigger, // external trigger input (trigger HIGH = stall)
    output  logic   [1:0]   PCSrc, // pc mux sel line: 0 = pc + 4, 1 = branch (pc + imm), 2 = jump (from aluresult), 3 = pc (stall)
    output  logic   [1:0]   ResultSrc, // data to store in register file, ALU result/data memory
    output  logic           MemWrite, // write enable to data mem
    output  logic   [3:0]   ALUControl, // controls the operation to perform in the ALU
    output  logic           ALUSrc, // immediate vs register operand for ALU
    output  logic   [2:0]   ImmSrc, // Type of sign extend performed based on instr type
    output  logic           RegWrite, // enable for when to write to a register
    output  logic           AddrMode // byte addressing or word addressing (0: byte, word: 1)
);

    task get_ALU_control(
        input   logic [6:0] op_code,
        input   logic [2:0] funct_3,
        input   logic       funct_7,
        output  logic [3:0] ALU_control
    );
        begin
            case (funct_3)
                3'd0: if (op_code == 7'b0010011) ALU_control = 4'b0000;
                      else                 ALU_control = funct_7 ? 4'b0001 : 4'b0000; // add | addi (funct7 = 0) or sub (funct7 = 1)
                3'd1: ALU_control = 4'b0101; // sll | slli
                3'd2: ALU_control = 4'b1000; // slt | slti
                3'd3: ALU_control = 4'b1001; // sltu | sltiu
                3'd4: ALU_control = 4'b0100; // xor | xori
                3'd5: ALU_control = funct_7 ? 4'b0110 : 4'b0111; // srl | slri (funct7 = 0) or sra | srai (funct7 = 1)
                3'd6: ALU_control = 4'b0011; // or | ori
                3'd7: ALU_control = 4'b0010; // and | andi
                default: ALU_control = 4'b0000; // undefined
            endcase
        end
    endtask

    always_comb begin
        // if trigger, stall by setting all writes to 0
        // then set PCSrc 2'b11 so that PCNext = PC
        if (trigger) begin
            RegWrite = 1'b0; // Put here to prevent a latch error
            ImmSrc = 3'b000;
            MemWrite = 1'b0;
            ResultSrc = 2'b00;
            PCSrc = 2'b11; // 
            ALUSrc = 1'b0;
            ALUControl = 4'b0000;

        end else begin
            RegWrite = 1'b0; // Put here to prevent a latch error
            ImmSrc = 3'b000;
            MemWrite = 1'b0;
            ResultSrc = 2'b00;
            PCSrc = 2'b0;
            ALUSrc = 1'b0;
            ALUControl = 4'b0000;
            AddrMode = 1'b0;

            case (op)
                // R-type
                7'b0110011: begin 
                    RegWrite = 1'b1; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'b00; PCSrc = 2'b0;
                    get_ALU_control(op, funct3, funct7, ALUControl);
                end

                // I-type (ALU instructions)
                7'b0010011: begin 
                    RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ResultSrc = 2'b00; ALUSrc = 1'b1; PCSrc = 2'b0; 
                    get_ALU_control(op, funct3, funct7, ALUControl);
                end

                // I-type (loading)
                7'b0000011: begin
                    RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b1; ALUControl = 4'b0000; ResultSrc = 2'b01; PCSrc = 2'b0;
                    case (funct3)
                        3'b010: AddrMode = 1'b0;     // LW
                        3'b100: AddrMode = 1'b1;     // LBU
                        default: AddrMode = 1'b0;
                    endcase
                end

                // I-type (jalr)
                7'b1100111: begin
                    RegWrite = 1'b1; MemWrite = 1'b0; ImmSrc = 3'b000; ResultSrc = 2'b00; PCSrc = 2'b10; ALUControl = 4'b0000; ALUSrc = 1;
                end

                // S-type
                7'b0100011: begin 
                    RegWrite = 1'b0; ImmSrc = 3'b001; ALUSrc = 1'b1; ALUControl = 4'b0000; MemWrite = 1'b1; PCSrc = 2'b0;
                    case (funct3)
                        3'b000: AddrMode = 1'b1;    // SB
                        3'b010: AddrMode = 1'b0;    // SW
                        default: AddrMode = 1'b0;
                    endcase
                end

                // B-type
                7'b1100011: begin 
                    RegWrite = 1'b0; ImmSrc = 3'b010; ALUSrc = 1'b0; ALUControl = 4'b0001; MemWrite = 1'b0;
                    case (funct3)
                        3'b000: PCSrc = zero ? 2'b01 : 2'b0;       // beq
                        3'b001: PCSrc = ~zero ? 2'b01 : 2'b0;      // bne
                        3'b100: PCSrc = negative ? 2'b01 : 2'b0;   // blt 
                        3'b101: PCSrc = ~negative ? 2'b01 : 2'b0;  // bge
                        3'b110: PCSrc = negative ? 2'b01 : 2'b0;   // bltu
                        3'b111: PCSrc = ~negative ? 2'b01 : 2'b0;  // bgeu
                        default: PCSrc = 2'b0; // Default case
                    endcase
                end

                // U-type (lui)
                7'b0110111: begin 
                    RegWrite = 1'b1; ImmSrc = 3'b011; MemWrite = 1'b0; ResultSrc = 2'b11; PCSrc = 2'b0;
                end

                // J-type (jal)
                7'b1101111: begin 
                    RegWrite = 1'b1; ImmSrc = 3'b100; MemWrite = 1'b0; ResultSrc = 2'b10; PCSrc = 2'b01;
                end

                default: begin
                    // Set initially
                end
            endcase
        end
    end

endmodule
