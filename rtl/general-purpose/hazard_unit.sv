module hazard_unit #(
    DATA_WIDTH = 32
) (
    input logic         RegWriteW,
    input logic         RegWriteM,
    input logic         WriteRegE,
    input logic         WriteRegM,
    input logic         BranchD,
    input logic         RegWriteE,
    input logic [4:0]   Rs1E,
    input logic [4:0]   Rs1D,
    input logic [4:0]   Rs2E,
    input logic [4:0]   Rs2D,
    input logic [4:0]   RdM,
    input logic [4:0]   RdW,
    input logic [1:0]   ResultSrcE, //MemtoRegE
    input logic [1:0]   ResultSrcM,
    output logic [1:0]  ForwardBD,
    output logic [1:0]  ForwardAD,
    output logic        FlushE,
    output logic        StallD,
    output logic        StallF,
    output logic [1:0]  ForwardBE,
    output logic [1:0]  ForwardAE
);
    
logic lwstall;
logic branchstall;

always_comb begin
    if((Rs1E !=0)  && (Rs1E == RdM)  && RegWriteM) 
        ForwardAE = 2'b10;
    else if((Rs1E !=0)  && (Rs1E == RdM)  && RegWriteW) 
        ForwardAE = 2'b01;
    else 
        ForwardAE = 2'b00;

    if((Rs2E !=0)  && (Rs2E == RdM)  && RegWriteM) 
        ForwardBE = 2'b10;
    else if((Rs2E !=0)  && (Rs2E == RdM)  && RegWriteW) 
        ForwardBE = 2'b01;
    else 
        ForwardBE = 2'b00;
    
    lwstall = ((Rs1D == Rs2E) || (Rs2D == Rs2E))  && (ResultSrcE == 2'b01);

    ForwardAD = (Rs1D != 0)  && (Rs1D == WriteRegM)  && RegWriteM;
    ForwardBD = (Rs2D != 0)  && (Rs2D == WriteRegM)  && RegWriteM;

    branchstall = (BranchD  && RegWriteE  && (WriteRegE == Rs1D || WriteRegE == Rs2D)) || (BranchD  && ResultSrcM == 2'b01  && (WriteRegM == Rs1D || WriteRegM == Rs2D));

    StallF = lwstall || branchstall;
    StallD = lwstall || branchstall;
    FlushE = lwstall || branchstall;

end

endmodule
