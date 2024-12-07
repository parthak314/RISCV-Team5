typedef enum logic [2:0] {
    IMM     = 3'b000,
    STORE   = 3'b001,
    BRANCH  = 3'b010,
    UPPER   = 3'b011,
    JUMP    = 3'b100
} sign_extention_type;

module sign_ext #(
    parameter DATA_WIDTH = 32
) (
    input logic [31:7] raw_instruction,
    input sign_extention_type ImmSrc,
    output logic [DATA_WIDTH-1:0] ImmExt
);

    always_comb begin
        case (ImmSrc)
            IMM: begin 
                ImmExt[11:0]    = {raw_instruction[31:20]};
                ImmExt[31:12]   = {20{raw_instruction[31]}};
            end

            STORE: begin 
                ImmExt[11:5]    = {raw_instruction[31:25]};
                ImmExt[4:0]     = {raw_instruction[11:7]};
                ImmExt[31:12]   = {20{raw_instruction[31]}};
            end

            BRANCH: begin
                ImmExt[12]      = {raw_instruction[31]};
                ImmExt[11]      = {raw_instruction[7]};
                ImmExt[10:5]    = {raw_instruction[30:25]};
                ImmExt[4:1]     = {raw_instruction[11:8]};
                ImmExt[0]       = {1'b0};                          // appending 0 to LSB, effectively right shifting << 1
                ImmExt[31:13]   = {19{raw_instruction[31]}};
            end

            UPPER: begin 
                ImmExt[31:12]   = {raw_instruction[31:12]};
                ImmExt[11:0]    = {12'b0};
            end

            JUMP: begin 
                ImmExt[20]      = {raw_instruction[31]};
                ImmExt[19:12]   = {raw_instruction[19:12]};
                ImmExt[11]      = {raw_instruction[20]};
                ImmExt[10:1]    = {raw_instruction[30:21]};
                ImmExt[0]       = {1'b0};                          // appending 0 to LSB, effectively right shifting << 1
                ImmExt[31:21]   = {11{raw_instruction[31]}};
            end

            default: ImmExt = {32'b0};
        endcase
    end

endmodule
