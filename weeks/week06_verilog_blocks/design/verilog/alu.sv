module alu(
    a_in,
    b_in,
    ALUControl,
    result,
    aZ
);
    input [31:0] a_in, b_in;
    input [2:0] ALUControl;
    output reg [31:0] result; 
    output reg aZ;

    reg aN, aC, aV;           // FLAG 
    wire N, Z, C, V;
    wire [31:0] add_sub_b;
    wire [31:0] adder_result, and_result, or_result, SLT_result, xor_result, SLL_result,SRL_result;

    assign add_sub_b = (ALUControl == 3'b001 || ALUControl == 3'b101) ? ~b_in + 32'h1 : b_in;

    assign xor_result = a_in ^ b_in;
    assign and_result = a_in & b_in;
    assign or_result = a_in | b_in;
    assign SLT_result = aN ^ aV;
    assign SRL_result = a_in >> b_in; 
    assign SLL_result = a_in << b_in;

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
        if (ALUControl == 3'b000 || ALUControl == 3'b001 || ALUControl == 3'b101) begin
            {aN, aZ, aC, aV} = {N, Z, C, V};
        end
        else if (ALUControl == 3'b010) begin
            aN = and_result[31];
            aZ = (and_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 3'b011) begin
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
            3'b000 : result = adder_result;        // add
            3'b001 : result = adder_result;        // sub
            3'b010 : result = and_result;          // and
            3'b011 : result = or_result;           // or
            3'b100 : result = xor_result;          // xor
            3'b101 : result = SLT_result;          // SLT
            3'b110 : result = SLL_result;          // SLL  
            3'b111 : result = SRL_result;          // SRL
            default : result = 32'hx;
        endcase
    end

endmodule
