module register_file #(
    parameter   DATA_WIDTH = 32,
                ADDRESS_WIDTH = 5
)(
    input logic                         clk,
    input logic [ADDRESS_WIDTH-1:0]     A1, 
    input logic [ADDRESS_WIDTH-1:0]     A2, 
    input logic [ADDRESS_WIDTH-1:0]     A3,     // address 3 for writing to
    input logic                         WE3,    // write enable
    input logic [DATA_WIDTH-1:0]        WD3,    // data to write to address 3

    output logic [DATA_WIDTH-1:0]       RD1,
    output logic [DATA_WIDTH-1:0]       RD2,

    output logic [DATA_WIDTH-1:0]       a0
);
    
    logic [DATA_WIDTH-1:0] reg_file [2**ADDRESS_WIDTH-1:0] /* verilator public_flat */;
    
    always_comb begin
        RD1 = reg_file[A1];
        RD2 = reg_file[A2];
        a0  = reg_file[10];
    end
    
    always @ (posedge clk) begin
        if (WE3 & A3 != 5'b0) begin
            reg_file[A3] <= WD3;
        end
    end   

endmodule
