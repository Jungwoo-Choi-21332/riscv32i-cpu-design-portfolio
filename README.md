# RV32I CPU Design Portfolio

RISC-V RV32I CPU 설계 프로젝트입니다. 어셈블리와 C 기반 ISA 이해부터 Verilog/SystemVerilog 모듈 설계, 단일 사이클 CPU, 5-stage pipeline CPU, hazard 처리, memory/peripheral 연동까지의 과정을 주차별 산출물과 최종 설계 코드로 정리했습니다.

## Project Summary

- Architecture: RISC-V RV32I
- Main HDL: SystemVerilog, Verilog
- Design flow: ISA 학습 -> assembly/C 실습 -> RTL building block -> single-cycle CPU -> pipelined CPU -> hazard/peripheral integration
- Main result: 5-stage pipelined RV32I CPU with forwarding, stall, flush, branch/jump PC control, byte-enable memory logic, TBMAN peripheral interface

## Repository Structure

```text
.
|-- final_project/                 # 최종 RV32I pipeline CPU RTL
|-- weeks/
|   |-- week04_assembly/           # Assembly 학습 정리
|   |-- week05_c_programming/      # C/toolchain 학습 정리
|   |-- week06_verilog_blocks/     # Verilog building block 및 명령어 확장 실습
|   |-- week07_single_cycle_cpu/   # Single-cycle RV32I CPU RTL/testbench
|   |-- week11_pipeline_cpu/       # Pipeline CPU 중간 revision
|   `-- week12_peripheral_timer/   # Timer/peripheral software test material
|-- docs/
|   |-- assignments/               # 주차별 과제 PDF
|   |-- presentations/             # 주차별 발표자료 및 최종 발표자료
|   `-- reports/                   # 중간보고서 및 hazard 정리
`-- assets/screenshots/            # 과제/실행 결과 이미지
```

## Final CPU Features

- 5-stage pipeline: IF, ID, EX, MEM, WB
- Pipeline registers: `F2Dflop`, `D2Eflop`, `E2Mflop`, `M2Wflop`
- Hazard unit:
  - EX/MEM, MEM/WB forwarding
  - load-use stall
  - branch/jump flush
- RV32I instruction support centered on:
  - R-type, I-type ALU, load/store
  - branch, `jal`, `jalr`
  - `lui`, `auipc`
  - CSR-related decode path
- Memory/peripheral integration:
  - synchronous dual-port RAM
  - byte-enable logic
  - TBMAN peripheral address decode and data mux

## Key Files

- `final_project/riscvpipelined.sv`: top-level pipelined CPU wrapper
- `final_project/datapath.sv`: pipeline datapath and forwarding paths
- `final_project/controller.sv`: main decode and ALU control connection
- `final_project/building_blocks/Hazard_unit.sv`: forwarding, stall, flush control
- `final_project/SMU_RV32I_System.v`: CPU, memory, and peripheral integrated system
- `weeks/week07_single_cycle_cpu/src/rtl/`: single-cycle CPU implementation

## Weekly Progress

| Week | Topic | Portfolio Artifact |
| --- | --- | --- |
| 04 | RV32I assembly and ISA basics | `docs/presentations/week04_assembly.pptx` |
| 05 | C language/toolchain and memory-level behavior | `docs/presentations/week05_c_programming.pptx` |
| 06 | Verilog building blocks and instruction expansion | `weeks/week06_verilog_blocks/` |
| 07 | Single-cycle RV32I CPU datapath/controller | `weeks/week07_single_cycle_cpu/` |
| 11 | Pipelined RV32I CPU and hazard handling | `weeks/week11_pipeline_cpu/` |
| 12 | Peripheral/timer test material | `weeks/week12_peripheral_timer/` |
| Final | Integrated pipelined RV32I CPU | `final_project/` |

## Simulation Notes

The original project was developed with Synopsys VCS/Verdi-style simulation files. Generated simulation output, waveform files, compiled binaries, private access files, and tokens are intentionally excluded from this portfolio repository.

Typical simulation entry points are kept where available:

- `weeks/week07_single_cycle_cpu/sim/func_sim/Makefile`
- `weeks/week07_single_cycle_cpu/sim/func_sim/run.f`

Tool paths and commercial simulator setup are environment-dependent, so this repository focuses on source readability and portfolio review.

## GitHub

Portfolio owner: [Jungwoo-Choi-21332](https://github.com/Jungwoo-Choi-21332)

Suggested repository name: `riscv32i-cpu-design-portfolio`

