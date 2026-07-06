module extend(
    ImmSrc,
    in,
    out
);
    input [1:0] ImmSrc;
    input [24:0] in;     // from instruction[31:7]
    output reg [31:0] out;

    // ImmSrc 00 = I-type
    // ImmSrc 01 = S-type
    // ImmSrc 10 = B-type
    // ImmSrc 11 = J-type

    always@(*) begin
        if (ImmSrc == 2'b00)                                         // I-type
            out = {{20{in[24]}}, in[24:13]};		 
        else if (ImmSrc == 2'b01)                                    // S-type
            out = {{20{in[24]}}, in[24:18], in[4:0]};		
        else if (ImmSrc == 2'b10)                                    // B-type	
            out = {{20{in[24]}}, in[0], in[23:18], in[4:1], 1'b0};	 
        else if (ImmSrc == 2'b11)                                    // J-type
            out = {{12{in[24]}}, in[12:5], in[13], in[23:14], 1'b0};   	
        else
            out = 24'hx;
    end

endmodule
