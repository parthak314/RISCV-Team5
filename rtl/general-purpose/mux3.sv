module mux3 #(
    parameter DATA_WIDTH = 32
) (
    input   logic [DATA_WIDTH-1:0]  in0,
    input   logic [DATA_WIDTH-1:0]  in1,
    input   logic [DATA_WIDTH-1:0]  in2,
    input   logic [1:0]             sel,
    output  logic [DATA_WIDTH-1:0]  out
);

    always_comb begin
        case(sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;

            default: out = {32'b0};
        endcase
    end

endmodule
