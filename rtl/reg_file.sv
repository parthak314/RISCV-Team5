module reg_file #( 
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
)(
    input logic                  clk,        // clock
    input logic                  reset,      // reset
    input logic                  write_enable, // WE3 write enable signal (regwrite from cu)
    input logic [ADDR_WIDTH-1:0] read_addr1, // A1 address for read port 1
    input logic [ADDR_WIDTH-1:0] read_addr2, // A2 Address for read port 2
    input logic [ADDR_WIDTH-1:0] write_addr, // A3 Address for write port
    input logic [DATA_WIDTH-1:0] write_data, // Data to write
    output logic [DATA_WIDTH-1:0] read_data1, // Output from read port 1
    output logic [DATA_WIDTH-1:0] read_data2,  // Output from read port 2
    output logic [DATA_WIDTH-1:0] a0
);

    logic [DATA_WIDTH-1:0] registers [2**ADDR_WIDTH-1:0];

    // Read operation (asynchronous reads)
    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];

    // Write operation (synchronous write)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers, including register 0
            for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
                registers[i] <= 0;
            end
        end
        else if (write_enable && write_addr != 5'b0) begin
            // Don't write to register 0
            registers[write_addr] <= write_data;
        end
    end

    assign a0 = registers[0];

endmodule
