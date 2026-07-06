module maindec(
    Z_flag,
    funct3,
    opcode,
    PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrca,
    ALUSrcb,
    ImmSrc,
    RegWrite,
    Jump,
    ALUop,
    N_flag,
    C_flag,
    V_flag
);
    // input
    input Z_flag,N_flag,V_flag,C_flag;
    input [2:0] funct3;
    input [6:0] opcode;
    // output
    output reg [1:0] PCSrc;
    output reg MemWrite, ALUSrcb, RegWrite, Jump;
    output reg [1:0] ALUSrca;
    output reg [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output reg [1:0] ALUop;

    reg Branch;

    always @(*) begin
     if (opcode == 7'b110_0011) begin
        if (funct3 == 3'b000) begin
            PCSrc = {1'b0, (Branch & Z_flag) | Jump};  // BEQ
        end
        else if (funct3 == 3'b001) begin
            PCSrc = {1'b0, (Branch & ~Z_flag) | Jump};  // BNE
        end
        else if (funct3 == 3'b100) begin
            PCSrc = {1'b0, (Branch & (~N_flag == V_flag)) | Jump};  // BLT
        end
        else if (funct3 == 3'b110) begin
            PCSrc = {1'b0, (Branch & (C_flag == 1'b0)) | Jump};  // BLTU
        end
        else if (funct3 == 3'b111) begin
            PCSrc = {1'b0, (Branch & (C_flag == 1'b1)) | Jump};  // BGEU
        end
        else if (funct3 == 3'b101) begin
            PCSrc = {1'b0, (Branch & ((N_flag == V_flag) & (~Z_flag))) | Jump};  // BGE
        end
        else begin
            PCSrc = 2'b00;  // Default for opcode 7'b110_0011
        end
     end
     else if (opcode == 7'b110_0111) begin
        PCSrc = 2'b10;  // JALR
     end
     else if (opcode == 7'b110_1111) begin
        PCSrc = 2'b01;  // JAL
     end
     else begin
        PCSrc = 2'b00;  // Default
     end
    end

    always@(*) begin    // main decoder  | bit aassignment 1_3_2_1_1_2_1_2_1
        case(opcode)
            7'b000_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_01_0_00_0;     // lw
            7'b010_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b0_001_00_1_1_0X_0_00_0;     // sw
            7'b011_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1x_xx00_0000_0100;     // R-type
            7'b110_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b00_1000_0000_1010;     // branch
            7'b001_0011 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_0000_1000_0100;     // I-type ALU
            7'b011_0111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0010_1000_0000;     // lui
            7'b001_0111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b11_0001_1000_0000;     // auipc
            7'b110_1111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b10_1100_x010_0xx1;     // jal
            7'b110_0111 : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_10_0_10_1;     // jalr 
            default : {RegWrite, ImmSrc,ALUSrca, ALUSrcb, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'bx;
        endcase
    end

endmodule
