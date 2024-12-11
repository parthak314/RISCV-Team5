module dram_main_mem #(
    parameter   DATA_WIDTH = 32,
                BYTE_WIDTH = 8
) (
    input logic                     clk,
    input logic [DATA_WIDTH-1:0]    w_addr, // write address for data 
    input logic [DATA_WIDTH-1:0]    wd,     // data to be written in
    input logic                     we,     // write enable
    input logic [DATA_WIDTH-1:0]    r_addr, // address for read data 
    input logic                     re,     // read enable (only read when cache miss)
    output logic [DATA_WIDTH-1:0]   rd      // read data 
);

    logic [BYTE_WIDTH-1:0] ram_array [32'h0001FFFF:0]; // technically 32 bits, but we are only concerned with this block

    initial begin
        $readmemh("data.hex", ram_array, 32'h00010000); 
    end;

    always @(posedge clk) begin
        // if not meant to read from ram, just send a 32'b0 signal.
        if (re) begin
            rd <= {
                ram_array[r_addr+3], 
                ram_array[r_addr+2], 
                ram_array[r_addr+1], 
                ram_array[r_addr+0]
            };
        end else rd <= {DATA_WIDTH{1'b0}};

        if (we) begin
            ram_array[w_addr+3] <= wd[31:24];
            ram_array[w_addr+2] <= wd[23:16];
            ram_array[w_addr+1] <= wd[15:8];
            ram_array[w_addr+0] <= wd[7:0];
        end
    end

    /*
    impossible for us to accidentally read and write to same location:
    - we write for evicted cache blocks and read for blocks not available on cache
    - contradictory for write and read block to be the same. Hence, should not occur in normal use
    */

endmodule
