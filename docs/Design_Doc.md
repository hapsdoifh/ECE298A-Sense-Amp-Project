## Design Document

### Circuit Design

- PMOS pair provides the same current on both sides of the 

#### Iteration 1

#### Iteration 2

#### Iteration 3

### Layout in Magic VLSI:

#### Iteration 1

#### Iteration 2

#### Iteration 3

#### Transistor sizing

We have 3 main goals in terms of transistor sizing:
- minimize size
- minimize power consumption
- maximizing bandwidth

We first used LTSpice to simulate sizing before implementing the design in magic and used ngspice for final testing on the components

We initially tried to maximize the gain of the amplifier, but that reduced the bandwidth. 
After learning that the differential input from the bitline would already be fairly high, and that we will be feeding the final output through a CMOS buffer. We increased the tail current to improve the bandwidth of the amplifier 

### Testing methodology:
We used ngspice to test the extracted spice files from magic

| Specification | Method |
| ----- | ----- |
| Gain | AC Sweep at the inputs |
| Gain Bandwidth |  AC Sweep at the inputs |
| Sensitivity | DC sweep at the input |
| Static Consumption | DC operating point analysis |
| Switching Avg Consumption |  Transient analysis at 66MHz |
| Rise Time | Transient Analysis |
| Fall Time | Transient Analysis |
| Operating Voltage | 1.8V |
| Transistor Count | 10 |

### Test Results

| Specification | Tested Value |
| ----- | ----- |
| Gain | 14 dB |
| Gain Bandwidth | 3dB at 100MHz |
| Sensitivity | 0.01V |
| Power Consumption | ~0.2 mW |
| Switching Avg Consumption | ~0.2 mW |
| Rise Time | 15ns |
| Fall Time | 15ns |
| Operating Voltage | 1.8V |
| Transistor Count | 10 |

