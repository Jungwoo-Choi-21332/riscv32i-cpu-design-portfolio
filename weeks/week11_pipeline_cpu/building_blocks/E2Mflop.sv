module E2Mflop(
    input clk,
    input [31:0] ALUResulti,
    input [31:0] WriteDatai,
    input [4:0] rdi,
    input [31:0] PCplus4i,

    input RegWritei,
    input [1:0] ResultSrci,
    input MemWritei,
    input [31:0] Instri,

    output reg [31:0] ALUResulto,
    output reg [31:0] WriteDatao,
    output reg [4:0] rdo,
    output reg [31:0] PCplus4o,

    output reg RegWriteo,
    output reg [1:0] ResultSrco,
    output reg MemWriteo,
    output reg [31:0] Instro

);


always@(posedge clk) begin
    if(clk) begin
        ALUResulto <= ALUResulti;
        WriteDatao <= WriteDatai;
        PCplus4o <= PCplus4i;
        rdo <= rdi;
        RegWriteo <= RegWritei;
        ResultSrco <= ResultSrci;
        MemWriteo <= MemWritei;
        Instro <= Instri;
    end
end
endmodule