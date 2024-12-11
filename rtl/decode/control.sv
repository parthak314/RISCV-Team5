module control #(
) (
    input   logic   [6:0]   opA, 
    input   logic   [2:0]   funct3A,
    input   logic           funct7A,
    input   logic   [6:0]   opB, 
    input   logic   [2:0]   funct3B,
    input   logic           funct7B,
    // input   logic           zero, 
    // input   logic           negative, 
    input   logic           trigger,
    output  logic           IncrSrc, 
    output  logic           PCSrc, 
    output  logic   [1:0]   ResultSrc, 
    output  logic   [1:0]   MemWrite, 
    output  logic   [7:0]   ALUControl,
    output  logic   [1:0]   ALUSrc, 
    output  logic   [5:0]   ImmSrc, 
    output  logic   [1:0]   RegWrite
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
            IncrSrc = 1'b1; 
            PCSrc = 1'b1;
            ResultSrc = 2'b00;
            MemWrite = 2'b0;
            ALUControl = 8'b0;
            ALUSrc = 2'b0;
            ImmSrc = 6'b0;
            RegWrite = 2'b0;
        end else begin
            IncrSrc = 1'b1; 
            PCSrc = 1'b1;
            ResultSrc = 2'b00;
            MemWrite = 2'b0;
            ALUControl = 8'b0;
            ALUSrc = 2'b0;
            ImmSrc = 6'b0;
            RegWrite = 2'b0;

            case (opA)
                // R-type
                7'b0110011: begin 
                    // General
                    IncrSrc = 1'b1; 
                    PCSrc = 1'b1;

                    // A
                    get_ALU_control(opA, funct3A, funct7A, ALUControl[7:4]);
                    RegWrite[1] = 1'b1;
                end

                // I-type (ALU instructions)
                7'b0010011: begin 
                    // General
                    IncrSrc = 1'b1; 
                    PCSrc = 1'b1;

                    // A
                    get_ALU_control(opA, funct3A, funct7A, ALUControl[7:4]);
                    ALUSrc[1] = 1'b1;
                    ImmSrc[5:3] = 3'b0;
                    RegWrite[1] = 1'b1;
                end

                default: begin
                    // Set initially
                end
            endcase

            case (opB)
                // R-type
                7'b0110011: begin 
                    // General
                    IncrSrc = 1'b1; 
                    PCSrc = 1'b1;

                    // B
                    get_ALU_control(opB, funct3B, funct7B, ALUControl[3:0]);
                    RegWrite[0] = 1'b1;
                end

                // I-type (ALU instructions)
                7'b0010011: begin 
                    // General
                    IncrSrc = 1'b1; 
                    PCSrc = 1'b1;

                    // B
                    get_ALU_control(opB, funct3B, funct7B, ALUControl[3:0]);
                    ALUSrc[0] = 1'b1;
                    ImmSrc[2:0] = 3'b0;
                    RegWrite[0] = 1'b1;

                end

                default: begin
                    // Set initially
                end
            endcase
        end
    end

endmodule
