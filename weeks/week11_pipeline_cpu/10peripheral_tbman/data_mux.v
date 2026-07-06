`timescale 1ns/1ps

module data_mux (
    // DATA MEM
    input           cs_dmem_n,
    input    [31:0]	read_data_dmem,

    // TBMAN
    input           cs_tbman_n,
    input    [31:0] read_data_tbman,

    output reg [31:0] read_data 
);

always@(*) begin
    if (!cs_dmem_n)
        read_data = read_data_dmem;
    else if (!cs_tbman_n)
        read_data = read_data_tbman;
    else
        read_data = 32'd0 ;
end

endmodule