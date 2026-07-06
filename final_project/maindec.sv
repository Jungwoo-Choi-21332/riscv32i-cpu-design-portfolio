module maindec(
    funct3,
    opcode,
    ResultSrc,
    MemWrite,
    ALUSrca,
    ALUSrcb,
    ImmSrc,
    RegWrite,
    Jump,
    ALUop,
    Btaken,
    csr,
    Branch
);
    // input
    input [2:0] funct3;
    input [6:0] opcode;
    input Btaken;
    // output
    output reg csr;
    output reg MemWrite, ALUSrcb, RegWrite, Jump;
    output reg [1:0] ALUSrca;
    output reg [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output reg [1:0] ALUop;

    output reg Branch;

    always@(*) begin    // main decoder  | bit aassignment 1_3_2_1_1_2_1_2_1
        case(opcode)
            7'b000_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b1_000_00_1_0_01_0_00_0_0;     // lw
            7'b010_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b0_001_00_1_1_00_0_00_0_0;     // sw
            7'b011_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b1_000_00_0_0_00_0_10_0_0;     // R-type
            7'b110_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b0_010_00_0_0_00_1_01_0_0;     // branch
            7'b001_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b1_000_00_1_0_00_0_10_0_0;     // I-type ALU
            7'b011_0111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b1_100_10_1_0_00_0_00_0_0;     // lui
            7'b001_0111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b11_0001_1000_0000_0;     // auipc
            7'b110_1111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b1_011_00_0_0_10_0_xx_1_0;     // jal
            7'b110_0111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b1_000_00_1_0_10_0_00_1_0;     // jalr 
            7'b111_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} = 15'b0_101_00_1_0_00_0_00_0_1;     // CSR
            default : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump, csr} =  15'b0_000_00_0_0_00_0_00_0_0;
        endcase
    end

endmodule
