module controller(
    Z_flag,
    opcode,
    funct3,
    funct7,
    PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrc,
    ImmSrc,
    RegWrite,
    ALUControl,
    Jump
);
    // input
    input Z_flag;
    input [6:0] opcode;
    input [2:0] funct3;
    input  funct7;
    // output
    output PCSrc;
    output MemWrite, ALUSrc, RegWrite, Jump;
    output [1:0] ResultSrc, ImmSrc;
    output [2:0] ALUControl;

    wire [1:0] ALUop;

    maindec mdec(
        .Z_flag(Z_flag),
        .opcode(opcode),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .funct3(funct3),
        .ALUop(ALUop)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

endmodule
