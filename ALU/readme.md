# Readme file for ALU

## Control signal

| Control Signal |      Function       |
| :------------: | :-----------------: |
|      0001      | addition            |
|      0010      | subtraction         |
|      0011      | bitwise and         |
|      0100      | bitwise or          |
|      0101      | bitwise xnor        |
|      0110      | compare A and B     |
|      0111      | Logical shift left  |
|      1000      | Logical shift right |

## Output definition for compare operation

|                   Output                    | Definition |
| :-----------------------------------------: | :--------: |
| 32'b0000_0000_0000_0000_0000_0000_0000_0001 |   A = B    |
| 32'b0000_0000_0000_0000_0000_0000_0000_0010 |   A < B    |
| 32'b0000_0000_0000_0000_0000_0000_0000_0011 |   A > B    |