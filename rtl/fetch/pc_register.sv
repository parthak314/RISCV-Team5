module pc_register # (
    parameter DATA_WIDTH = 32
) (
    input logic                     en,
    input logic                     clk,
    input logic                     clear,

    input logic [DATA_WIDTH-1:0]    PCin,
    output logic [DATA_WIDTH-1:0]   PCout
);

    always_ff @ (posedge clk) begin
        if (en & !clear)    PCout <= PCin;
        else if (clear)     PCout <= 0;
    end

endmodule
