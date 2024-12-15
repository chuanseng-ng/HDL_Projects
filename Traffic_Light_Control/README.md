# This repo is to track Traffic Light Controller project
- Spec is listed below
- Status is listed below
- Changelist is listed below

## Spec:
<ul>
    <li>Traffic light controller with 4 possible combinations (outputs) using 2 inputs</li>
    <li>Possible combinations:</li>
        <ul>
            <li>00: Red</li>
            <li>01: Red Yellow</li>
            <li>10: Green</li>
            <li>11: Yellow</li>
        </ul>
    <br>
    <li>Truth table:</li>
    
    | Input A | Input B | Output X (Red) | Output Y (Yellow) | Output Z (Green) |
    | :-----: | :-----: | :------------: | :---------------: | :--------------: |
    |    0    |    0    |       1        |          0        |         0        |
    |    0    |    1    |       1        |          1        |         0        |
    |    1    |    0    |       0        |          0        |         1        |
    |    1    |    1    |       0        |          1        |         0        |

<li>Simplified logics:</li>
<ul>
    <li>Output X = ~Input A</li>
    <li>Output Y = Input B</li>
    <li>Output Z = Input A & (~Input B)
</ul>

</ul>

## Status:
- 

## Changelist:
- 

## Reference:
- https://vlsiverify.com/verilog/verilog-project-ideas