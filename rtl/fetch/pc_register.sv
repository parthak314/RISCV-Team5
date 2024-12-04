module pc_register # (
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic [DATA_WIDTH-1:0] PCin,
    output logic [DATA_WIDTH-1:0] PCout
);

    always_ff @ (posedge clk) begin
        PCout <= PCin;
    end

endmodule
