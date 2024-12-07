/* verilator lint_off UNUSED */
module ram2port #(
    parameter   DATA_WIDTH = 32,
                STORE_WIDTH = 8
) (
    input logic                     clk, // Allows for it to be clockedz
    input logic [DATA_WIDTH-1:0]    w_addr, // Input write address for data 
    input logic [DATA_WIDTH-1:0]    wd, // Data to be written in
    input logic                     we, // Write enable
    input logic [DATA_WIDTH-1:0]    r_addr, // Input address for read data 
    input   logic [2:0]               addr_mode,
    // input logic                     re, // read enable (to allow us to read from cache instead)
    output  logic [DATA_WIDTH-1:0]   rd //Read Data 
);

logic [STORE_WIDTH-1:0] ram_array [32'h0001FFFF:0]; // technically 32 bits, but we are only concerned with this block

initial begin
    $display("loading ram2port for Data Memory");
    $readmemh("data.hex", ram_array, 32'h00010000); 
end;

// reading (load instructions)
always_comb begin
    // rd = ram_array[r_addr];
    // if (re) rd = ram_array[r_addr];
   // else rd = {DATA_WIDTH{1'b0}};

   case(addr_mode[1:0])
        2'b00:  // byte addressing (lb | lbu)
            if (addr_mode[2]): rd = {24'b0, ram_array[r_addr[16:0]]}; // lbu
            else:  rd = {{24{ram_array[r_addr[16:0]][7]}}, ram_addr[r_addr[16:0]]}; // lb
        2'b01:  // half word addressing (lh | lhu)
            if (addr_mode[2]): rd = {16'b0, ram_array[r_addr[16:0] + 1], ram_addr[r_addr[16:0]]}; // lhu
            else:  rd = {{16{ram_array[r_addr[16:0] + 1][7]}}, ram_addr[r_addr[16:0] + 1], ram_addr[r_addr[16:0]]}; // lh
        2'b10:  // Word addressing (lw)
            rd = {ram_addr[r_addr[16:0] + 3], ram_addr[r_addr[16:0] + 2], ram_addr[r_addr[16:0] + 1], ram_array[r_addr[16:0]]};
   endcase
end

// writing
always @(posedge clk) begin
    if (we) //Checks if we can write 
        ram_array[w_addr] <= wd; //Assigns value of read data to be assigned at address a
end

endmodule
