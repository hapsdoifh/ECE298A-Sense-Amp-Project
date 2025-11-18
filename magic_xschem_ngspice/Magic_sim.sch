v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {code_shown.sym} -60 -20 0 0 {name=s1 only_toplevel="false" value=".include /home/harry/Work/ECE298A/diff_amp/diff_amp.spice
.lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt

*VSS   Gnd     0      0.0
VSUB  SUB     0      0.0

VDD   Vdd     0      1.8
VIN1  Vin1    0      0.9
VIN2  Vin2    0      0.9
VTAIL Vtail   0      0.5

.control
op
print all
.endc"}
