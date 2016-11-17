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

#include "../diode.udo"

	instr 1	 

iamp = ampdbfs(-12) 
ipch = cps2pch(p4, 12)

asig vco2 0.5, ipch 

kcut = expon(8000, p3, 800) 

aout diode_ladder asig, kcut, 20 

aout = limit(aout, -1.0, 1.0)

outc(aout, aout)

	endin


gipat[] init 8
gipat[0] = 6.00
gipat[1] = 6.00
gipat[2] = 6.07
gipat[3] = 7.00
gipat[4] = 6.00
gipat[5] = 6.00
gipat[6] = 6.07
gipat[7] = 7.00

instr player

  indx = p4
  print indx
  print gipat[indx]

  schedule 1, 0, 0.2, gipat[indx] 

  schedule "player", 0.2, 0.1, (indx + 1) % 8

endin

schedule "player", 0, 0.1, 0

</CsInstruments>

<CsScore>  
</CsScore>

</CsoundSynthesizer>
