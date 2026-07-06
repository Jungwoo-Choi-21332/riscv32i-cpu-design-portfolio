module controller(
    opcode,
    funct3,
    funct7,
    ResultSrc,
    MemWrite,
    ALUSrcb,
    ALUSrca,
    ImmSrc,
    RegWrite,
    ALUControl,
    Jump,
    csr,
    Branch
);
    input [6:0] opcode;
    input [2:0] funct3;
    input funct7;
    // output
    output MemWrite,ALUSrcb, RegWrite, Jump;
    output [1:0] ALUSrca;
    output [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output [4:0] ALUControl;
    output Branch;
    output csr;

    wire [1:0] ALUop;

    maindec mdec(
        .opcode(opcode),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcb(ALUSrcb),
        .ALUSrca(ALUSrca),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .funct3(funct3),
        .ALUop(ALUop),
        .csr(csr),
        .Branch(Branch)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

endmodule
