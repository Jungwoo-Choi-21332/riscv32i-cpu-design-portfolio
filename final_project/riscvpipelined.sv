module riscvpipe(
	clk,
	n_rst,
	PC,
	Instr,
	ALUResult,
	WriteData,
	ReadData,
    MemWrite,
    MemWriteM,
    ALUResultM
);

	parameter   RESET_PC = 32'h1000_0000;

	//input
    input clk, n_rst;
    input [31:0] ReadData;
    input [31:0] Instr;

    //output
    output [31:0] PC, ALUResult, WriteData;
    output [31:0] ALUResultM;
    output MemWriteM;
    output wire MemWrite;

    wire Z_flag, ALUSrcb, RegWrite;  
    wire N_flag, C_flag, V_flag;
    wire [1:0] ALUSrca;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [4:0] ALUControl;
    wire Branch;
    wire [31:0] InstrD;
    wire csr;

	controller u_controller(
        .opcode(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[30]),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrca(ALUSrca),
        .ALUSrcb(ALUSrcb),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .Jump(Jump),
        .Branch(Branch),
        .csr(csr)
    );

	datapath #(
		.RESET_PC(RESET_PC)
	) i_datapath(
		.clk(clk),
        .n_rst(n_rst),
        .Instr(Instr),        
        .ReadData(ReadData),        
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrca(ALUSrca),
        .ALUSrcb(ALUSrcb),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .PC(PC),            
        .ALUResult(ALUResult),   
        .WriteData(WriteData),      
        .Branch(Branch),
        .InstrD(InstrD),
        .Jump(Jump),
        .MemWrite(MemWrite),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .csr(csr),
        .csr2()
	);


endmodule
