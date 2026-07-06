module alu(
    a_in,
    b_in,
    ALUControl,
    result,
    aZ,
    aN,
    aC,
    aV
);
    input [31:0] a_in, b_in;
    input [4:0] ALUControl;
    output reg [31:0] result; 
    output reg aZ;

    output reg aN, aC, aV;           // FLAG 
    wire  N, Z, C, V;
    wire [31:0] add_sub_b;
    wire [31:0] adder_result, and_result, or_result, SLT_result, xor_result, SLL_result,SRL_result,SRA_result,Branch_result,SLTU_result;

    assign add_sub_b = (ALUControl == 5'b00001 || ALUControl == 5'b00101) ? ~b_in + 32'h1 : b_in;

    assign xor_result = a_in ^ b_in;
    assign and_result = a_in & b_in;
    assign or_result = a_in | b_in;
    assign SLT_result = aN ^ aV;
    assign SLTU_result = (a_in < b_in)? 1'b1 : 1'b0;
    assign SRL_result = a_in >> b_in[4:0]; 
    assign SLL_result = a_in << b_in[4:0];
    assign SRA_result = (a_in[31] == 1) ? ((a_in >> b_in[4:0]) | ~(32'hFFFF_FFFF >> b_in[4:0])) : (a_in >> b_in[4:0]);

    adder u_add_32bit_add(
        .a(a_in),
        .b(add_sub_b),
        .ci(1'b0),
        .sum(adder_result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );    
    
    always@(*)begin
        if (ALUControl == 5'b00000 || ALUControl == 5'b00101) begin
            {aN, aZ, aC, aV} = {N, Z, C, V};
        end
        else if (ALUControl == 5'b00001) begin
            aN = adder_result[31];
            aZ = (adder_result == 32'h0) ? 1'b1 : 1'b0;
            aC = (a_in >= b_in)? 1'b1 : 1'b0; 
            aV = V;
        end
        else if (ALUControl == 5'b00010) begin
            aN = and_result[31];
            aZ = (and_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b00011) begin
            aN = or_result[31];
            aZ = (or_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else begin
            {aN, aZ, aC, aV} = 4'h0;	
        end
    end

    always@(*) begin
        case(ALUControl)
            5'b00000 : result = adder_result;        // add
            5'b00001 : result = adder_result;        // sub
            5'b00010 : result = and_result;          // and
            5'b00011 : result = or_result;           // or
            5'b00100 : result = xor_result;          // xor
            5'b00101 : result = SLT_result;          // SLT
            5'b00110 : result = SLL_result;          // SLL  
            5'b00111 : result = SRL_result;          // SRL
            5'b01000 : result = SRA_result;          // SRA
            5'b10000 : result = SLTU_result;          // SRA
            default : result = 32'hx;
        endcase
    end

endmodule
