# This repo is to track 16-bit Single-Cycle MIPS CPU project
- Spec is listed below
- Status is listed below
- Changelist is listed below

## Spec:
<ul>
<li>16-bit MIPS processor that takes in clock & inverted reset as input and return ALU result & program_counter as output</li>
   <ul>
      <li>Design uses parameter to control bit-width declaration - Larger bit-width is possible with some modification
   </ul>
   
<li>Instruction Format:</li>
   
   |    Name    |        |        | Fields |        |            |               Comments             |
   | :--------: | :----: | :----: | :----: | :----: | :------:   | :--------------------------------: | 
   | Field Size | 3 bits | 3 bits | 3 bits | 3 bits |  4 bits    | All MIPS-L instructions 16 bits    |
   |  R-format  |   op   |   rs   |   rt   |   rd   |   funct    | Arithmetic instruction format      |
   |  I-format  |   op   |   rs   |   rt   | Address/immediate | | Transfer, branch, immediate format |
   |  J-format  |   op   |        |    | target address |        | Jump instruction format            |
   
<li>Instruction Set Architecture:</li>
   
   | Name | Format |        |        |  Example |      |        | Comments       |
   | :--: | :----: | :----: | :----: | :----: | :----: | :----: | :------------: |
   |      |        | 3 bits | 3 bits | 3 bits | 3 bits | 4 bits |                |
   | add  |    R   |    0   |    2   |    3   |    1   |    0   | add $1, $2, $3 |
   | sub  |    R   |    0   |    2   |    3   |    1   |    1   | sub $1, $2, $3 |
   | and  |    R   |    0   |    2   |    3   |    1   |    2   | and $1, $2, $3 |
   |  or  |    R   |    0   |    2   |    3   |    1   |    3   | or $1, $2, $3  |
   | slt  |    R   |    0   |    2   |    3   |    1   |    4   | slt $1, $2, $3 |
   |  jr  |    R   |    0   |    7   |    0   |    0   |    8   | jr $7          |
   |  lw  |    I   |    4   |    2   |    1   |    7   |    7   | lw $1, 7, ($2) |
   |  sw  |    I   |    5   |    2   |    1   |    7   |    7   | sw $1, 7, ($2) |
   | beq  |    I   |    6   |    1   |    2   |    7   |    7   | beq $1, $2, 7  |
   | addi |    I   |    7   |    2   |    1   |    7   |    7   | addi $1, $2, 7 |
   |  j   |    J   |    2   |   500  |   500  |   500  |   500  | j 1000         |
   | jal  |    J   |    3   |   500  |   500  |   500  |   500  | jal 1000       |
   | slti |    I   |    1   |    2   |    1   |    7   |    7   | slti $1, $2, 7 |
   
<li>Description:</li>
   <ul>
      <li>Add      - R[rd] = R[rs] + R[rt]</li>
      <li>Subtract - R[rd] = R[rs] - R[rt]</li>
      <li>And      - R[rd] = R[rs] & R[rt]</li>
      <li>Or       - R[rd] = R[rs] | R[rt]</li>
      <li>SLT      - R[rd] = 1 if R[rs] < R[rt] else 0</li>
      <li>Jr       - PC = R[rs]</li>
      <li>Lw       - R[rt] = M[R[rs] + SignExtImm]</li>
      <li>Sw       - M[R[rs] + SignExtImm] = R[rt]</li>
      <li>Beq      - if (R[rs] == R[rt]) PC = PC + 1 + BranchAddr</li>
      <li>Addi     - R[rt] = R[rs] + SignExtImm</li>
      <li>J        - PC = JumpAddr</li>
      <li>Jal      - R[7] = PC + 2; PC = JumpAddr</li>
      <li>SLTI     - R[rt] = 1 if R[rs] < imm else 0</li>
      <ul></li>
         <li>SignExtImm = {9{immediate[6]}}, imm</li>
         <li>JumpAddr = {(PC + 1)[15:13], address}</li>
         <li>BranchAddr = {7{immediate[6]}, immediate, 1'b0}</li>
      </ul>
   </ul>
   
<li>Control Unit Design:</li>
   <ul>
      <li>Control Signal -</li>
         
   | Instruction | Req Dst | ALU Src | Memto Reg | Reg Write | MemRead | MemWrite | Branch | ALUOp | Jump |
   | :---------: | :-----: | :-----: | :-------: | :-------: | :-----: | :------: | :----: | :---: | :--: |
   |    R-type   |    1    |    0    |      0    |     1     |    0    |     0    |    0   |   00  |   0  |
   |      LW     |    0    |    1    |      1    |     1     |    1    |     0    |    0   |   11  |   0  |
   |      SW     |    0    |    1    |      0    |     0     |    0    |     1    |    0   |   11  |   0  |
   |     addi    |    0    |    1    |      0    |     1     |    0    |     0    |    0   |   11  |   0  |
   |      beq    |    0    |    0    |      0    |     0     |    0    |     0    |    1   |   01  |   0  |
   |       j     |    0    |    0    |      0    |     0     |    0    |     0    |    0   |   00  |   1  |
   |      jal    |    2    |    0    |      2    |     1     |    0    |     0    |    0   |   00  |   1  |
   |     slti    |    0    |    1    |      0    |     1     |    0    |     0    |    0   |   10  |   0  |

   </ul>
   <ul>
      <li>ALU Control -</li>
   
   | ALUop | Function | ALUcnt | ALU Operation | Instruction  |
   | :---: | :------: | :----: | :-----------: | :----------: |
   |   11  |   xxxx   |   000  |      ADD      | addi, lw, sw |
   |   01  |   xxxx   |   001  |      SUB      |     BEQ      |
   |   00  |    00    |   000  |      ADD      | R-type: ADD  |
   |   00  |    01    |   001  |      SUB      | R-type: sub  |
   |   00  |    02    |   010  |      AND      | R-type: AND  |
   |   00  |    03    |   011  |       OR      | R-type: OR   |
   |   00  |    04    |   100  |      slt      | R-type: slt  |
   |   10  |   xxxx   |   100  |      slt      | I-type: slti |
   
   </ul>
</ul>

## Status:
- 20240822 - Bug fix - X-propagation issue with most signals in design
- 20240808 - V1 release
- 20240807 - Init DB

## Changelist:
- 20240822 - Bug fix
- 20240810 - Compile fix
- 20240808 - V1 release

## To-Do:
- 

## Reference:
- https://www.fpga4student.com/2017/01/verilog-code-for-single-cycle-MIPS-processor.html
- https://www.fpga4student.com/2017/04/verilog-code-for-16-bit-risc-processor.html
- https://www.fpga4student.com/2017/06/Verilog-code-for-ALU.html