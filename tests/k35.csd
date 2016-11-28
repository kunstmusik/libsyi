<CsoundSynthesizer>
<CsOptions>
</CsOptions>
; ==============================================
<CsInstruments>

sr	=	48000
ksmps	=	1
nchnls	=	2
0dbfs	=	1

#include "../k35.udo"

instr 1	

asig = vco2(0.5, cps2pch(6.00, 12))
asig = k35_lpf(asig, expseg:a(10000, p3, 30), 9.9, 0, 1)
asig  = limit(asig, -1.0, 1.0)

outc(asig, asig)

endin


instr 2	

asig = vco2(0.5, cps2pch(6.00, 12))
asig = k35_lpf(asig, expseg:k(10000, p3, 30), 9.9, 0, 1)
asig  = limit(asig, -1.0, 1.0)

outc(asig, asig)

endin

</CsInstruments>
; ==============================================
<CsScore>
i1 0 5.0
i2 5 5.0


</CsScore>
</CsoundSynthesizer>

