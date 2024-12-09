module sram #(
    parameter   CACHE_ADDR_WIDTH = 9,
                SET_SIZE = 111 // see how its calculated in cache_controller.sv
) (
    input   logic                               clk, // Allows for it to be clocked
    input   logic [CACHE_ADDR_WIDTH-1:0]        addr, // Input address for data
    input   logic [SET_SIZE-1:0]                wd, // Data to be written in
    input   logic                               we, // Write enable
    input   logic                               re, // read enable
    output  logic [SET_SIZE-1:0]                rd //Read Data 
);
    logic [SET_SIZE-1:0] set_array [2**CACHE_ADDR_WIDTH-1:0];
    
    always_comb begin
        if (re) rd = set_array[addr];
        else rd = {SET_SIZE{1'b0}}; // only read when read enable is HIGH
    end

    always @(posedge clk) begin
        if (we) //Checks if we can write 
            set_array[addr] <= wd; //Assigns value of read data to be assigned at address a
    end

endmodule
