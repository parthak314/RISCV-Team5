/* verilator lint_off UNUSED */
module datamem #(
    parameter DATA_WIDTH = 32 

) (
    input logic                     clk,
    input logic [1:0]               write_enable,
    input logic [DATA_WIDTH-1:0]    addrA,  
    input logic [DATA_WIDTH-1:0]    addrB,  
    input logic [DATA_WIDTH-1:0]    wdataA,
    input logic [DATA_WIDTH-1:0]    wdataB,
    output logic [DATA_WIDTH-1:0]   rdataA,
    output logic [DATA_WIDTH-1:0]   rdataB
);

logic [DATA_WIDTH-1:0] ram_array [32'h0001FFFF:0]; // I'm not using 2**ADDRESS_WIDTH as this piece connects to the ALU and we can just have it be 32 bit

initial begin
    $readmemh("data.hex", ram_array, 32'h00010000); 
end;

always_comb begin
    rdataA = ram_array[addrA];
    rdataB = ram_array[addrB];
end

always @(posedge clk) begin
    if (write_enable[1]) ram_array[addrA] <= wdataA;
    if (write_enable[0]) ram_array[addrB] <= wdataB;
end

endmodule
