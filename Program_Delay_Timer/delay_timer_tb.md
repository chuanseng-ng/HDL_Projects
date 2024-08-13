
# Entity: delay_timer_tb 
- **File**: delay_timer_tb.sv
- **Title:**  Programmable Digital Delay Timer Testbench

## Diagram
![Diagram](delay_timer_tb.svg "Diagram")
## Description


## Signals

| Name          | Type                       | Description                                      |
| :-----------: | :------------------------: | :----------------------------------------------: |
| clk           | reg                        | Clock source                                     |
| rst_n         | reg                        | Reset source - Active low                        |
| trigger_in    | reg                        | Delay trigger input                              |
| mode_a        | reg                        | Controls delay_mode bit 0                        |
| mode_b        | reg                        | Controls delay_mode bit 1                        |
| weighted_bits | reg [WEIGHT_BIT_WIDTH-1:0] | Programs delay based on equation (Refer to spec) |
| delay_out_n   | wire                       | Amount of delay provided by delay_timer          |

## Constants

| Name             | Type | Value  | Description                 |
| :--------------: | :--: | :----: | :-------------------------: |
| WEIGHT_BIT_WIDTH |   -  | 8      | Defines weighted_bits width |
| ENDTIME          |   -  | 500000 | Simulation duration - In ns |

## Instantiations

- u_delay_timer: delay_timer
