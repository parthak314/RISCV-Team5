module hazard_unit (
    input logic [4:0] Rs1E,
    input logic [4:0] Rs2E,

    input logic RegWriteM,
    input logic RegWriteW,
    input logic [4:0] RdM,
    input logic [4:0] RdW,

    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE

);
    
    always_comb begin
        if ( (Rs1E == RdM) & RegWriteM )        ForwardAE = 2'b10;
        else if ( (Rs1E == RdW) & RegWriteW )   ForwardAE = 2'b01;
        else                                    ForwardAE = 2'b00;

        if ( (Rs2E == RdM) & RegWriteM )        ForwardBE = 2'b10;
        else if ( (Rs2E == RdW) & RegWriteW )   ForwardBE = 2'b01;
        else                                    ForwardBE = 2'b00;
    end

endmodule
