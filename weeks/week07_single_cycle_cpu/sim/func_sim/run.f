./sim_define.v

+incdir+../../src/rtl/building_blocks/
../../src/rtl/building_blocks/adder.sv
../../src/rtl/building_blocks/be_logic.sv
../../src/rtl/building_blocks/extend.sv
../../src/rtl/building_blocks/flopenr.sv
../../src/rtl/building_blocks/flopr.sv
../../src/rtl/building_blocks/mux2.sv
../../src/rtl/building_blocks/mux3.sv

+incdir+../../src/rtl/
../../src/rtl/alu.sv

../../src/rtl/aludec.sv
../../src/rtl/maindec.sv

// Register File
../../src/rtl/reg_file_async.v

// Memory
../../model/ASYNC_RAM_DP_WBE.v

../../src/rtl/controller.sv
../../src/rtl/datapath.sv

../../src/rtl/riscvsingle.sv

../../src/rtl/SMU_RV32I_System.v

+incdir+../../bench/rtl/
../../testbench/cpu_tb.v
