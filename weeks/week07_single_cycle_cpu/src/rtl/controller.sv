module controller(
    Z_flag,
    opcode,
    funct3,
    funct7,
    PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrcb,
    ALUSrca,
    ImmSrc,
    RegWrite,
    ALUControl,
    Jump,
    N_flag,
    C_flag,
    V_flag
);
    // input
    input Z_flag,N_flag,C_flag,V_flag;
    input [6:0] opcode;
    input [2:0] funct3;
    input  funct7;
    // output
    output [1:0]PCSrc;
    output MemWrite,ALUSrcb, RegWrite, Jump;
    output [1:0] ALUSrca;
    output [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output [4:0] ALUControl;

    wire [1:0] ALUop;

    maindec mdec(
        .Z_flag(Z_flag),
        .opcode(opcode),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcb(ALUSrcb),
        .ALUSrca(ALUSrca),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .funct3(funct3),
        .ALUop(ALUop),
        .N_flag(N_flag),
        .C_flag(C_flag),
        .V_flag(V_flag)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

endmodule
