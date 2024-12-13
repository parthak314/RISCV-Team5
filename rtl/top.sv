

module top #(
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     trigger,
    input logic                     rst,

    output logic [DATA_WIDTH-1:0]   a0
);

    interfaceD intfD();
    interfaceE intfE();
    interfaceM intfM();
    interfaceW intfW();
    
    wire                    PCSrcE_wire;
    wire [DATA_WIDTH-1:0]   PCTargetE_wire;
    wire [DATA_WIDTH-1:0]   ReadDataM_wire; // for data forwarding from memory stage

    fetch_top fetch (
        .clk(clk),
        .stall(trigger),
        .reset(rst),

        .PCSrc(PCSrcE_wire),
        .PCTarget(PCTargetE_wire),

        .InstrD(intfD.InstrD),
        .PCD(intfD.PCD),
        .PCPlus4D(intfD.PCPlus4D)
    );

    decode_top decode (
        .clk(clk),
        .stall(trigger),
        .reset(rst),

        .InstrD(intfD.InstrD),
        .PCD(intfD.PCD),
        .PCPlus4D(intfD.PCPlus4D),
        .RegWriteW(intfW.RegWriteW),
        .ResultW(intfW.ResultW),
        .RdW(intfW.RdW),

        .PCSrcE(PCSrcE_wire),

        .RegWriteE(intfE.RegWriteE),
        .ResultSrcE(intfE.ResultSrcE),
        .MemWriteE(intfE.MemWriteE),
        .JumpE(intfE.JumpE),
        .BranchE(intfE.BranchE),
        .ALUControlE(intfE.ALUControlE),
        .ALUSrcE(intfE.ALUSrcE),
        .UpperOpE(intfE.UpperOpE),
        .MemoryOpE(intfE.MemoryOpE),
        .RD1E(intfE.RD1E),
        .RD2E(intfE.RD2E),
        .PCE(intfE.PCE),
        .Rs1E(intfE.Rs1E),
        .Rs2E(intfE.Rs2E),
        .RdE(intfE.RdE),
        .ImmExtE(intfE.ImmExtE),
        .PCPlus4E(intfE.PCPlus4E),
        .a0(a0)
    );

    execute_top execute (
        .clk(clk),
        .stall(trigger),
        .reset(rst),

        .RegWriteE(intfE.RegWriteE),
        .ResultSrcE(intfE.ResultSrcE),
        .MemWriteE(intfE.MemWriteE),
        .JumpE(intfE.JumpE),
        .BranchE(intfE.BranchE),
        .ALUControlE(intfE.ALUControlE),
        .ALUSrcE(intfE.ALUSrcE),
        .UpperOpE(intfE.UpperOpE),
        .MemoryOpE(intfE.MemoryOpE),
        .RD1E(intfE.RD1E),
        .RD2E(intfE.RD2E),
        .PCE(intfE.PCE),
        .Rs1E(intfE.Rs1E),
        .Rs2E(intfE.Rs2E),
        .RdE(intfE.RdE),
        .ImmExtE(intfE.ImmExtE),
        .PCPlus4E(intfE.PCPlus4E),
        
        .RegWriteW(intfW.RegWriteW),
        .RdW(intfW.RdW),
        .ResultW(intfW.ResultW),
        .ReadDataM(ReadDataM_wire),

        .RegWriteM(intfM.RegWriteM),
        .ResultSrcM(intfM.ResultSrcM),
        .MemWriteM(intfM.MemWriteM),
        .MemoryOpM(intfM.MemoryOpM),
        .ALUResultM(intfM.ALUResultM),
        .WriteDataM(intfM.WriteDataM),
        .RdM(intfM.RdM),    
        .PCPlus4M(intfM.PCPlus4M),
        .PCTargetE(PCTargetE_wire), 
        .PCSrcE(PCSrcE_wire)
    );

    memory_top memory (
        .clk(clk),
        .stall(trigger),
        .reset(rst),
        
        .RegWriteM(intfM.RegWriteM),
        .ResultsSrcM(intfM.ResultSrcM),
        .MemWriteM(intfM.MemWriteM),
        .MemoryOpM(intfM.MemoryOpM),
        .ALUResultM(intfM.ALUResultM),
        .WriteDataM(intfM.WriteDataM),
        .RdM(intfM.RdM),
        .PCPlus4M(intfM.PCPlus4M),

        .ReadDataM(ReadDataM_wire),

        .RegWriteW(intfW.RegWriteW),
        .RdW(intfW.RdW),
        .ResultW(intfW.ResultW)
    );

endmodule
