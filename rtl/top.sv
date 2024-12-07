module top #(
    parameter DATA_WIDTH = 32
) (
    input logic clk
);

    interfaceD intfD();
    interfaceE intfE();
    interfaceM intfM();
    interfaceW intfW();
    
    wire                    PCSrcE_wire;
    wire [DATA_WIDTH-1:0]   PCTargetE_wire;

    fetch_top fetch (
        .clk(clk),
        .PCSrc(PCSrcE_wire),
        .PCTarget(PCTargetE_wire),

        .InstrD(intfD.InstrD),
        .PCD(intfD.PCD),
        .PCPlus4D(intfD.PCPlus4D)
    );

    decode_top decode (
        .clk(clk),
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
        .PCPlus4E(intfE.PCPlus4E)
    );

    execute_top execute (
        .clk(clk),
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

    memwrite_top memory_write (
        .clk(clk),
        .RegWriteM(intfM.RegWriteM),
        .ResultsSrcM(intfM.ResultSrcM),
        .MemWriteM(intfM.MemWriteM),
        .MemoryOpM(intfM.MemoryOpM),
        .ALUResultM(intfM.ALUResultM),
        .WriteDataM(intfM.WriteDataM),
        .RdM(intfM.RdM),
        .PCPlus4M(intfM.PCPlus4M),
        .RegWriteW(intfW.RegWriteW),
        .RdW(intfW.RdW),
        .ResultW(intfW.ResultW)
    );

endmodule
