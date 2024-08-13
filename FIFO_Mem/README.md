# This repo is to track FIFO memory project
- Spec is listed below
- Status is listed below
- Changelist is listed below

## Spec:
<ul>
   <li> FIFO memory accepts DATA_WIDTH parameter (Data width can be configured - Default is 32 bits)</li>
   <li> Size of FIFO memory can be configured with OSTD_NUM (Outstanding number can be configured - Default is 4)</li>
      <ul>
         <li>Width of read/write pointer is taken to be log2(OSTD_NUM) unless OSTD_NUM == 0 then pointer width = 1</li>
      </ul>

   <li> Monitoring signals include the following:</li>
      <ul>
         <li>Full      - High when FIFO is full</li>
         <li>Empty     - High when FIFO is empty</li>
         <li>Overflow  - High when FIFO is full & transaction is still writing to FIFO (Might be redundant)</li>
         <li>Underflow - High when FIFO is empty & transaction is reading from FIFO (Might be redundant)</li>
         <li>Threshold - High when number of data in FIFO is lesser than threshold value (Might be redundant)</li>
      </ul>
      
   <li> Operation:</li>
      <ul>
         <li>Write operation will take 1 clock cycle to be stored in FIFO memory array</li>
         <li>Read operation from FIFO memory array is instantly done (Will take 0 clock cycles)</li>
         <li>Read/Write pointer size == max value of outstanding transaction</li>
      </ul>
</ul>

## Status:
- 20240807 - Debug TB not incrementing beyond addr = 4 (Fixed FIFO size & read/write pointer unable to increment)
- 20240807 - V1 release
- 20240807 - Init DB

## Changelist:
- 20240810 - Style-checker & Linter fix
- 20240807 - Bug fix for FIFO size
- 20240807 - Compile fix
- 20240807 - V1 release

## To-Do:
<br>

## Reference:
- https://www.fpga4student.com/2017/01/verilog-code-for-fifo-memory.html