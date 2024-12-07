module data_ram #(
    parameter ADDRESS_WIDTH = 32,
              WORD_WIDTH = 32,
              RAM_DATA_WIDTH = 8
)(
    input logic                     clk,
    input logic [ADDRESS_WIDTH-1:0] A,
    input logic [WORD_WIDTH-1:0]    WD,
    input logic                     WE,

    output logic [WORD_WIDTH-1:0]   RD
);

    logic [RAM_DATA_WIDTH-1:0] ram_array [32'h0001FFFF:0]; // data memory from 0x0001FFFF to 0x00000000 as in memory map: 52.4kB

    always_ff @ (posedge clk) begin
        if (WE) begin
            ram_array[A+3] <= WD[31:24];
            ram_array[A+2] <= WD[23:16];
            ram_array[A+1] <= WD[15:8];
            ram_array[A+0] <= WD[7:0];
        end
    end

    always_comb begin
        RD = {ram_array[A+3], ram_array[A+2], ram_array[A+1], ram_array[A+0]}; // assemble 32-bit word from 4 bytes
    end

endmodule
