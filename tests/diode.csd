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
#include "../zdf.udo"

gkcut init 4000

instr modulation 
  gkcut = lfo(4000, 0.1) + 6000 
endin

	instr bass	 

iamp = ampdbfs(-12) 
ipch = cps2pch(p4, 12)

asig = vco2(0.5, ipch, 0)

/*kcut = expon:k(8000, p3, 800) */
/*aout diode_ladder asig, kcut, 16 */

/*print i(gkcut)*/

acut = expon:a(i(gkcut), p3, 100) 
aout = diode_ladder(asig, acut, a(i(gkcut) / 600), 1, 4)
/*aout = diode_ladder(asig, acut, a(16), 1, 4)*/

aout *= adsr(0.02, 0.01, 1.0, 0.02)

aout = limit(aout, -1.0, 1.0)

outc(aout, aout)

	endin


gipat[] init 8
gipat[0] = 6.00
gipat[1] = 7.00
gipat[2] = 6.00
gipat[3] = 7.00
gipat[4] = 5.07
gipat[5] = 6.07
gipat[6] = 5.08
gipat[7] = 6.08


instr player
  indx = p4

  ;; play instrument
  if(gipat[indx] > 0) then
    schedule("bass", 0, 0.2, gipat[indx])
  endif

  ;; temporal recursion
  schedule("player", 0.2, 0.1, (indx + 1) % lenarray(gipat))

endin

schedule("modulation", 0, -1)
schedule("player", 0, 0.1, 0)

</CsInstruments>

<CsScore>  
</CsScore>

</CsoundSynthesizer>
