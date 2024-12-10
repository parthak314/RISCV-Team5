module instr_mem #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 8,
              OUT_WIDTH = 32
)(
    input logic     [ADDRESS_WIDTH-1:0] addr,
    output logic    [OUT_WIDTH-1:0]     instrA,
    output logic    [OUT_WIDTH-1:0]     instrB
);

logic [DATA_WIDTH-1:0] rom_array [32'h00000FFF:0]; // instruction ROM from 0xBFC00FFF to 0xBFC00000 as in memory map

initial begin
    $readmemh("program.hex", rom_array); 
end;

    always_comb begin
        instrA = {rom_array[addr+3], rom_array[addr+2], rom_array[addr+1], rom_array[addr+0]}; // assemble 32-bit word from 4 bytes
        instrB = {rom_array[addr+7], rom_array[addr+6], rom_array[addr+5], rom_array[addr+4]};
    end

endmodule
