module control #(
) (
    input   logic   [6:0]   op, // opcode to define instruction type, last 7 bits of instr
    input   logic   [2:0]   funct3, // instruction defined under instr type
    input   logic           funct7, // 2nd MSB of instr
    input   logic           zero, // flag for when 2 entities are equal
    input   logic           negative, // flag for when a value is negative
    output  logic           PCsrc, // imm vs pc + 4 for program counter increment
    output  logic   [1:0]   ResultSrc, // data to store in register file, ALU result/data memory
    output  logic           MemWrite, // write enable to data mem
    output  logic   [3:0]   ALUcontrol, // controls the operation to perform in the ALU
    output  logic           ALUSrc, // immediate vs register operand for ALU
    output  logic   [2:0]   ImmSrc, // Type of sign extend performed based on instr type
    output  logic           RegWrite // enable for when to write to a register
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
        RegWrite = 1'b0; // Put here to prevent a latch error
        ImmSrc = 3'b000;
        MemWrite = 1'b0;
        ResultSrc = 2'b00;
        PCsrc = 1'b0;
        ALUSrc = 1'b0;
        ALUcontrol = 4'b0000;

        case (op)
            // R-type
            7'b0110011: begin 
                RegWrite = 1'b1; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'b00; PCsrc = 1'b0;
                get_ALU_control(op, funct3, funct7, ALUcontrol);
            end

            // I-type (ALU instructions)
            7'b0010011: begin 
                RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ResultSrc = 2'b00; ALUSrc = 1'b1; PCsrc = 1'b0; 
                get_ALU_control(op, funct3, funct7, ALUcontrol);
            end

            // I-type (loading)
            7'b0000011: begin
                RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b1; ALUcontrol = 4'b0000; ResultSrc = 2'b01; PCsrc = 1'b0;
            end

            // I-type (jalr)
            7'b1100111: begin
                RegWrite = 1'b1; MemWrite = 1'b0; ImmSrc = 3'b000; ResultSrc = 2'b10; PCsrc = 1'b1; ALUcontrol = 4'b0000; ALUSrc = 1;
            end

            // S-type
            7'b0100011: begin 
                RegWrite = 1'b0; ImmSrc = 3'b001; ALUSrc = 1'b1; ALUcontrol = 4'b0000; MemWrite = 1'b1; PCsrc = 1'b0;
            end

            // B-type
            7'b1100011: begin 
                RegWrite = 1'b0; ImmSrc = 3'b010; ALUSrc = 1'b0; ALUcontrol = 4'b0001; MemWrite = 1'b0;
                case (funct3)
                    3'b000: PCsrc = zero; // beq
                    3'b001: PCsrc = ~zero; // bne
                    3'b100: PCsrc = negative; // blt 
                    3'b101: PCsrc = ~negative; // bge
                    3'b110: PCsrc = negative; // bltu
                    3'b111: PCsrc = ~negative; // bgeu
                    default: PCsrc = 1'b0; // Default case
                endcase
            end

             // J-type (jal)
            7'b1101111: begin 
                RegWrite = 1'b1; ImmSrc = 3'b011; MemWrite = 1'b0; ResultSrc = 2'b10; PCsrc = 1'b1;
            end

            // U-type (lui)
            7'b0110111: begin 
                RegWrite = 1'b1; ImmSrc = 3'b100; MemWrite = 1'b0; ResultSrc = 2'b11; PCsrc = 1'b0;
            end

            // U-type (auipc)
            7'b0010111: begin 
                RegWrite = 1'b1; ImmSrc = 3'b100; MemWrite = 1'b0; ResultSrc = 2'b00; PCsrc = 1'b0; ALUSrc = 1'b1; ALUcontrol = 4'b0000;
            end

            default: begin
                // Set initially
            end
        endcase
    end

endmodule
