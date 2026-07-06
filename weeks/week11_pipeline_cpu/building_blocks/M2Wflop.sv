module M2Wflop(
    input clk,
    input [31:0] ALUResulti,
    input [31:0] RDi,
    input [4:0] rdi,
    input [31:0] PCplus4i,
    input RegWritei,
    input [1:0] ResultSrci,
    input [31:0] Instri,

    output reg [31:0] ALUResulto,
    output reg [31:0] RDo,
    output reg [4:0] rdo,
    output reg [31:0] PCplus4o,
    output reg RegWriteo,
    output reg [1:0] ResultSrco,
    output reg [31:0] Instro

);


always@(posedge clk) begin
    if(clk) begin
        ALUResulto <= ALUResulti;
        RDo <= RDi;
        PCplus4o <= PCplus4i;
        rdo <= rdi;
        RegWriteo <= RegWritei;
        ResultSrco <= ResultSrci;
        Instro <= Instri;
    end
end
endmodule