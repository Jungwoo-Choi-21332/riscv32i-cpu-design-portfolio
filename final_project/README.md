# Final Project: RV32I Pipelined CPU

최종 프로젝트 RTL입니다. 단일 사이클 구조에서 출발해 5-stage pipeline 구조로 확장하고, pipeline register와 hazard control을 추가했습니다.

## Main Modules

- `riscvpipelined.sv`: controller와 datapath를 연결하는 pipelined CPU top
- `datapath.sv`: IF/ID/EX/MEM/WB stage 데이터 경로
- `controller.sv`, `maindec.sv`, `aludec.sv`: opcode/funct 기반 제어 신호 생성
- `building_blocks/Hazard_unit.sv`: forwarding, load-use stall, branch/jump flush
- `SMU_RV32I_System.v`: CPU, memory, TBMAN peripheral 통합
- `SYNC_RAM_DP_WBE.v`: byte-enable 지원 synchronous dual-port RAM

## Design Focus

- Pipeline register 분리로 stage별 제어 신호 전달
- `ForwardAE`, `ForwardBE`, `ForwardAD`, `ForwardBD`를 통한 data hazard 완화
- load-use hazard에서 PC/IF-ID stall 및 ID-EX flush 처리
- branch/jump 발생 시 잘못 가져온 instruction flush
- memory mapped peripheral 접근을 위한 address decode/data mux 구성

