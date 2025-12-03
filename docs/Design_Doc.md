## Design Document

### Circuit Design
![Alt text](images/schematic.png)
This is a continuous-time differential amplifier for sensing RAM bitlines. It take a tiny voltage difference on the bitlines and amplify it to a full-scale signal (0-1.8V) that the rest of the system can use. Our initial design was using the latched sense amp but then we eventually went with continuous-time operation because our architecture needs to monitor the bitline voltage throughout the read cycle, not just capture it at one clock edge.

The circuit has three parts:
**Difference Amplifier**: It Uses cross-coupled PMOS and NMOS pairs. There's two NMOS transistors handling positive swings and two PMOS for negative swings, all wired with positive feedback. When one side starts winning, the feedback helps it win harder. It will generate a current difference in the output (around 2x difference in current across the two NMOS), This current charges the parasitic node capacitances, causing the internal node voltages to diverge, thus creating a larger voltage difference at the output.

**Current mirror**: It keeps the sum of the current across the two NMOS fixed and keeps them in saturation so they have decent gain and don't drift around when the common-mode voltage changes.

**Output buffers**: It is implemented by two CMOS inverters that take the amplified signal and drive it to full scaled analog output. It also isolates the high-impedance differential stage from whatever capacitive load comes next.

#### Iteration 1
Got the design proposal done by Oct 8 and created a rough circuit in LTSpice. At this point it was just the basic differential pair with two NMOS inputs and PMOS loads. The simulation showed it could amplify the voltage difference a little bit, but the numbers were all over the place depending on what values we picked for the length and width for the transistors. Gain was anywhere from 5dB to 20dB just from changing transistor widths randomly. Clearly needed to be more systematic about sizing.

#### Iteration 2
Spent the next few weeks (up to Oct 29) figuring out transistor dimensions. Started with minimum sizes and worked up from there. Tried a bunch of W/L ratios for the input pair. We noticed that wider transistors gave better bandwidth but ate more current. For the PMOS loads, we found that if they were too small the gain was small, but too big and the output voltage swing got limited. Ended up around W/L = ?μm/?μm for PMOS, ?μm/?μm for NMOS inputs.

#### Iteration 3
Before Nov 5 we did final LTSpice simulation. Measured gain (around 36dB), bandwidth (? MHz), sensitivity (could detect 10mV differential). Then we started the Magic VLSI layout.

### Layout in Magic VLSI:
#### Iteration 1
By Nov 13 we had a working differential amplifier in Magic. We learned to draw the transistors, extracted the design, ran ngspice, and the input signal can be amplified. Problem was the swing of the amplifier's output was still not in full scaled analog. During the Nov 13 lecture we found out we needed a CMOS buffer on the output to achieve that.

#### Iteration 2
Next week (before Nov 20) we added the buffer stage by adding two CMOS inverter at first. Output swing got better but still wasn't quite 0V to 1.8V. We tried with a voltage divider to scale the output, which worked but was obviously not the best solution. Also we noticed the amplifier cannot work above 10MHz. TA looked at it and said the problem was our biasing. We were still using a voltage source instead of a proper current mirror for the tail current. Voltage source has zero output impedance which was killing our gain and making everything frequency dependent. We have to Switch to a current mirror by using two more transistors to set the bias.

#### Iteration 3
Dec 1 lecture, we were told our voltage divider and current mirror are not implemented correctly. 

There were 2 issues\:
1 - We were biasing the first output inverter with an voltage divider. We realized just by sizing the PMOS/NMOS pair we were able to get similar results.
2 - We were using the voltage divider as a tail bias supply, this was not needed by simply adding a resistor and sizing the cmos appropriately, we can get sufficient tail current.

This version finally worked correctly and gave use desired behaviors for both gain, bias and speed

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

We included all parasitic capacitances:
```
extract all
ext2spice subckt top
ext2spice cthresh 0 
ext2spice
```

We used 3 types of tests:

- DC Sweep to find the operating points of the circuit

- Transient analysis at 66MHz (TinyTapeout max speed) to find the rise/fall times and runtime power disspation

- AC Analysis to find the gain and bandwidth of the amplifier

| Specification | Method |
| ----- | ----- |
| Gain | AC Sweep |
| Gain Bandwidth |  AC Sweep |
| Switching Point | AC Sweep |
| Sensitivity | DC sweep |
| Avg Consumption |  Transient analysis|
| Rise Time | Transient Analysis |
| Fall Time | Transient Analysis |
| Delay Time | Transient Analysis |


### Test Results
![Alt text](images/DC_Analysis.png)
![Alt text](images/Transient_Analysis.png)
![Alt text](images/AC_Analysis.png)

| Specification | Tested Value |
| ----- | ----- |
| DC Gain | 19.918 dB |
| Bandwidth | 3dB at 223.04 MHz |
| Switching Point | 0.8986 V |
| Sensitivity | 0.1V |
| Avg Consumption | 183.96 uW |
| Rise Time | 76.38ps |
| Fall Time | 65.69ps |
| Delay Time (@66MHZ) | 527.27 ps |
| Operating Voltage | 1.8V |
| Transistor Count | 10 |
| Layout footprint | 6.64 x 6.92 microns |

### Final Optimizations

During the final phases of the design, we tried to optimize the footprint and power consumption.

#### Resistor for tail current mirror
We considered removing the resistor for the tail current source to increase bandwidth and reduce footprint - as resistors in magic require more clearance than other components. We eventually decided to keep the resistor after realizing the total current would drastically increase without the resistor, and we already have enough bandwidth for TT's max clock speed

#### Additional footprint reduction
When verifying our final design for DRC, we realized we overlooked a space optimization that allows us to drastically reduce the length of the MOSFETS from around 0.4um to 0.16um. This further improved our bandwidth.

#### Additional Width adjustments
We initially based the sizing on LTspice simulation, and at the end we further  tweaked the sizing of the current mirror and output buffer to try and bias the output of the differential amplifier and the switching point of the inverterse to exactly 0.9V 