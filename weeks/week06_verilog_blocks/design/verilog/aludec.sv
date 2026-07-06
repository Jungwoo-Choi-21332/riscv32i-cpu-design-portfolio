module aludec(
    opcode,
    funct3,
    funct7,
    ALUop,
    ALUControl
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input [1:0] ALUop;
    input funct7;
    // output
    output reg [2:0] ALUControl;

    always@(*)begin                // ALU decoder
        if(ALUop == 2'b00)
            ALUControl = 3'b000;                                                                                                     // lw, sw
        else if(ALUop == 2'b01)
            ALUControl = 3'b001;                                                                                                     // beq & bne
        else if(ALUop == 2'b10) begin
            if (funct3 == 3'b000 && ({opcode[5], funct7} == 2'b00 || {opcode[5], funct7} == 2'b01 || {opcode[5], funct7} == 2'b10))  // add
                ALUControl = 3'b000;
            else if (funct3 == 3'b000 && {opcode[5], funct7} == 2'b11)																 // sub
                ALUControl = 3'b001;
            else if (funct3 == 3'b010)																								 // slt
                ALUControl = 3'b101;
            else if (funct3 == 3'b110)																								 // or
                ALUControl = 3'b011;
            else if (funct3 == 3'b111)																							     // and
                ALUControl = 3'b010;
            else if (funct3 == 3'b100)																							     // xor
                ALUControl = 3'b100;
            else if (funct3 == 3'b001)														            // SLL
                ALUControl = 3'b110;
            else if (funct3 == 3'b101)  														        // SRL
                ALUControl = 3'b111;
        else 
                ALUControl = 3'hx;
        end
    end
        

endmodule
