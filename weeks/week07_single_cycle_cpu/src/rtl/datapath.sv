module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
    PCSrc,         // from controller ......
    ResultSrc,
    ALUControl,
    ALUSrca,
    ALUSrcb,
    ImmSrc,
    RegWrite,
    PC,            // for imem  
    ALUResult,     // for dmem ..
    WriteData,      
    Z_flag,         // for controller
    N_flag,
    C_flag,
    V_flag
);

    parameter   RESET_PC = 32'h1000_0000;

    //input
    input clk, n_rst,ALUSrcb, RegWrite;
    input [1:0] ALUSrca;
    input [1:0] PCSrc;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrc;
    input [2:0] ImmSrc;
    input [4:0] ALUControl;

    //output
    output [31:0] PC, ALUResult;
    output [31:0] WriteData;
    output Z_flag,N_flag,C_flag,V_flag;
    
    //wire
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] PC_next, PC_target, PC_plus4;
    wire [31:0] ImmExt;                       
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] Result;
    wire [31:0] BE_RD;
    
    mux3 u_pc_mux3(
        .in0(PC_plus4),
        .in1(PC_target),
        .in2(ALUResult),
        .sel(PCSrc),
        .out(PC_next)
    );
    
    flopr # (
        .RESET_VALUE (RESET_PC)
    ) u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .d(PC_next),
        .q(PC)
    );

    adder u_pc_plus4(
        .a(PC), 
        .b(32'h4), 
        .ci(1'b0), 
        .sum(PC_plus4),
        .N(),
        .Z(),
        .C(),
        .V()
    );

    extend u_Extend(
        .ImmSrc(ImmSrc),
        .in(Instr[31:7]),
        .out(ImmExt)
    );

    adder u_pc_target(
        .a(PC), 
        .b(ImmExt), 
        .ci(1'b0), 
        .sum(PC_target),
        .N(),
        .Z(),
        .C(),
        .V()
    );
    
    reg_file_async rf (
        .clk        (clk),
        .clkb       (clk),
        .we         (RegWrite),
        .ra1        (Instr[19:15]),
        .ra2        (Instr[24:20]),
        .wa         (Instr[11:7]),
        .wd         (Result),
        .rd1        (rs1_data),
        .rd2        (rs2_data)
    );

    mux2 u_alu_mux2(
        .in0(rs2_data),
        .in1(ImmExt),
        .sel(ALUSrcb),
        .out(SrcB)
    );

    alu u_ALU(
        .a_in(SrcA),
        .b_in(SrcB),
        .ALUControl(ALUControl),
        .result(ALUResult),
        .aZ(Z_flag),
        .aN(N_flag),
        .aC(C_flag),
        .aV(V_flag)
    );

    mux3 u_alu_mux3(
        .in0(rs1_data),
        .in1(PC),
        .in2(32'h0),
        .sel(ALUSrca),
        .out(SrcA)
    );

    mux3 u_result_mux3(
        .in0(ALUResult),
        .in1(BE_RD),
        .in2(PC_plus4),
        .sel(ResultSrc),
        .out(Result)
    );

    be_logic u_be_logic(
        .funct3(Instr[14:12]),
        .ADDR_Last2(ALUResult[1:0]),
        .WD(rs2_data),
        .RD(ReadData),
        .BE_WD(WriteData),
        .BE_RD(BE_RD)
    );

endmodule
