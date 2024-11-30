module datamem #(
    parameter DATA_WIDTH = 32 

) (
    input logic [DATA_WIDTH-1:0]    a, //Input address for data 
    input logic [DATA_WIDTH-1:0]    wd, // Data to be written in
    input logic                     clk, // Allows for it to be clocked
    input logic                     we, // Wrte enable
    output logic [DATA_WIDTH-1:0]   rd //Read Data 
);

logic [DATA_WIDTH-1:0] ram_array [32'h0001FFFF:0]; //I'm not using 2**ADDRESS_WIDTH as this piece connects to the ALU and we can just have it be 32 bit

initial begin
    $display("Loading ram");
    $readmemh("./reference/pdf.hex", ram_array, 32'h00000100); 
end;

always_comb begin
    rd = ram_array[a];
end

always @(posedge clk) begin
    if (we == 1'b1) //Checks if we can write 
        ram_array[a] <= wd; //Assigns value of read data to be assigned at address a
end

endmodule
