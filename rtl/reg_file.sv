module  reg_file (
    paremeter A_WIDTH = 5,
              D_WIDTH = 32
)(  
    input   logic   [A_WIDTH-1:0]  A1,
    input   logic   [A_WIDTH-1:0]  A2,
    input   logic   [A_WIDTH-1:0]  A3,
    input   logic   [D_WIDTH-1:0]  WD3,
    input   logic                  WE3,
    input   logic                  clk,
    output  logic   [D_WIDTH-1:0]  RD1,
    output  logic   [D_WIDTH-1:0]  RD2
);
    
    logic[DATA_WIDTH-1:0] reg_file [0:2**ADDRESS_WIDTH-1];

    always_comb begin
        RD1 = reg_file[AD1];
        RD2 = reg_file[AD2];
    end

    always @ (posedge clk) begin
        if (WE3) begin
            reg_file[AD3] <= WD3;
            A0 <= reg_file[AD3];
        end
    end   

endmodule