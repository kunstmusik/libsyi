<CsoundSynthesizer>
<CsInstruments>

sr	=	44100
ksmps	=	64
nchnls	=	2
0dbfs	=	1

#include "../unirect.udo"
#include "../adsr140.udo"

instr 1	

ipch = 440
iamp = 0.25

kval = linseg(0.8, p3, 0.1)
kfreq = linseg(4, p3 * .5, 8, p3 * .5, 2)
agate = unirect(kfreq, kval)

aretrig init 0

aenv adsr140 agate, aretrig, 0.04, 0.3, 0.9, 0.15

aout vco2 iamp, ipch

aout moogladder aout, 500 * (1 + aenv * 4), .6

aout = aout * aenv 

outs aout, aout

endin

</CsInstruments>
; ==============================================
<CsScore>
i1 0 5

</CsScore>
</CsoundSynthesizer>

