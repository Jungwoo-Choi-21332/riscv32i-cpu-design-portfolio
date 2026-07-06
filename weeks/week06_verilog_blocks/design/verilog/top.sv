module top (
    clk,
    n_rst,
    WriteData,
    DataAdr,
    PC,
    ReadData,
    Instr,
    MemWrite
);

    input clk, n_rst;
    output [31:0] WriteData, DataAdr;
    output MemWrite;

    input wire [31:0] PC, Instr, ReadData;

    riscvsingle rvsingle(
        .clk(clk),
        .n_rst(n_rst),
        .PC(PC),
        .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(DataAdr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    imem imem(
        .a(PC), 
        .rd(Instr)
    );

    dmem dmem(
        .clk(clk),
        .wen0(MemWrite),
        .addr0(DataAdr),
        .d0(WriteData),
        .q0(ReadData)
    );

endmodule
