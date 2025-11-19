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
VinA vin1 gnd pulse(1, 0.95, 100us, 10us, 10us, 50us, 200us) AC 0.01
VinB vin2 gnd pulse(1, 1.05, 100us, 10us, 10us, 50us, 200us)
VinC vtail gnd 0.62

.control
*op
*tran 1ns, 250us
ac dec 50 1 1e9
*print all
plot db(v(vout)/v(vin1))
*print ac v(vout)/v(vin1)
.endc"}
