module sram_cache #(
    parameter   CACHE_ADDR_WIDTH = 9,
                SET_SIZE = 111 // see how its calculated in cache_controller.sv
) (
    input   logic                               clk,
    input   logic [CACHE_ADDR_WIDTH-1:0]        addr,   // address for data
    input   logic [SET_SIZE-1:0]                wd,     // data to be written in
    input   logic                               we,     // write enable
    input   logic                               re,     // read enable
    output  logic [SET_SIZE-1:0]                rd      // read out data 
);
    logic [SET_SIZE-1:0] set_array [2**CACHE_ADDR_WIDTH-1:0];
    
    // READ OUT logic
    always_comb begin
        if (re) rd = set_array[addr];
        else    rd = {SET_SIZE{1'b0}}; // only read when read enable is HIGH
    end

    // WRITE IN login
    always @(posedge clk) begin
        if (we) set_array[addr] <= wd; // write in the write-data at addr
    end

endmodule
