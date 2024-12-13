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

logic [BYTE_WIDTH-1:0] ram_array [32'h0001FFFF:0]; // I'm not using 2**ADDRESS_WIDTH as this piece connects to the ALU and we can just have it be 32 bit

initial begin
        $readmemh("data.hex", ram_array, 32'h00010000); 
    end;

    always_comb begin
        if (addr_mode) begin
            rd = {24'b0, ram_array[a[16:0]]};
        end else begin
            rd = {ram_array[a[16:0] + 3], ram_array[a[16:0] + 2], ram_array[a[16:0] + 1], ram_array[a[16:0]]}; 
        end
        // rd = {
        //     ram_array[r_addr+3], 
        //     ram_array[r_addr+2], 
        //     ram_array[r_addr+1], 
        //     ram_array[r_addr+0]
        // };
    end

    always @(posedge clk) begin
        if (we) begin
            if (addr_mode) begin
                ram_array[a] <= wd[7:0];
            end else begin
                ram_array[a] <= wd[7:0];
                ram_array[a+1] <= wd[15:8];
                ram_array[a+2] <= wd[23:16];
                ram_array[a+3] <= wd[31:24];
            end
        end

        // if (we) begin //Checks if we can write 
        //     ram_array[w_addr+3] <= wd[31:24];
        //     ram_array[w_addr+2] <= wd[23:16];
        //     ram_array[w_addr+1] <= wd[15:8];
        //     ram_array[w_addr+0] <= wd[7:0];
        // end
    end

endmodule
