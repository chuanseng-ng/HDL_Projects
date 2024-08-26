
# Entity: alu_unit 
- **File**: alu_unit.sv

## Diagram
![Diagram](alu_unit.svg "Diagram")
## Generics

| Generic name | Type | Value | Description                     |
| :----------: | :--: | :---: | :-----------------------------: |
| ALU_SIZE     | int  | 16    | Arithmetic logic unit bit width |
| SHIFT_BIT    | int  | 1     | Number of bits to shift         |

## Ports

| Port name | Direction | Type           | Description            |
| :-------: | :-------: | :------------: | :--------------------: |
| alu_in_a  | input     | [ALU_SIZE-1:0] | ALU input A            |
| alu_in_b  | input     | [ALU_SIZE-1:0] | ALU input B            |
| alu_sel   | input     | [3:0]          | ALU operation selector |
| alu_out   | output    | [ALU_SIZE-1:0] | ALU output             |
| carry_out | output    | :              | ALU carry bit output   |

## Signals

| Name           | Type               | Description               |
| :------------: | :----------------: | :-----------------------: |
| alu_result     | reg [ALU_SIZE-1:0] | ALU operation result      |
| carry_out_temp | wire [ALU_SIZE:0]  | ALU carry bit temp holder |

## Processes
- alu_operation: (  )
  - **Type:** always_comb
