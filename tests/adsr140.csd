; Example of Gated, Retriggerable Envelope Generator UDO (adsr140)
; Based on design of Doepfer A-140 Envelope Generator Module
; Code based on ADSR code by Nigel Redmon 
; (http://www.earlevel.com/main/2013/06/03/envelope-generators-adsr-code/)
; Example by Steven Yi (2015.02.08)
;
; More information available at:
; http://kunstmusik.com/2015/02/09/csound-adsr140/

<CsoundSynthesizer>
<CsInstruments>
sr=44100
ksmps=32
nchnls=2
0dbfs=1

#include "../adsr140.udo"

instr 1
ipch = cps2pch(p4,12)
iamp = ampdbfs(p5)

kmod = linseg:k(0.0, p3 * .5, 1.0, p3 * .5, 0.0)

agate = lfo(1.0, 6 + (kmod * 12))
aretrig init 0

;aenv adsr140 agate, aretrig, 0.04, 0.04, 0.9, 0.15
aenv adsr140 agate, aretrig, 0.04, 0.3, 0.9, 0.15

aout vco2 iamp, ipch

aout moogladder aout, 500 * (1 + kmod * aenv * 4), .6
;aout lpf18 aout, 400 * (1 + kmod * aenv), .8, 0.4

aout = aout * aenv * kmod ; * 0.5


outs aout, aout
endin

instr 2
ipch = cps2pch(p4,12)
iamp = ampdbfs(p5)

kmod = linseg:k(0.0, p3 * .5, 1.0, p3 * .5, 0.0)

agate = lfo(1.0, 2.0)
;aretrig = lfo(1.0, 0.8 + kmod)
aretrig = lfo(1.0, 4.0 + 8.0 *kmod)

aenv adsr140 agate, aretrig, 0.04, 0.3, 0.25, 0.15

aout vco2 iamp, ipch

aout moogladder aout, 500 * (1 + kmod * aenv * 4), .6
;aout lpf18 aout, 400 * (1 + kmod * aenv), .8, 0.4

aout = aout * aenv * kmod ; * 0.5

outs aout, aout
endin

</CsInstruments>

<CsScore>
i1 0   10 8.00 -12
i1 0.2 9.8 8.04 -12
i1 0.4 9.6 8.07 -12

i1 6.0 10 9.00 -12
i1 6.2 9.8 9.03 -12
i1 6.4 9.6 9.08 -12

i2 18 20 10.00 -12
i2 19 19 10.02 -12
i2 20 18 10.04 -12

</CsScore>
</CsoundSynthesizer>
