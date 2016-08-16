<CsoundSynthesizer>
<CsOptions>
</CsOptions>
; ==============================================
<CsInstruments>

sr	=	48000
ksmps	=	64
nchnls	=	2
0dbfs	=	1

#include "../adsr140.udo"
#include "../gatesig.udo"
#include "../seqsig.udo"


gi_sine ftgen 0, 0, 65537, 10, 1

gkpattern[] fillarray \
  cps2pch(6.00,12), cps2pch(7.00,12), \
  cps2pch(6.00,12), cps2pch(7.00,12), \
  cps2pch(6.02,12), cps2pch(7.02,12), \ 
  cps2pch(6.03,12), cps2pch(7.03,12) 

gktempo init 240 
gkduty init 0.45

gkattack init 0.02
gkdecay init 0.02
gksustain init 0.5
gkrelease init 0.15


gkporttime init 0.01 

instr 1
  kbeat = 60 / gktempo  ;; time in seconds
  aclock = mpulse(1, kbeat)

  agate = gatesig(aclock, gkduty * kbeat)
  aretrig init 0

  ipch = cps2pch(8.00,12)
  iamp = ampdbfs(-12)

  ;aretrig = lfo(1.0, 0.8 + kmod)
  ;aretrig = lfo(1.0, 4.0 + 8.0 *kmod)

  aenv adsr140 agate, aretrig, gkattack, gkdecay, gksustain, gkrelease 

  apch = seqsig(aclock, gkpattern)
  aout = vco(iamp, apch, 1, 0.5, gi_sine)

  aout moogladder aout, 500 * (1 + aenv * 2), .6
  ;aout lpf18 aout, 400 * (1 + kmod * aenv), .8, 0.4

  aout = aout * aenv 

  outc(aout, aout)

endin

/*

event_i "i", 1, -1, 1000000
*/
event_i "i", 1, 0, 1000000

</CsInstruments>
; ==============================================
<CsScore>

</CsScore>
</CsoundSynthesizer>

