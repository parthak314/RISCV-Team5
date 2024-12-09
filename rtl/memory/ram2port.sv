/* verilator lint_off UNUSED */
module ram2port #(
    parameter   DATA_WIDTH = 32,
                BYTE_WIDTH = 8
) (
    input logic                     clk, // Allows for it to be clocked
    input logic [DATA_WIDTH-1:0]    w_addr, // Input write address for data 
    input logic [DATA_WIDTH-1:0]    wd, // Data to be written in
    input logic                     we, // Write enable
    input logic [DATA_WIDTH-1:0]    r_addr, // Input address for read data 
    input logic                     re, // read enable (read only when miss)
    output logic [DATA_WIDTH-1:0]   rd //Read Data 
);

    logic [BYTE_WIDTH-1:0] ram_array [32'h0001FFFF:0]; // technically 32 bits, but we are only concerned with this block

    initial begin
        $readmemh("data.hex", ram_array, 32'h00010000); 
    end;

    always_comb begin
        // if not meant to read from ram, just send a '0 signal.
        if (re) begin
            rd = {
                ram_array[r_addr+3], 
                ram_array[r_addr+2], 
                ram_array[r_addr+1], 
                ram_array[r_addr+0]
            };
        end else rd = {DATA_WIDTH{1'b0}};
    end

    always @(posedge clk) begin
        if (we) begin //Checks if we can write 
            ram_array[w_addr+3] <= wd[31:24];
            ram_array[w_addr+2] <= wd[23:16];
            ram_array[w_addr+1] <= wd[15:8];
            ram_array[w_addr+0] <= wd[7:0];
        end
    end

endmodule
