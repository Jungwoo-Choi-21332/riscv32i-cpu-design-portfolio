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
    output reg [4:0] ALUControl;

    always@(*)begin                // ALU decoder
        if(ALUop == 2'b00)begin  // load & store
            ALUControl = 5'b00000;  
        end
        else if(ALUop == 2'b01)begin
            if (funct3 == 3'b001 || funct3 == 3'b000)
                ALUControl = 5'b00001;                                                                                               // beq & bne
            else if (funct3 == 3'b100 || funct3 == 3'b110 || funct3 == 3'b111 || funct3 == 3'b101)                                   //another b-type
                ALUControl = 5'b00001;
            else 
                ALUControl = 5'b00001;
        end
        else if(ALUop == 2'b10) begin
            if (funct3 == 3'b000 && ({opcode[5], funct7} == 2'b00 || {opcode[5], funct7} == 2'b01 || {opcode[5], funct7} == 2'b10))  // add
                ALUControl = 5'b00000;
            else if (funct3 == 3'b000 && {opcode[5], funct7} == 2'b11)																 // sub
                ALUControl = 5'b00001;
            else if (funct3 == 3'b010)																								 // slt
                ALUControl = 5'b00101;
            else if (funct3 == 3'b110)																								 // or
                ALUControl = 5'b00011;
            else if (funct3 == 3'b111)																							     // and
                ALUControl = 5'b00010;
            else if (funct3 == 3'b100)																							     // xor
                ALUControl = 5'b00100;
            else if (funct3 == 3'b001)														            // SLL  &  SLLI
                ALUControl = 5'b00110;
            else if (funct3 == 3'b101)  														        // SRL  &  SRA
                ALUControl = (funct7 == 1'b1)? 5'b01000 :5'b00111;
            else if (funct3 == 3'b011)																							     // xor
                ALUControl = 5'b10000;
            else 
                ALUControl = 5'hx;
        end
        else if (ALUop == 2'b11)begin
            ALUControl = 5'b00000;
        end
        else 
            ALUControl = 5'hx;
    end
        

endmodule
