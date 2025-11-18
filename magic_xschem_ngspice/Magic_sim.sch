v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {code_shown.sym} -60 -20 0 0 {name=s1 only_toplevel="false" value=".include /home/harry/Work/ECE298A/diff_amp/diff_amp.spice
.lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt

Vpower vdd gnd 1.8
VinA vin1 gnd pulse(0.9, 0.91, 100us, 10us, 10us, 50us, 200us)
VinB vin2 gnd 0.9
VinC vtail gnd 0.5

*.control
*op
.tran 1ns, 250us
.print all
*ac dec 50 1 1e9
*print ac v(vout)/v(vin1)
*.endc"}
