module maindec(
    Z_flag,
    funct3,
    opcode,
    PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrc,
    ImmSrc,
    RegWrite,
    Jump,
    funct3,
    ALUop
);
    // input
    input Z_flag;
    input [2:0] funct3;
    input [6:0] opcode;
    // output
    output  reg PCSrc;
    output reg MemWrite, ALUSrc, RegWrite, Jump;
    output reg [1:0] ResultSrc, ImmSrc;
    output reg [1:0] ALUop;

    reg Branch;

    always@(*)
        case(funct3)
            3'b000 : PCSrc = (Branch & Z_flag) | Jump ;
            3'b001 : PCSrc = (Branch & ~Z_flag) | Jump;
            default : PCSrc = (Branch & Z_flag) | Jump ;
        endcase

    always@(*) begin    // main decoder
        case(opcode)
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'b100_1001_0000;     // lw
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'b001_11xx_0000;     // sw
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'b1xx_0000_0100;     // R-type
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'b010_0000_1010;     // beq & bne
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'b100_1000_0100;     // I-type ALU
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'b100_0100_0000;     // lui
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'b111_x010_0xx1;     // jal
            default : {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUop, Jump} = 11'hx;
        endcase
    end

endmodule
