/* verilator lint_off UNUSED */
module datamem #(
    parameter DATA_WIDTH = 32, 
              BYTE_WIDTH = 8

) (
    input logic [DATA_WIDTH-1:0]    a, // Input address for data 
    input logic [DATA_WIDTH-1:0]    wd, // Data to be written in
    input logic                     addr_mode, // Addressing mode: 0 for word, 1 for byte
    input logic                     clk, // Allows for it to be clocked
    input logic                     we, // Write enable
    output logic [DATA_WIDTH-1:0]   rd //Read Data 
);

logic [BYTE_WIDTH-1:0] ram_array [32'h0001FFFF:0]; 

initial begin
        $readmemh("data.hex", ram_array, 32'h00010000); 
    end;

    always_comb begin
        if (addr_mode) begin // load unsigned byte
            rd = {24'b0, ram_array[a[16:0]]}; 
        end else begin // load word
            rd = {ram_array[a[16:0] + 3], ram_array[a[16:0] + 2], ram_array[a[16:0] + 1], ram_array[a[16:0]]}; 
        end
    end

    always @(posedge clk) begin
        if (we) begin
            if (addr_mode) begin // store byte
                ram_array[a[16:0]] <= wd[7:0];
            end else begin // store word
                ram_array[a[16:0]] <= wd[7:0];
                ram_array[a[16:0] + 1] <= wd[15:8];
                ram_array[a[16:0] + 2] <= wd[23:16];
                ram_array[a[16:0] + 3] <= wd[31:24];
            end
        end
    end

endmodule
