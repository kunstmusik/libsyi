<CsoundSynthesizer>
<CsOptions>
-i adc -o dac
</CsOptions>
<CsInstruments>
sr=44100
ksmps=1
nchnls=2
0dbfs=1


ga_bluemix_1_0	init	0
ga_bluemix_1_1	init	0
ga_bluesub_Master_0	init	0
ga_bluesub_Master_1	init	0


gk_blue_auto0 init 0.5
gk_blue_auto1 init 440
gk_blue_auto2 init 0
gk_blue_auto3 init 0



#include "../ringmod.udo"


	instr 1	;RingModInstr
ain in

acar poscil gk_blue_auto0, gk_blue_auto1
;acar vco2 .25, 2000

aout ringmod ain, acar

aout limit aout, -0.5, 0.5

outs aout, aout
	endin

	instr 2	;Blue Mixer Instrument
ktempdb = ampdb(gk_blue_auto2)
ga_bluemix_1_0 = ga_bluemix_1_0 * ktempdb
ga_bluemix_1_1 = ga_bluemix_1_1 * ktempdb
ga_bluesub_Master_0	sum	ga_bluesub_Master_0, ga_bluemix_1_0
ga_bluesub_Master_1	sum	ga_bluesub_Master_1, ga_bluemix_1_1
ktempdb = ampdb(gk_blue_auto3)
ga_bluesub_Master_0 = ga_bluesub_Master_0 * ktempdb
ga_bluesub_Master_1 = ga_bluesub_Master_1 * ktempdb
outc ga_bluesub_Master_0, ga_bluesub_Master_1
ga_bluemix_1_0 = 0
ga_bluemix_1_1 = 0
ga_bluesub_Master_0 = 0
ga_bluesub_Master_1 = 0

	endin


</CsInstruments>

<CsScore>




i1 0 3600



i2	0	3600	

e

</CsScore>

</CsoundSynthesizer>
