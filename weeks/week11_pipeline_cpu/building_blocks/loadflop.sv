module loadflop(
	clk,
	n_rst,
	d,
	q
);
	input clk, n_rst;
	input [31:0] d;
	output reg [31:0] q;	

	always@(posedge clk or negedge n_rst) begin 
		if(!n_rst) begin
			q <= 32'b0;
		end
		else begin
			q <= d;
		end		
	end

endmodule
