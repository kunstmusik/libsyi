<CsoundSynthesizer>
;<CsOptions>
;</CsOptions>
; ==============================================
<CsInstruments>

sr	=	44100
ksmps	=	64
nchnls	=	2
0dbfs	=	1

#include "../filters.inc"

instr 1	

ifilter_type = p4
icutoff init 600

aenv = madsr:a(0.05, 0.05, 0.5, 0.5)
acutoff = aenv * icutoff * 4 + icutoff
aout = tdf2(vco2(0.5, 440), ifilter_type, acutoff, a(0.8), a(12.0)) 
aout *= aenv

outs aout, aout

endin

</CsInstruments>
; ==============================================
<CsScore>
i1 0 1.0 0
i1 2 1.0 1
i1 4 1.0 2
i1 6 1.0 3
i1 8 1.0 4
i1 10 1.0 5
i1 12 1.0 6


</CsScore>
</CsoundSynthesizer>

