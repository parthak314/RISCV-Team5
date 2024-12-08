module instr_mem #(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32,
                ROM_WIDTH = 8
)(
    input logic     [ADDRESS_WIDTH-1:0] addr,
    output logic    [DATA_WIDTH-1:0]    instr
);

// instruction ROM from 0xBFC00FFF to 0xBFC00000 as in memory map
logic [ROM_WIDTH-1:0] rom_array [32'h00000FFF:0] /* verilator public_flat */; 

initial begin
    $readmemh("program.hex", rom_array); 
    // $display("\033[33mINSTRUCTION ROM Load Success\033[0m");

end;

    always_comb begin
        instr = {rom_array[addr+3], rom_array[addr+2], rom_array[addr+1], rom_array[addr+0]}; // assemble 32-bit word from 4 bytes
    end

endmodule
