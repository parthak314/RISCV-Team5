module reg_file #( 
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
)(
    input logic                  clk,        
    input logic                  reset,      
    input logic [1:0]            write_enable,
    input logic [ADDR_WIDTH-1:0] raddr1A, 
    input logic [ADDR_WIDTH-1:0] raddr2A, 
    input logic [ADDR_WIDTH-1:0] waddrA, 
    input logic [DATA_WIDTH-1:0] wdataA, 
    input logic [ADDR_WIDTH-1:0] raddr1B, 
    input logic [ADDR_WIDTH-1:0] raddr2B, 
    input logic [ADDR_WIDTH-1:0] waddrB, 
    input logic [DATA_WIDTH-1:0] wdataB, 
    output logic [DATA_WIDTH-1:0] rdata1A, 
    output logic [DATA_WIDTH-1:0] rdata2A, 
    output logic [DATA_WIDTH-1:0] rdata1B, 
    output logic [DATA_WIDTH-1:0] rdata2B, 
    output logic [DATA_WIDTH-1:0] a0
);

    logic [DATA_WIDTH-1:0] registers [2**ADDR_WIDTH-1:0];

    // Read operation (asynchronous reads)
    assign rdata1A = registers[raddr1A];
    assign rdata2A = registers[raddr2A];
    assign rdata1B = registers[raddr1B];
    assign rdata2B = registers[raddr2B];

    // Write operation (synchronous write)
    always_ff @(posedge clk) begin
        if (reset) begin
            // Reset all registers, including register 0
            for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
                registers[i] <= 0;
            end
        end
        else begin
            if (write_enable[1] && waddrA != 5'b0) begin
                // Don't write to register 0
                registers[waddrA] <= wdataA;
            end
            if (write_enable[0] && waddrB != 5'b0) begin
                registers[waddrB] <= wdataB;
            end
        end
    end

    assign a0 = registers[10];

endmodule
