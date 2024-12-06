/* verilator lint_off UNUSED */
module ram2port #(
    parameter   DATA_WIDTH = 32
) (
    input logic                     clk, // Allows for it to be clocked
    input logic [DATA_WIDTH-1:0]    w_addr, // Input write address for data 
    input logic [DATA_WIDTH-1:0]    wd, // Data to be written in
    input logic                     we, // Write enable
    input logic [DATA_WIDTH-1:0]    r_addr, // Input address for read data 
    // input logic                     re, // read enable (to allow us to read from cache instead)
    output logic [DATA_WIDTH-1:0]   rd //Read Data 
);

logic [DATA_WIDTH-1:0] ram_array [32'h0001FFFF:0]; // technically 32 bits, but we are only concerned with this block

initial begin
    $readmemh("data.hex", ram_array, 32'h00010000); 
end;

always_comb begin
    rd = ram_array[r_addr];
    // if (re) rd = ram_array[r_addr];
   // else rd = {DATA_WIDTH{1'b0}};
end

always @(posedge clk) begin
    if (we) //Checks if we can write 
        ram_array[w_addr] <= wd; //Assigns value of read data to be assigned at address a
end

endmodule
