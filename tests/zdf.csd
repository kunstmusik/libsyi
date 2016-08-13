;
; "Zero-Delay Feedback Filters Test file"
; by Steven Yi 
;
<CsoundSynthesizer>

<CsInstruments>
sr=44100
ksmps=1
nchnls=2
0dbfs=1

#include "../zdf.udo"

	instr 1	 

ifilttype = p4

if(ifilttype == 0) then
  prints "Testing zdf_1pole (low-pass)..."
else
  prints "Testing zdf_1pole (high-pass)..."
endif

iamp = ampdbfs(-12) 
ipch = cps2pch(8.00, 12)

asig rand 1.0 

kcut = expon(20, p3, 20000) 

alp, ahp zdf_1pole asig, kcut

aout = (ifilttype == 0) ? alp : ahp 

aout = limit(aout, -1.0, 1.0)

outc(aout, aout)

	endin

</CsInstruments>

<CsScore>

i1 0 8 0  ; zdf_1pole low-pass
i1 10 8 1 ; zdf_1pole high-pass 

</CsScore>

</CsoundSynthesizer>
