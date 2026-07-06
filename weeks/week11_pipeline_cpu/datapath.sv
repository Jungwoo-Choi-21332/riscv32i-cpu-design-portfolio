module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
                   // from controller ......
    ResultSrc,
    ALUControl,
    ALUSrca,
    ALUSrcb,
    ImmSrc,
    RegWrite,
    PC,            // for imem  
    ALUResult,     // for dmem ..
    WriteData,
    MemWrite,      
    //csr,
    Branch,
    InstrD,
    Jump,
    //for memory
    MemWriteM,
    ALUResultM,
    WriteDatabe
    //csr2
);

    parameter   RESET_PC = 32'h1000_0000;

    //input
    input clk, n_rst,ALUSrcb, RegWrite;
    input [1:0] ALUSrca;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrc;
    input [2:0] ImmSrc;
    input [4:0] ALUControl;
    input Branch;
    input Jump;
    input MemWrite;
    //input csr;

    //output
    output [31:0] PC, ALUResult;
    output [31:0] WriteData;
    output [31:0] WriteDatabe;
    wire  Btaken;
    output wire [31:0]InstrD, ALUResultM;
    output wire MemWriteM;

    //wire
    wire Z_flag,N_flag,C_flag,V_flag;
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] PC_next, PC_target, PC_plus4;
    wire [31:0] ImmExt;                       
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] ResultW;
    wire [31:0] BE_RD;

    wire [1:0] ALUSrcAE;
    wire ALUSrcBE;
    wire [1:0] PCsrcE;

    //pipeline wire datapath
    wire [31:0] PCD, PCplus4D,PCplusW;
    wire [31:0] RD1E, RD2E, PCE, PCplusE, ImmExtE;
    wire [4:0] rdE,rdM,rdW;
    wire [31:0] PCplusM,WriteDataM;
    wire [31:0] ALUResultW, ReadDataW;
    //pipeline wire contorl
    wire [1:0] ResultSrcD;
    wire RegWriteD, JumpD, BranchD, ALUsrcD;
    wire [4:0] ALUControlD;
    wire [1:0] ResultSrcE;
    wire RegWriteE, MemWriteE, JumpE, BranchE, ALUsrcE;
    wire [4:0] ALUControlE;
    wire RegWriteM;
    wire [1:0] ResultSrcM;
    wire RegWriteW;
    wire [1:0] ResultSrcW;
    wire [31:0] InstrE, InstrM, InstrW;
    wire [1:0] ForwardAE, ForwardBE,ForwardAD, ForwardBD;
    wire [4:0] Rs1E, Rs2E;
    wire [31:0] SrcB_a;
    wire lwstall,stallD,stallF;
    wire FlushE,FlushD;
    wire [31:0] BE_RD_2;
    wire [31:0] Srca_a;
    wire [31:0] forward_rs1,forward_rs2;
    /*
    output reg csr2;
    reg [31:0] tohost_csr;

    always@(posedge clk or negedge n_rst)begin
        if(!n_rst)
            csr2 <= 1'b0;
        else
            csr2 <= csr;
    end

    always @(posedge clk)
    begin
        if(csr2 == 1'b1)
            begin
                case(InstrE[14:12])
                    3'b001 : tohost_csr <= Srca_a;
                    3'b101 : tohost_csr <= ImmExtE;
                    default : tohost_csr <= 32'h0;
                endcase
            end 
            else
                tohost_csr <= 32'h0;
    end
    */

    //PC region
    mux3 u_pc_mux3(
        .in0(PC_plus4),
        .in1(PC_target),
        .in2(ALUResult),
        .sel(PCsrcE),
        .out(PC_next)
    );

    flopr # (
        .RESET_VALUE (RESET_PC)
    ) u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .d(PC_next),
        .q(PC),
        .stallF(stallF)
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

    adder u_pc_target(
        .a(PCE), 
        .b(ImmExtE), 
        .ci(1'b0), 
        .sum(PC_target),
        .N(),
        .Z(),
        .C(),
        .V()
    );

    //pipeline register region
    F2Dflop u_F2Dflop(
        .clk(clk),
        .Instri(Instr),
        .Instro(InstrD),
        .PCi(PC),
        .PCo(PCD),
        .PCplus4i(PC_plus4),
        .PCplus4o(PCplus4D),
        .stallD(stallD),
        .FlushD(FlushD) 
    );

    D2Eflop u_D2Eflop(
        .clk(clk),
        .RD1i(forward_rs1),
        .RD1o(RD1E),
        .RD2i(forward_rs2),
        .RD2o(RD2E),
        .Instri(InstrD),
        .Instro(InstrE),
        .rdi(InstrD[11:7]),
        .rdo(rdE),
        .PCi(PCD),
        .PCo(PCE),
        .ImmExti(ImmExt),
        .ImmExto(ImmExtE),
        .PCplus4i(PCplus4D),
        .PCplus4o(PCplusE),
        .RegWritei(RegWrite),
        .RegWriteo(RegWriteE),
        .ResultSrci(ResultSrc),
        .ResultSrco(ResultSrcE),
        .MemWritei(MemWrite),
        .MemWriteo(MemWriteE),
        .Jumpi(Jump),
        .Jumpo(JumpE),
        .Branchi(Branch),
        .Brancho(BranchE),
        .ALUControli(ALUControl),
        .ALUControlo(ALUControlE),
        .ALUSrcAi(ALUSrca),  
        .ALUSrcAo(ALUSrcAE),  
        .ALUSrcBi(ALUSrcb),  
        .ALUSrcBo(ALUSrcBE),
        .Rs1D(InstrD[19:15]),
        .Rs1E(Rs1E),
        .Rs2D(InstrD[24:20]),
        .Rs2E(Rs2E),
        .FlushE(FlushE)
    );


    E2Mflop u_E2Mflop(
        .clk(clk),
        .ALUResulti(ALUResult),
        .ALUResulto(ALUResultM),
        .WriteDatai(SrcB_a),
        .WriteDatao(WriteDataM),
        .Instri(InstrE),
        .Instro(InstrM),
        .rdi(rdE),
        .rdo(rdM),
        .PCplus4i(PCplusE),
        .PCplus4o(PCplusM),
        .RegWritei(RegWriteE),
        .RegWriteo(RegWriteM),
        .ResultSrci(ResultSrcE),
        .ResultSrco(ResultSrcM),
        .MemWritei(MemWriteE),
        .MemWriteo(MemWriteM)
    );  

    M2Wflop u_M2Wflop(
        .clk(clk),
        .ALUResulti(ALUResultM),
        .ALUResulto(ALUResultW),
        .Instri(InstrM),
        .Instro(InstrW),
        .RDi(ReadData),
        .RDo(ReadDataW),
        .rdi(rdM),
        .rdo(rdW),
        .PCplus4i(PCplusM),
        .PCplus4o(PCplusW),
        .RegWritei(RegWriteM),
        .RegWriteo(RegWriteW),
        .ResultSrci(ResultSrcM),
        .ResultSrco(ResultSrcW)
    );

    //decode stage

    extend u_Extend(
        .ImmSrc(ImmSrc),
        .in(InstrD[31:7]),
        .out(ImmExt)
    );
    
    reg_file_async rf (
        .clk        (clk),
        .clkb       (clk),
        .we         (RegWriteW),
        .ra1        (InstrD[19:15]),
        .ra2        (InstrD[24:20]),
        .wa         (rdW),
        .wd         (ResultW),
        .rd1        (rs1_data),
        .rd2        (rs2_data)
    );

    mux3 u_posforwardmux_1(
        .in0(rs1_data),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardAD),
        .out(forward_rs1)
    );

    mux3 u_posforwardmux_2(
        .in0(rs2_data),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardBD),
        .out(forward_rs2)
    );

    //execute region
    mux3 u_forwardemux_1(
        .in0(RD1E),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardAE),
        .out(Srca_a)
    );

    mux3 u_forwardemux_2(
        .in0(RD2E),
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardBE),
        .out(SrcB_a)
    );

    mux2 u_alu_mux2(
        .in0(SrcB_a),
        .in1(ImmExtE),
        .sel(ALUSrcBE),
        .out(SrcB)
    );

    mux3 u_alu_mux3(
        .in0(Srca_a),
        .in1(PCE),
        .in2(32'h0),
        .sel(ALUSrcAE),
        .out(SrcA)
    );

    alu u_ALU(
        .a_in(SrcA),
        .b_in(SrcB),
        .ALUControl(ALUControlE),
        .result(ALUResult),
        .aZ(Z_flag),
        .aN(N_flag),
        .aC(C_flag),
        .aV(V_flag)
    );

    branch_logic u_branch_logic(
        .N_flag(N_flag),
        .Z_flag(Z_flag),
        .C_flag(C_flag),
        .V_flag(V_flag),
        .Branch(BranchE),
        .funct3(InstrE[14:12]),
        .opcode(InstrE[6:0]),
        .Jump(JumpE),
        .PCsrc(PCsrcE)
    );

    //writeback region
    mux3 u_result_mux3(
        .in0(ALUResultW),
        .in1(BE_RD_2),
        .in2(PCplusW),
        .sel(ResultSrcW),
        .out(ResultW)
    );

    //memory region
    be_logic u_be_logic(
        .funct3(InstrM[14:12]),
        .ADDR_Last2(ALUResultM[1:0]),
        .WD(WriteDataM),
        .RD(ReadData),
        .BE_WD(WriteData),
        .BE_RD(BE_RD)
    );

    
    Hazard_unit u_Hazard_unit(
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .Rs1D(InstrD[19:15]),
        .Rs2D(InstrD[24:20]),
        .RdM(rdM),
        .RdW(rdW),
        .rdE(rdE),
        .ResultSrcE(ResultSrcE),  //opcode 
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RegWriteE(RegWriteE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD),
        .lwstall(lwstall),
        .stallD(stallD),
        .stallF(stallF),
        .FlushE(FlushE),
        .FlushD(FlushD),
        .PCSrc(PCsrcE)
    );
    

    // load 
    loadflop u_loadflop(
        .clk(clk),
        .n_rst(n_rst),
        .d(BE_RD),
        .q(BE_RD_2)
    );

endmodule
