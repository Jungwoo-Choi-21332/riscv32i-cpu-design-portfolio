module be_logic (
    input logic [31:0] Addr,        // Address input
    input logic [2:0] funct3,       // Function code (3 bits)
    input logic [1:0] Last2,        // Last 2 bits of address
    input logic [31:0] WD,          // Write data
    input logic RD,                 // Read enable
    input logic WR,                 // Write enable
    output logic [31:0] BE_WD,      // Write data output
    output logic [31:0] BE_RD       // Read data output
);

    logic [31:0] memory[0:255];     
    logic [31:0] read_data;
    
    always_ff @(posedge WR or posedge RD) begin
        if (WR) begin
            case (funct3)
                3'b000: memory[Addr] <= WD;       
            endcase
        end else if (RD) begin
            case (funct3)
                3'b000: read_data <= memory[Addr]; 
            endcase
        end
    end

    assign BE_WD = (WR) ? WD : 32'bx;
    assign BE_RD = (RD) ? read_data : 32'bx;

endmodule
