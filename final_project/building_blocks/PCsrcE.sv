module PCsrcE(
    opcode,
    Btaken,
    PCSrc
);

input [6:0]opcode;
input Btaken;
output reg [1:0]PCSrc;

always @(*) begin
    if (opcode == 7'b110_0111) begin
        PCSrc = 2'b10;  // JALR
    end
    else if (Btaken == 1'b1) begin
        PCSrc = 2'b01;
    end 
    else begin
        PCSrc = 2'b00;  // Default
     end
    end

endmodule