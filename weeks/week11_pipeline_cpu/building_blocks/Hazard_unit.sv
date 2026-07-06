module Hazard_unit(
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] rdE,
    input [1:0] ResultSrcE,       
    input [4:0] RdM,        
    input [4:0] RdW,        
    input RegWriteM,       
    input RegWriteW,
    input RegWriteE,
    input [1:0] PCSrc,
    output stallF,   
    output stallD,
    output FlushE,
    output FlushD,
    output lwstall,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output reg [1:0] ForwardAD,
    output reg [1:0] ForwardBD  
);
    //forward excute
    always @(*) begin
        if (((Rs1E == RdM) && RegWriteM == 1'b1) && (Rs1E != 1'b0)) begin
            ForwardAE = 2'b10; // Case 1
        end
        else if (((Rs1E == RdW) && RegWriteW == 1'b1) && (Rs1E != 1'b0)) begin
            ForwardAE = 2'b01; // Case 2
        end
        else begin
            ForwardAE = 2'b00; // Case 3
        end
    end

    always @(*) begin
        if (((Rs2E == RdM) && RegWriteM == 1'b1) && (Rs2E != 1'b0)) begin
            ForwardBE = 2'b10; // Case 1
        end
        else if (((Rs2E == RdW) && RegWriteW == 1'b1) && (Rs2E != 1'b0)) begin
            ForwardBE = 2'b01; // Case 2
        end
        else begin
            ForwardBE = 2'b00; // Case 3
        end
    end

    //forward decode
    always @(*) begin
        if (((Rs1D == rdE) && RegWriteE == 1'b1) && (Rs1D != 1'b0)) begin
            ForwardAD = 2'b10; // Case 1
        end
        else if (((Rs1D == RdM) && RegWriteM == 1'b1) && (Rs1D != 1'b0)) begin
            ForwardAD = 2'b01; // Case 2
        end
        else begin
            ForwardAD = 2'b00; // Case 3
        end
    end

    always @(*) begin
        if (((Rs2D == rdE) && RegWriteE == 1'b1) && (Rs2D != 1'b0)) begin
            ForwardBD = 2'b10; // Case 1
        end
        else if (((Rs2D == RdM) && RegWriteM == 1'b1) && (Rs2D != 1'b0)) begin
            ForwardBD = 2'b01; // Case 2
        end
        else begin
            ForwardBD = 2'b00; // Case 3
        end
    end

    assign lwstall = (((Rs1D == rdE) || (Rs2D == rdE)) && (ResultSrcE == 2'b01));
    assign stallF = lwstall;
    assign stallD = lwstall;
    assign FlushE = lwstall || (PCSrc != 2'b00);
    assign FlushD = (PCSrc != 2'b00);   
endmodule
