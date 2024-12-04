module pc_register # (
    parameter DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic [DATA_WIDTH-1:0] PCin,
    output logic [DATA_WIDTH-1:0] PCout
);

    reg [DATA_WIDTH-1:0] PC;

    always_ff @ (posedge clk) begin
        if (rst) PC <= {DATA_WIDTH{1'b0}};
        else PC <= PCin;
    end

    assign out_PC = PC;

endmodule
