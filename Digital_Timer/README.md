# This repo is to track Digital Timer project
- Spec is listed below
- Status is listed below
- Changelist is listed below

## Spec:
<ul>
    <li> Expectation - </li>
        <ul>
        <li> Timer increment at the 10th tick of the clock (Increment clock = system clock / 10) </li>
        <li> Timer format is as follows --> HH.MM.SS </li>
        </ul>
    <li> Digit Format - </li>
        <ul>
        <li> Visual Format --> </li>
          -----    <br>
        |    |   <br>
           -----   <br>
        |    |   <br>
          -----    <br>
        <li> Character Format --> </li>
          a    <br>
        f    b   <br>
          g    <br>
        e    c   <br>
           d   <br>
        </ul>
</ul>

<li> Character Table Format - </li>

| Number |  a  |  b  |  c  |  d  |  e  |  f  |  g  | abcdefg |
| :----: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-----: |
|    0   |  0  |  0  |  0  |  0  |  0  |  0  |  1  | 0000001 |
|    1   |  1  |  0  |  0  |  1  |  1  |  1  |  1  | 1001111 |
|    2   |  0  |  0  |  1  |  0  |  0  |  1  |  0  | 0010010 |
|    3   |  0  |  0  |  0  |  0  |  1  |  1  |  0  | 0000110 |
|    4   |  1  |  0  |  1  |  1  |  1  |  0  |  0  | 1011100 |
|    5   |  0  |  1  |  1  |  0  |  1  |  0  |  0  | 0110100 |
|    6   |  0  |  1  |  1  |  0  |  0  |  0  |  0  | 0110000 |
|    7   |  0  |  0  |  0  |  1  |  1  |  1  |  1  | 0001111 |
|    8   |  0  |  0  |  1  |  0  |  0  |  0  |  0  | 0010000 |
|    9   |  0  |  0  |  1  |  0  |  1  |  0  |  0  | 0010100 |

<li> Refer to 7-Segment Decoder Truth Table snapshot in reference directory </li>

## Status:
- 20240828 - Add timer_pause, timer_clear & timer_reset into TB and fix timer_pause & timer_clear bugs
- 20240828 - Fix bugs and resolve compile issue
- 20240828 - Init DB

## Changelist:
- 20240828 - Fix timer_pause not working as intended issue
- 20240828 - Fix timer_clear not working as intended issue
- 20240828 - Fix TB & RTL for compile & function

## To-Do:
- Fix design to increment minutes and hours correctly
- (Resolved) timer_clear not working properly -- timer_clk not reset to low if already high
- (Resolved) timer_pause not working properly -- timer_clk still toggling during timer_pause assertion
  - Edge-case where timer_clk_count == 'd9, cause digital_clock_in to continue toggling

## Reference:
- 