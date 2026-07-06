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
            BE_RD = {{24{RD[7]}}, RD[7:0]};
    end
    else if (funct3 == 3'b001) begin // lh
        if (ADDR_Last2 == 2'b00) 
            BE_RD = {{16{RD[15]}}, RD[15:0]};
        else if (ADDR_Last2 == 2'b10) 
            BE_RD = {{16{RD[31]}}, RD[31:16]};
        else 
            BE_RD = {{16{RD[15]}}, RD[15:0]};
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
            BE_RD = {24'b0, RD[7:0]};
    end
    else if (funct3 == 3'b101) begin // lhu
        if (ADDR_Last2 == 2'b00) 
            BE_RD = {16'b0, RD[15:0]};
        else if (ADDR_Last2 == 2'b10) 
            BE_RD = {16'b0, RD[31:16]};
        else 
            BE_RD = {16'b0, RD[15:0]};
    end
    else
        BE_RD = RD;
end

always @(*) begin  //store isa
    if (funct3 == 3'b000) begin    //sb
        if (ADDR_Last2 == 2'b00) begin
            BE_WD = {RD[31:8], WD[7:0]};
        end
        else if (ADDR_Last2 == 2'b01) begin
            BE_WD = {RD[31:16], WD[7:0], RD[7:0]};
        end
        else if (ADDR_Last2 == 2'b10) begin
            BE_WD = {RD[31:24], WD[7:0], RD[15:0]};
        end
        else if (ADDR_Last2 == 2'b11) begin
            BE_WD = {WD[7:0],RD[23:0]};
        end
        else begin
            BE_WD = {RD[31:8], WD[7:0]};
        end
    end
    else if (funct3 == 3'b001) begin    //sh
        if (ADDR_Last2 == 2'b00) begin
            BE_WD = {RD[31:16], WD[15:0]};
        end
        else if (ADDR_Last2 == 2'b10) begin
            BE_WD = {WD[15:0], RD[15:0]};
        end
        else begin
            BE_WD = {RD[31:16], WD[15:0]};
        end
    end
    else begin  
        BE_WD = WD;  
    end
end


endmodule
