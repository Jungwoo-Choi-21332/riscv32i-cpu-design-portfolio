module F2Dflop(
    input clk,
    input [31:0] Instri,
    input [31:0] PCplus4i,
    input [31:0] PCi,
    input stallD,
    input FlushD,
    output reg [31:0] Instro,
    output reg [31:0] PCplus4o,
    output reg [31:0] PCo
);


always @(posedge clk) begin
    if (FlushD) begin
        Instro <= 32'h00000013;
        PCplus4o <= PCplus4o;
        PCo <= PCo;
    end
    else if (stallD) begin
        Instro <= Instro;
        PCplus4o <= PCplus4o;
        PCo <= PCo;
    end
    else begin
        Instro <= Instri;
        PCplus4o <= PCplus4i;
        PCo <= PCi;
    end
end
endmodule