# This repo is to track Hardware Description Language projects

- Status of each project will be listed below
- To-Do list of projects will be listed below

## Status:
- 20240904 -> [Traffic Light Control](/Traffic_Light_Control/README.md)
    - RTL Done + Verified Ok
- 20240828 -> [Digital Timer](/Digital_Timer/README.md)
    - RTL Done + Verified Ok 
- 20240822 -> [RISC Processor](/RISC_processor/README.md)
    - RTL Done + Compile Ok (More function check needed - Improve TB) [Defeatured]
- 20240810 -> [FIFO Memory](/FIFO_Mem/README.md)
    - RTL Done + Verified Ok
- 20240810 -> [16-bit Single-Cycle MIPS Processor](/MIPS_Processor/README.md)
    - RTL Done + Compile Ok (More function check needed - Improve TB) [Defeatured]
- 20240813 -> [Programmable Digital Delay Timer](/Program_Delay_Timer/README.md)
    - RTL Done + Verified Ok

## To-Do:
- 32-bit Unsigned Divider
- Fixed-point Matrix Multiplication
- Carry-look-ahead Multiplier
- 4x4 Multiplier
- Simple Microcontroller

## Setup:
- Linter      - Verible
- Style-Check - Verible
- Simulator   - ModelSim (TerosHDL) / Vivado
- Waveform    - GTKWave  (TerosHDL)
- Synthesis   - Vivado   (TerosHDL)

## Reference:
- https://www.fpga4student.com/p/verilog-project.html

## Note:
- VCD dump path is C:/Users/{user_name}/.teroshdl/build

## Future Works:
- Raptor + TerosHDL integration
- Setup UVM TB to test designs more extensively
- Run Vivado Synthesis to check for warnings/errors that can occur
