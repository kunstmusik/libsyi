<CsoundSynthesizer>
;<CsOptions>
;</CsOptions>
; ==============================================
<CsInstruments>

sr	=	44100
ksmps	=	1
nchnls	=	2
0dbfs	=	1

#include "../audaciouseq.udo"

instr 1	

asig = noise(0.5, 0)
/*aout = audaciouseq(asig, 1,1,1,1,1,1,1,1,1,1)*/
aout = audaciouseq(asig, 0.0,0.0,0.0,0.0,6,
                         0.0,-1,-2,-3,-12)

outc aout, aout

endin

</CsInstruments>
; ==============================================
<CsScore>
i1 0 5


</CsScore>
</CsoundSynthesizer>

