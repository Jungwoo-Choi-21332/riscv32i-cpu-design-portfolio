module be_logic (
    input  [2:0] funct3,       // Function code (3 bits)
    input  [1:0] ADDR_Last2,        // Last 2 bits of address
    input  [31:0] WD,          // Write data
    input  [31:0] RD,          // Read data
    output reg [31:0] BE_WD,      // Write data output
    output reg [31:0] BE_RD       // Read data output
);

   always @(*) begin // load isa
    if (funct3 == 3'b010) begin // lw (load word)
        BE_RD = RD[31:0];
    end
    if (funct3 == 3'b000) begin  // lb
        if (ADDR_Last2 == 2'b00) 
            BE_RD = {{24{RD[7]}}, RD[7:0]};
        else if (ADDR_Last2 == 2'b01) 
            BE_RD = {{24{RD[15]}}, RD[15:8]};
        else if (ADDR_Last2 == 2'b10) 
            BE_RD = {{24{RD[23]}}, RD[23:16]};
        else if (ADDR_Last2 == 2'b11) 
            BE_RD = {{24{RD[31]}}, RD[31:24]};
        else 
            BE_RD = RD;
    end
    else if (funct3 == 3'b001) begin // lh
        if (ADDR_Last2 == 2'b00) 
            BE_RD = {{16{RD[15]}}, RD[15:0]};
        else if (ADDR_Last2 == 2'b10) 
            BE_RD = {{16{RD[31]}}, RD[31:16]};
        else 
            BE_RD = RD;
    end
    else if (funct3 == 3'b100) begin // lbu
        if (ADDR_Last2 == 2'b00) 
            BE_RD = {24'b0, RD[7:0]};
        else if (ADDR_Last2 == 2'b01) 
            BE_RD = {24'b0, RD[15:8]};
        else if (ADDR_Last2 == 2'b10) 
            BE_RD = {24'b0, RD[23:16]};
        else if (ADDR_Last2 == 2'b11) 
            BE_RD = {24'b0, RD[31:24]};
        else 
            BE_RD = RD;
    end
    else if (funct3 == 3'b101) begin // lhu
        if (ADDR_Last2 == 2'b00) 
            BE_RD = {16'b0, RD[15:0]};
        else if (ADDR_Last2 == 2'b10) 
            BE_RD = {16'b0, RD[31:16]};
        else 
            BE_RD = RD;
    end
    else
        BE_RD = RD;
end

always @(*) begin
    if (funct3 == 3'b000) begin 
        case(ADDR_Last2)
                2'b00:BE_WD = {24'b0,WD[7:0]};
                2'b01:BE_WD = {16'b0,WD[7:0],8'b0};
                2'b10:BE_WD = {8'b0,WD[7:0],16'b0};
                2'b11:BE_WD = {WD[7:0],24'b0};
                default :BE_WD = {24'b0,WD[7:0]};
        endcase  
    end
    else if (funct3 == 3'b001) begin 
        case(ADDR_Last2)
                2'b00:BE_WD = {16'b0, WD[15:0]};
                2'b10:BE_WD = {WD[15:0],16'b0};
                default :BE_WD = {16'b0, WD[15:0]};
        endcase    
    end
    else begin  
        BE_WD = WD;  
    end
end


endmodule
