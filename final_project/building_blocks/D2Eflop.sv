module D2Eflop(
    input clk,
    input [31:0] RD1i,
    input [31:0] RD2i,
    input [31:0] PCi,
    input [4:0] rdi,
    input [31:0] ImmExti,
    input [31:0] Instri,
    input [4:0] Rs1D,
    input [4:0] Rs2D,

    input RegWritei,
    input [1:0] ResultSrci,
    input MemWritei,
    input Jumpi,
    input Branchi,
    input [4:0] ALUControli,
    input [1:0] ALUSrcAi,    
    input ALUSrcBi,   

    input FlushE,
    input stall,

    output reg [31:0] RD1o,
    output reg [31:0] RD2o,
    output reg [31:0] PCo,
    output reg [4:0] rdo,
    output reg [31:0] ImmExto,
    output reg [31:0] Instro,
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E, 

    output reg RegWriteo,
    output reg [1:0] ResultSrco,
    output reg MemWriteo,
    output reg Jumpo,
    output reg Brancho,
    output reg [4:0] ALUControlo,
    output reg [1:0] ALUSrcAo,  
    output reg ALUSrcBo
);

always @(posedge clk) begin
    if (FlushE) begin
        RD1o <= RD1o;
        RD2o <= RD2o;
        PCo <= PCo;
        rdo <= 5'b0;
        ImmExto <= ImmExto;
        Instro <= 32'h0000_0013;

        RegWriteo <= 1'b0;
        ResultSrco <= 2'b0;
        MemWriteo <= 1'b0;
        Jumpo <= 1'b0;
        Brancho <= 1'b0;
        ALUControlo <= 5'b0;
        ALUSrcAo <= 2'b0;
        ALUSrcBo <= 1'b0;

        Rs1E <= Rs1E;
        Rs2E <= Rs2E;

    end 
    else begin
        RD1o <= RD1i;
        RD2o <= RD2i;
        PCo <= PCi;
        rdo <= rdi;
        ImmExto <= ImmExti;
        Instro <= Instri;

        RegWriteo <= RegWritei;
        ResultSrco <= ResultSrci;
        MemWriteo <= MemWritei;
        Jumpo <= Jumpi;
        Brancho <= Branchi;
        ALUControlo <= ALUControli;
        ALUSrcAo <= ALUSrcAi; 
        ALUSrcBo <= ALUSrcBi;  

        Rs1E <= Rs1D;
        Rs2E <= Rs2D;

    end
end

endmodule
