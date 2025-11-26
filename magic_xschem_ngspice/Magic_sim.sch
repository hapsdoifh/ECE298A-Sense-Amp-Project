v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {code_shown.sym} -110 -30 0 0 {name=s1 only_toplevel="false" value=".include /home/harry/Work/ECE298A/diff_amp/diff_amp.spice
.lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt

Vpower vdd gnd 1.8
VinA vin1 gnd pulse(1.02, 0.98, 2us, 100ns, 100ns, 2us, 4us) AC 0.01
VinB vin2 gnd pulse(0.98, 1.02, 2us, 100ns, 100ns, 2us, 4us)
VinC vtail gnd 0.62
VBase vBase gnd 0.3
*Vinv vinv gnd 0.9

.control
*op
tran 1ns, 10us
*ac dec 50 1 1e9
*dc VinV 0 1.8 0.01
*plot db(v(vout1)/v(vin1))
plot v(vbase) v(vinv) v(vout2) v(voutf)
*print ac v(vout)/v(vin1)
*print all
.endc"}
