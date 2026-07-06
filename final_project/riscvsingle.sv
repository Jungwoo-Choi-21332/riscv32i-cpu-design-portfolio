module riscvsingle(
	clk,
	n_rst,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);

	parameter   RESET_PC = 32'h1000_0000;

	//input
    input clk, n_rst;
    input [31:0] ReadData;
    input [31:0] Instr;

    //output
    output MemWrite;
    output [31:0] PC, ALUResult, WriteData;

    wire Z_flag, ALUSrcb, RegWrite;  
    wire N_flag, C_flag, V_flag;
    wire [1:0] ALUSrca;
    wire [1:0] ResultSrc,PCSrc;
    wire [2:0] ImmSrc;
    wire [4:0] ALUControl;
    wire Btaken;
    wire Branch;
    wire Jump;


	controller u_controller(
        .opcode(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[30]),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrca(ALUSrca),
        .ALUSrcb(ALUSrcb),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .Btaken(Btaken),
        .Branch(Branch),
        .Jump(Jump)
    );

	datapath #(
		.RESET_PC(RESET_PC)
	) i_datapath(
		.clk(clk),
        .n_rst(n_rst),
        .Instr(Instr),        
        .ReadData(ReadData),    
        .PCSrc(PCSrc),      
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrca(ALUSrca),
        .ALUSrcb(ALUSrcb),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .PC(PC),            
        .ALUResult(ALUResult),   
        .WriteData(WriteData),      
        .Btaken(Btaken),
        .Branch(Branch),
        .Jump(Jump)
	);


endmodule
