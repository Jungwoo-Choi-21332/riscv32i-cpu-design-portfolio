module branch_logic(
    N_flag,
    Z_flag,
    C_flag,
    V_flag,
    funct3,
    PCsrc,
    Branch,
    opcode,
    Jump
);

input N_flag,Z_flag,C_flag,V_flag, Branch;
input [2:0]funct3;
input Jump;
input [6:0]opcode;
output reg [1:0] PCsrc;

always @(*) begin
    if(opcode == 7'b1100111)
        PCsrc = 2'b10;
    else if (funct3 == 3'b000) begin
        PCsrc = {1'b0,(Branch && Z_flag) || Jump};  // BEQ
    end
    else if (funct3 == 3'b001) begin
        PCsrc = {1'b0,(Branch && ~Z_flag) || Jump};  // BNE
    end
    else if (funct3 == 3'b100) begin
        PCsrc = {1'b0,(Branch && (~N_flag == V_flag)) || Jump} ;  // BLT
    end
    else if (funct3 == 3'b110) begin
        PCsrc = {1'b0,(Branch && (C_flag == 1'b0)) || Jump} ;  // BLTU
    end
    else if (funct3 == 3'b111) begin
        PCsrc = {1'b0,(Branch && (C_flag == 1'b1)) || Jump};  // BGEU
    end
    else if (funct3 == 3'b101) begin
        PCsrc = {1'b0,(Branch && (N_flag == V_flag)) || Jump};  // BGE
    end
    else begin
        PCsrc = 2'b00;  // Default
    end
end

endmodule