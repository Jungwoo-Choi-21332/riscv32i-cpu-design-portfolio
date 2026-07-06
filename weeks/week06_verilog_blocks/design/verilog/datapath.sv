module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
    PCSrc,         // from controller ......
    ResultSrc,
    ALUControl,
    ALUSrc,
    ImmSrc,
    RegWrite,
    PC,            // for imem  
    ALUResult,     // for dmem ..
    WriteData,      
    Z_flag         // for controller
);
    //input
    input clk, n_rst, PCSrc, ALUSrc, RegWrite;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrc, ImmSrc;
    input [2:0] ALUControl;
    //output
    output [31:0] PC, ALUResult;
    output [31:0] WriteData;
    output Z_flag;

    wire [31:0] PC_next, PC_target, PC_plus4;
    wire [31:0] ImmExt;                       
    wire [31:0] SrcA, bef_SrcB;
    wire [31:0] SrcB;
    wire [31:0] Result;

    assign WriteData = bef_SrcB;

    mux2 u_pc_mux2(
        .in0(PC_plus4),
        .in1(PC_target),
        .sel(PCSrc),
        .out(PC_next)
    );
    
    flopr u_pc_register(
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
    
    regfile u_register_file(
        .clk(clk),
        .rs1(Instr[19:15]),
        .rs2(Instr[24:20]),
        .write_enable(RegWrite),
        .rd(Instr[11:7]),
        .rd_data(Result),
        .rs1_data(SrcA),
        .rs2_data(bef_SrcB)
    );


    mux2 u_alu_mux2(
        .in0(bef_SrcB),
        .in1(ImmExt),
        .sel(ALUSrc),
        .out(SrcB)
    );

    alu u_ALU(
        .a_in(SrcA),
        .b_in(SrcB),
        .ALUControl(ALUControl),
        .result(ALUResult),
        .aZ(Z_flag)
    );

    mux3 u_result_mux3(
        .in0(ALUResult),
        .in1(ReadData),
        .in2(PC_plus4),
        .sel(ResultSrc),
        .out(Result)
    );

endmodule
