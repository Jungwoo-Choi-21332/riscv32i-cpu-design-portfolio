module flopr(
	clk,
	n_rst,
	d,
	q,
	stallF
);

    parameter RESET_VALUE = 32'h1000_0000;

	input clk, n_rst;
	input [31:0] d;
	input stallF;
	output reg [31:0] q;	

	always@(posedge clk or negedge n_rst) begin 
		if(!n_rst) begin
			q <= RESET_VALUE;
		end
		else if (stallF)begin
			q <= q;
		end
		else begin
			q <= d;
		end		
	end

endmodule
