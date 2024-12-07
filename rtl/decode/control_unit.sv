module control_unit (
    input logic [6:0]   op,
    input logic [2:0]   func3,
    input logic         func7,          // bit 30 of ins

    output logic        RegWriteD,      // enable reg write
    output logic [1:0]  ResultSrcD,     // choose reg value written back (final mux at the end)
    output logic        MemWriteD,      // enable memory write
    output logic [1:0]  JumpD,          // enable jump
    output logic [2:0]  BranchD,        // make 3 bit
    output logic [3:0]  ALUControlD,    // ALU control, expanded to 4 bits
    output logic        ALUSrcD,        // ALU reg or imm source
    output logic [1:0]  UpperOpD,
    output logic [2:0]  MemoryOpD,      // control how to parse word depending on load operation
    output logic [2:0]  ImmSrcD         // which imm to use when extending, as RISBU ins have different immediates
);

    always_comb begin
        case(op)
            7'b0110011: begin   // Register-Type ins
                RegWriteD   = 1;
                ResultSrcD  = 2'b00;
                MemWriteD   = 0;
                JumpD       = 2'b00;
                BranchD     = 3'b000;
                ALUSrcD     = 0;
                UpperOpD    = 2'b00;
                MemoryOpD   = 3'b000;
                ImmSrcD     = 3'b000;
                // writing to desintation reg, select alu result as writeback val, no mem write, no jump/branch, select reg for alusrc, not using imm
                case (func3)
                    3'd0: begin
                        if (func7 == 0) ALUControlD = 4'b0000; // add
                        if (func7 == 1) ALUControlD = 4'b0001; // sub
                    end
                    3'd4:               ALUControlD = 4'b0100; // xor
                    3'd6:               ALUControlD = 4'b0011; // or
                    3'd7:               ALUControlD = 4'b0010; // and
                    3'd1:               ALUControlD = 4'b0101; // sll
                    3'd5: begin
                        if (func7 == 0) ALUControlD = 4'b0110; // srl
                        if (func7 == 1) ALUControlD = 4'b0111; // sra
                    end                    
                    3'd2:               ALUControlD = 4'b1000; // slt
                    3'd3:               ALUControlD = 4'b1001; // sltu

                    default:            ALUControlD = 4'b0000;
                endcase
            end

            7'b0010011: begin // I-Type arithmetic ins
                RegWriteD   = 1;
                ResultSrcD  = 2'b00;
                MemWriteD   = 0;
                JumpD       = 2'b00;
                BranchD     = 3'b000;
                ALUSrcD     = 1;
                UpperOpD    = 2'b00;
                MemoryOpD   = 3'b000;
                ImmSrcD     = 3'b000;
                // same as R-type instructions but ALUSrcD = 1 and ImmSrcD = 3'b000 (relevant here)
                case (func3)
                    3'd0:               ALUControlD = 4'b0000; // add imm
                    
                    3'd4:               ALUControlD = 4'b0100; // xor imm
                    3'd6:               ALUControlD = 4'b0011; // or imm
                    3'd7:               ALUControlD = 4'b0010; // and imm
                    3'd1:               ALUControlD = 4'b0101; // sll imm
                    3'd5: begin
                        if (func7 == 0) ALUControlD = 4'b0110; // srl imm
                        if (func7 == 1) ALUControlD = 4'b0111; // sra imm
                    end
                    3'd2:               ALUControlD = 4'b1000; // slt imm
                    3'd3:               ALUControlD = 4'b1001; // sltu imm

                    default:            ALUControlD = 4'b0000;
                endcase

            end

            7'b0000011: begin // I-type load ins
                RegWriteD   = 1;
                ResultSrcD  = 2'b01;
                MemWriteD   = 0;
                JumpD       = 2'b00;
                BranchD     = 3'b000;
                ALUControlD = 4'b0000;      // addition to calculate rs1 + imm offset
                ALUSrcD     = 1;
                UpperOpD    = 2'b00;
                ImmSrcD     = 3'b000;

                case(func3)
                    3'd0: MemoryOpD = 3'b000; // load byte
                    3'd1: MemoryOpD = 3'b001; // load half
                    3'd2: MemoryOpD = 3'b010; // load word
                    3'd4: MemoryOpD = 3'b011; // load byte (unsigned)
                    3'd5: MemoryOpD = 3'b100; // load half (unsigned)

                    default: MemoryOpD = 3'b000;
                endcase
            end

            7'b0100011: begin // S-Type ins
                RegWriteD   = 0;
                ResultSrcD  = 2'b00;
                MemWriteD   = 1;
                JumpD       = 2'b00;
                BranchD     = 3'b000;
                ALUControlD = 4'b0000;      // addition to calculate rs1 + imm offset
                ALUSrcD     = 1;
                UpperOpD    = 2'b00;
                ImmSrcD     = 3'b001;       // S-Type immediate

                case(func3)
                    3'd0: MemoryOpD = 3'b000; // store byte
                    3'd1: MemoryOpD = 3'b001; // store half
                    3'd2: MemoryOpD = 3'b010; // store word

                    default: MemoryOpD = 3'b000;
                endcase
            end

            7'b1100011: begin // B-Type ins
                RegWriteD   = 0; // no reg write-back for branching
                ResultSrcD  = 2'b00; // don't care as no write-back
                MemWriteD   = 0;
                JumpD       = 2'b00;
                ALUControlD = 4'b0001; // always subtraction for comparison
                ALUSrcD     = 0; // ALU src B always another register
                UpperOpD    = 2'b00;
                MemoryOpD   = 3'b000;
                ImmSrcD     = 3'b010; // sign extent imm using branch setting

                case(func3)
                    3'd0: BranchD = 3'b001; // beq
                    3'd1: BranchD = 3'b010; // bne
                    3'd4: BranchD = 3'b011; // blt
                    3'd5: BranchD = 3'b100; // bge
                    3'd6: BranchD = 3'b101; // bltu
                    3'd7: BranchD = 3'b110; // bgeu

                    default: BranchD = 3'b000;
                endcase
            end

            7'b1101111: begin // JAL
                RegWriteD   = 1;
                ResultSrcD  = 2'b10;
                MemWriteD   = 0;
                JumpD       = 2'b01;
                BranchD     = 3'b000;   // irrelevant if JumpD enabled
                ALUControlD = 4'b0000;  // irrelevant
                ALUSrcD     = 0;        // irrelevant
                UpperOpD    = 2'b00;
                MemoryOpD   = 3'b000;   // irrelevant
                ImmSrcD     = 3'b000;
            end

            7'b1100111: begin // JALR
                RegWriteD   = 1;
                ResultSrcD  = 2'b10;
                MemWriteD   = 0;
                JumpD       = 2'b10;
                BranchD     = 3'b000;   // irrelevant if JumpD enabled
                ALUControlD = 4'b0000;  // irrelevant
                ALUSrcD     = 0;        // irrelevant
                UpperOpD    = 2'b00;
                MemoryOpD   = 3'b000;   // irrelevant
                ImmSrcD     = 3'b000;
            end

            7'b0110111: begin // LUI
                RegWriteD   = 1;
                ResultSrcD  = 2'b00; // writeback alu result of 0 + Imm << 12
                MemWriteD   = 0;
                JumpD       = 2'b00;
                BranchD     = 3'b000;
                ALUControlD = 4'b0000; // addition
                ALUSrcD     = 1;
                UpperOpD    = 2'b01; // selects 0 as srcA into ALU
                MemoryOpD   = 3'b000;
                ImmSrcD     = 3'b011; // upper-type IMM
            end

            7'b0010111: begin // AUIPC
                RegWriteD   = 1;
                ResultSrcD  = 2'b00; // writeback alu result of PC + Imm << 12
                MemWriteD   = 0;
                JumpD       = 2'b00;
                BranchD     = 3'b000;
                ALUControlD = 4'b0000; // addition
                ALUSrcD     = 1;
                UpperOpD    = 2'b10; // selects PC as srcA into ALU
                MemoryOpD   = 3'b000;
                ImmSrcD     = 3'b011; // upper-type IMM
            end

            default: begin
                RegWriteD   = 0;
                ResultSrcD  = 0;
                MemWriteD   = 0;
                JumpD       = 0;
                BranchD     = 0;
                ALUControlD = 0;
                ALUSrcD     = 0;
                UpperOpD    = 0;
                MemoryOpD   = 0;
                ImmSrcD     = 0;
            end
        endcase
    end

endmodule
