module data_mem #(
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

    logic [RAM_DATA_WIDTH-1:0] mem_array [32'h0001FFFF:0]; // data memory from 0x0001FFFF to 0x00000000 as in memory map: 52.4kB

    initial begin
        $readmemh("data.hex", mem_array, 32'h00010000); 
        // $display("\033[33mDATA MEMORY Load Success\033[0m");
    end;

    always_ff @ (posedge clk) begin
        if (WE) begin
            mem_array[A+3] <= WD[31:24];
            mem_array[A+2] <= WD[23:16];
            mem_array[A+1] <= WD[15:8];
            mem_array[A+0] <= WD[7:0];
        end
    end

    always_comb begin
        RD = {mem_array[A+3], mem_array[A+2], mem_array[A+1], mem_array[A+0]}; // assemble 32-bit word from 4 bytes
    end

endmodule
