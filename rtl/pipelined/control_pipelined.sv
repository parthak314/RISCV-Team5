module control_pipelined #(
) (
    input   logic   [6:0]   op,
    input   logic   [2:0]   funct3, 
    input   logic           funct7, 
    input   logic           trigger,

    output  logic   [1:0]   ResultSrc,
    output  logic           MemWrite,
    output  logic   [3:0]   ALUControl,
    output  logic           ALUSrc,
    output  logic   [2:0]   ImmSrc,
    output  logic           RegWrite
    output  logic   [1:0]   Jump,
    output  logic   [2:0]   Branch
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
                      else                       ALU_control = funct_7 ? 4'b0001 : 4'b0000; // add | addi (funct7 = 0) or sub (funct7 = 1)
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
            RegWrite = 1'b0; ImmSrc = 3'b000; MemWrite = 1'b0; ResultSrc = 2'b00; Branch = 3'b000; Jump = 2'b11; ALUSrc = 1'b0; ALUControl = 4'b0000;
        end else begin

            RegWrite = 1'b0; ImmSrc = 3'b000; MemWrite = 1'b0; ResultSrc = 2'b00; Branch = 3'b000; Jump = 2'b00; ALUSrc = 1'b0; ALUControl = 4'b0000;
            
            case (op)
                // R-type
                7'b0110011: begin 
                    RegWrite = 1'b1; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'b00; Branch = 3'b000; Jump = 2'b00;
                    get_ALU_control(op, funct3, funct7, ALUControl);
                end

                // I-type (ALU instructions)
                7'b0010011: begin 
                    RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ResultSrc = 2'b00; ALUSrc = 1'b1; Branch = 3'b000; Jump = 2'b00; 
                    get_ALU_control(op, funct3, funct7, ALUControl);
                end

                // I-type (loading)
                7'b0000011: begin
                    RegWrite = 1'b1; ImmSrc = 3'b000; MemWrite = 1'b0; ALUSrc = 1'b1; ALUControl = 4'b0000; ResultSrc = 2'b01; Branch = 3'b000; Jump = 2'b00;
                end

                // I-type (jalr)
                7'b1100111: begin
                    RegWrite = 1'b1; MemWrite = 1'b0; ImmSrc = 3'b000; ResultSrc = 2'b00; Branch = 3'b000; Jump = 2'b10; ALUControl = 4'b0000; ALUSrc = 1;
                end

                // S-type
                7'b0100011: begin 
                    RegWrite = 1'b0; ImmSrc = 3'b001; ALUSrc = 1'b1; ALUControl = 4'b0000; MemWrite = 1'b1; Branch = 3'b000; Jump = 2'b00;
                end

                // B-type
                7'b1100011: begin 
                    RegWrite = 1'b0; ImmSrc = 3'b010; ALUSrc = 1'b0; ALUControl = 4'b0001; MemWrite = 1'b0; Jump = 2'b00;
                    case (funct3)
                        3'b000: Branch = 3'b001       // beq 
                        3'b001: Branch = 3'b010       // bne 
                        3'b100: Branch = 3'b100       // blt 
                        3'b101: Branch = 3'b101       // bge 
                        3'b110: Branch = 3'b110       // bltu
                        3'b111: Branch = 3'b111       // bgeu
                        default: Branch = 3'b000 // Default case
                    endcase
                end

                // U-type (lui)
                7'b0110111: begin 
                    RegWrite = 1'b1; ImmSrc = 3'b011; MemWrite = 1'b0; ResultSrc = 2'b11; Branch = 3'b000; Jump = 2'b00;
                end

                // J-type (jal)
                7'b1101111: begin 
                    RegWrite = 1'b1; ImmSrc = 3'b100; MemWrite = 1'b0; ResultSrc = 2'b10; Branch = 3'b000; Jump = 2'b01;
                end

                default: begin
                    // Set initially
                end
            endcase
        end
    end

endmodule
