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
#include "../clock_div.udo"
#include "../zdf.udo"


gi_sine ftgen 0, 0, 65537, 10, 1

gkpattern[] fillarray \
  cps2pch(6.00,12), cps2pch(7.00,12), \
  cps2pch(6.00,12), cps2pch(7.00,12), \
  cps2pch(6.02,12), cps2pch(7.02,12), \ 
  cps2pch(6.03,12), cps2pch(7.03,12) 


gkpattern_bd[] fillarray 1,0,1,0,1,0,1,0 
;gkpattern_bd[] fillarray 1,0,0,0,0,1,0,0 
  
gktempo init 120 
gkduty init 0.45

gkattack init 0.04
gkdecay init 0.02
gksustain init 0.5
gkrelease init 0.15


gkporttime init 0.01 

gaclock init 0
gkbeat init 0

gkbass_vcf_depth init 8
gkbass_vcf_sens init 1 

instr 1
  gkbeat = 60 / (gktempo * 4) ;; time in seconds, 1/16 note
  gaclock = mpulse(1, gkbeat)
endin

instr 2 ;; bass line

  aclock = clock_div(gaclock, 2)
  agate = gatesig(aclock, gkduty * gkbeat * 4)
  aretrig init 0

  iamp = ampdbfs(-12)

  ;aretrig = lfo(1.0, 0.8 + kmod)
  ;aretrig = lfo(1.0, 4.0 + 8.0 *kmod)

  aenv adsr140 agate, aretrig, gkattack, gkdecay, gksustain, gkrelease 

  apch = seqsig(aclock, gkpattern)
  aout = vco(iamp, apch, 1, 0.5, gi_sine)
  aout += vco(iamp, apch * 0.5, 2, 0.5, gi_sine)

  aout *= 0.5

  aout zdf_ladder aout, 500 * (1 + ((1 - gkbass_vcf_sens) + (aenv * gkbass_vcf_sens)) * gkbass_vcf_depth), a(.96)
  /*aout moogladder aout, 500 * (1 + aenv * 2), .6 */
  ;aout lpf18 aout, 400 * (1 + kmod * aenv), .8, 0.4

  aout = aout * aenv 

  outc(aout, aout)

endin

instr 3 ;; bass vcf mod
  kcps = (gktempo / 60) / 8
  gkbass_vcf_sens = lfo(0.4, kcps, 1) + 0.6 
  gkbass_vcf_depth = lfo(0.4, kcps , 1) + 0.6 
endin



instr 4 ;; drums

  aclock = clock_div(gaclock, 2)
  agate = gatesig(aclock, gkduty * gkbeat * 4)
  aretrig init 0
  apch = seqsig(aclock, gkpattern_bd)

  iamp = ampdbfs(-12)

  aenv adsr140 agate * apch, aretrig, 0.01, 0.25, 0.0001, 0.0001 
  avcoenv adsr140 agate * apch, aretrig, 0.001, 0.05, 0.0001, 0.0001 

  ;; good enough for sketching...
  aout = butterlp(
          reson(vco(iamp, 50 + avcoenv * 200, 3, 0.5, gi_sine), 800, 600),
          1200)

  aout += butterlp(noise(aenv, 0), 300) 
  aout *= 0.5

  /*aout moogladder aout, 500 * (1 + aenv * 2), .6 */
  ;aout lpf18 aout, 400 * (1 + kmod * aenv), .8, 0.4

  aout = aout * aenv 

  outc(aout, aout)

endin



/*

event_i "i", 1, -1, 1000000
*/
event_i "i", 1, 0, 1000000
event_i "i", 2, 0, 1000000
event_i "i", 3, 0, 1000000
event_i "i", 4, 0, 1000000

</CsInstruments>
; ==============================================
<CsScore>

</CsScore>
</CsoundSynthesizer>

