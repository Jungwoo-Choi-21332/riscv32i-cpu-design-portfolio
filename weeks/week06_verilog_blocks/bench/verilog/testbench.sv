module testbench();
  logic clk;
  logic reset;
  logic [31:0] WriteData, DataAdr, PC, ReadData;
  logic MemWrite;

  // instantiate device to be tested
  top dut(
      .clk(clk), 
	  .n_rst(reset), 
	  .WriteData(WriteData), 
	  .DataAdr(DataAdr), 
	  .PC(PC),
	  .ReadData(ReadData),
	  .MemWrite(MemWrite)
	  );

  // initialize test
  initial
  begin
    reset = 1'b1;
    #15;
    reset = 1'b0;
  end

  // generate clock to sequence tests
  always
  begin
    #5 clk = 1'b1;
    #5 clk = 1'b0;
  end

  always @(negedge clk)
  begin
	  if(PC == 32'h10) begin
		$display("[INFO]Simulation failed !!!!!!!!!");
        $finish;
	  end		
	  else if(PC == 32'h2c) begin
		if (MemWrite != 1 || WriteData != 32'h14 || DataAdr != 32'h2004) begin
			$display("[INFO]Simulation failed !!!!!!!!!");
			$finish;
		end
	  end		
	  else if(PC == 32'h30) begin
		if (MemWrite != 1 || WriteData != 32'h3803 || DataAdr != 32'h2008) begin
			$display("[INFO]Simulation failed !!!!!!!!!");
			$finish;
		end
	  end
	  else if(PC == 32'h34) begin
		if (ReadData != 32'h14) begin
			$display("[INFO]Simulation failed !!!!!!!!!");
			$finish;
		end
	  end
	  else if(PC == 32'h38) begin
		if (ReadData != 32'h3803) begin
			$display("[INFO]Simulation failed !!!!!!!!!");
			$finish;
		end
	  end
	  else if(PC == 32'h40) begin
		$display("[INFO]Simulation failed !!!!!!!!!");
        $finish;
	  end		
	  else if(PC == 32'h50) begin
		$display("[INFO]Simulation failed !!!!!!!!!");
        $finish;
	  end		
	  else if(PC == 32'h60) begin
		$display("[INFO]Simulation failed !!!!!!!!!");
        $finish;
	  end		
	  else if(PC == 32'h68) begin
		if (MemWrite != 1 || WriteData != 32'h18 || DataAdr != 32'h200c) begin
			$display("[INFO]Simulation failed !!!!!!!!!");
			$finish;
		end
		else begin
			$display("[INFO]Simulation succeeded !!!!!!!!!");
			$finish;
		end
	  end
  end

`ifdef SIM
  initial
    begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars(0);
  end

`endif

endmodule
