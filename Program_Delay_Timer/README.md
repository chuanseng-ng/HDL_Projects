# This repo is to track Programmable Digital Delay Timer project
- Spec is listed below
- Status is listed below
- Changelist is listed below

## Spec:
<ul>
   <li>Digital delay timer designed is CMOS IC LS7212, which is used to generate programmable delays</li>
   <li>Delay timer has 4 operating modes:</li>
      <ul>
         <li>One-shot (OS)</li>
         <li>Delayed Operate (DO)</li>
         <li>Delayed Release (DR)</li>
         <li>Dual Delay (DD)</li>
      </ul>
   <br>
   <li>The 4 modes will be selected by inputs mode_a & mode_b:</li>

   | mode_a | mode_b | Mode            |
   | :----: | :----: | :-------------: |
   |   0    |    0   | One-shot        |
   |   0    |    1   | Delayed Operate |
   |   1    |    0   | Delayed Release |
   |   1    |    1   | Dual Delay      |

   <li>weighted_bits[WEIGHT_BIT_WIDTH-1:0] is to program the delays according to the given equation in the delay timer specification</li>
   <li>WEIGHT_BIT_SIZE is a parameter that can be controlled/defined during instantiation, default value = 8
</ul>

## Status:
- 20240812 - V1 release
- 20240812 - Init DB

## Changelist:
- 20240812 - Compile fix
- 20240812 - V1 release

## To-Do:
- Add stimulus for delay_mode = 01/10/11 + Check in waveform for simulation results

## Reference:
- https://www.datasheetcatalog.com/datasheets_pdf/L/S/7/2/LS7212.shtml
- https://www.fpga4student.com/2017/01/programmable-digital-delay-timer-in-Verilog.html