<CsoundSynthesizer>
;<CsOptions>
;</CsOptions>
; ==============================================
<CsInstruments>

sr	=	44100
ksmps	=	1
;nchnls	=	2
0dbfs	=	1

#include "../waveseq.udo"

instr 1	
; num waves, forwards = 0 or b/f = 1, startWave, loop start, loop end

; ft#, sample-rate (0 denotes single cycle), amp modifier, amp modifier (level), freq modifier (1 = single-cycle waveform), 
;   xfade (amount of overlap between end of this step and next), waveDuration

ixfade = 3
iwavedur = 6

itab1 ftgenonce 0, 0, 65536, 10, 1, 0, .5, 0, .25, .1, .0625
itab2 ftgenonce 0, 0, 65536, 10, 1, .5, .25, .125, .0625
itab3 ftgenonce 0, 0, 65536, 10, 1, 0, .5, 0, .125

iwaveseqtab ftgenonce 0, 0, -32, -2, 3, 1, 0, 0, 2, \ 
itab1, 0, 1, 1, ixfade, iwavedur, \ 
itab2, 0, .9, 1, ixfade, iwavedur, \ 
itab3, 0, .8, 1, ixfade, iwavedur

itempo = 120

ipch cps2pch p4, 12
iamp = ampdbfs(p5)

kenv  linsegr 0, .05, 1, .05, .9, .4, 0

aout waveseq ipch, iwaveseqtab, itempo 


aout = aout * kenv * iamp

aout limit aout, -1, 1

outc aout, aout

endin

</CsInstruments>
; ==============================================
<CsScore>

i1 0 10 8.00 -12
i1 2 8 8.07 -12
i1 4 6 8.11 -12
i1 6 4 9.04 -12

</CsScore>
</CsoundSynthesizer>

