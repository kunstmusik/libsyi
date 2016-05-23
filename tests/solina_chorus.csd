<CsoundSynthesizer>
;<CsOptions>
;</CsOptions>
; ==============================================
<CsInstruments>

sr	=	44100
ksmps	=	1
nchnls	=	2
0dbfs	=	1

#include "../solina_chorus.udo"

instr 1	

ipch = cps2pch(p4, 12)
iamp = ampdbfs(p5)

ampenv = madsr:a(1, 0.1, 0.95, 0.5)
asig = vco2(0.5, ipch)
asig = moogladder(asig, 6000, 0.1)

asig *= ampenv * iamp * 0.25

aL, aR pan2 asig, 0.55

chnmix aL, "sigL"
chnmix aR, "sigR"

endin


instr 2

aL chnget "sigL"
aR chnget "sigR"

aL solina_chorus aL, 0.18, 0.6, 6, 0.2
aR solina_chorus aR, 0.18, 0.6, 6, 0.2

arvbL, arvbR  reverbsc  aL, aR, 0.85, 8000

aL ntrpol aL, arvbL, 0.8
aR ntrpol aR, arvbR, 0.8

outc aL, aR



endin

</CsInstruments>
; ==============================================
<CsScore>
i2 0.0 12 

i1 0.0 4.0 8.00 -12
i1 . . 8.07 -14
i1 . . 9.03 -16
i1 . . 9.10 -18

i1 4 4.0 8.02 -12
i1 . . 8.09 -14
i1 . . 9.05 -16
i1 . . 10.00 -18


</CsScore>
</CsoundSynthesizer>

