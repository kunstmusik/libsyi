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
#include "../pattern_sequencer.udo"


gi_sine ftgen 0, 0, 65537, 10, 1

gkpattern[] fillarray \
  cps2pch(6.00,12), cps2pch(7.00,12), \
  cps2pch(6.00,12), cps2pch(7.00,12), \
  cps2pch(6.02,12), cps2pch(7.02,12), \ 
  cps2pch(6.03,12), cps2pch(7.03,12) 


gkpattern_bd[] fillarray 1,0,1,0,1,0,1,0 
;gkpattern_bd[] fillarray 1,0,0,0,0,1,0,0 

gkpattern_synth[] fillarray \
  1, 0, 1, 0, 0, 0, 1, 0, \ 
  1, 0, 1, 0, 1, 0, 1, 0  
  
gktempo init 108 
gkduty init 0.45

gkattack init 0.04
gkdecay init 0.02
gksustain init 0.5
gkrelease init 0.15


gkporttime init 0.01 

gaclock init 0
gkbeat init 0

gkbass_vcf_depth init 12
gkbass_vcf_sens init 1 

set_pattern_seq 0, 0, \ 
  1, 0, 0 ,0, 1, 0, 0, 0, 1, 0, 0 ,0, 1, 0, 0 ,0

set_pattern_seq 1, 0, \ 
  1, 0, 0 ,0, 1, 0, 0, 0, 1, 0, 0 ,0, 1, 0, 1 ,0

gkpat_indx init 0

gksong_pattern[] fillarray 0,0,0,1,0,1,0,1

instr sequencer 
  gkbeat = 60 / (gktempo * 4) ;; time in seconds, 1/16 note
  gaclock = mpulse(1, gkbeat)

  apatclock = clock_div(gaclock, 16)

  kpat = seqsig:k(apatclock, gksong_pattern)

  ga1, ga2, ga3, ga4, \
  ga5, ga6, ga7, ga8 pattern_sequencer gaclock, kpat 
endin


instr bass ;; bass line

  aclock = clock_div(gaclock, 2)
  agate = gatesig(aclock, gkduty * gkbeat * 4)
  aretrig init 0

  iamp = ampdbfs(-12)

  aenv adsr140 agate, aretrig, gkattack, gkdecay, gksustain, gkrelease 

  apch = seqsig(aclock, gkpattern)
  aout = vco(1.0, apch, 1, 0.5, gi_sine)
  aout += vco(1.0, apch * 0.5, 2, 0.5, gi_sine)

  aout *= 0.5

  kcps = (gktempo / 60) / 32 
  kcut = lfo(0.45, kcps , 1) + 0.5 

  aout zdf_ladder aout, 500 * (1 + ((1 - gkbass_vcf_sens) + (aenv * gkbass_vcf_sens * kcut)) * gkbass_vcf_depth), a(.96)
  /*aout moogladder aout, 500 * (1 + aenv * 2), .6 */
  ;aout lpf18 aout, 400 * (1 + kmod * aenv), .8, 0.4

  aout = aout * aenv * iamp

  outc(aout, aout)

endin

instr bass_vcf_mod ;; bass vcf mod
  kcps = (gktempo / 60) / 8
  gkbass_vcf_sens = lfo(0.4, kcps, 1) + 0.6 
  gkbass_vcf_depth = lfo(0.4, kcps , 1) + 0.6 
endin


instr bass_drum ;; drums

  aclock = clock_div(gaclock, 2)
  agate = gatesig(aclock, gkduty * gkbeat * 4)
  aretrig init 0
  apch = ga1 

  iamp = ampdbfs(-18)

  aenv adsr140 agate * apch, aretrig, 0.01, 0.25, 0.0001, 0.0001 
  avcoenv adsr140 agate * apch, aretrig, 0.001, 0.05, 0.0001, 0.0001 

  ;; good enough for sketching...
  aout = butterlp(
          reson(vco(1.0, 50 + avcoenv * 200, 3, 0.5, gi_sine), 800, 600),
          1200)

  aout += butterlp(noise(aenv, 0), 300) 
  aout *= 0.125 * iamp * aenv

  /*aout moogladder aout, 500 * (1 + aenv * 2), .6 */
  ;aout lpf18 aout, 400 * (1 + kmod * aenv), .8, 0.4

  /*aout = aout * aenv */

  outc(aout, aout)

endin


instr synth ;; synth line

  /*aclock = clock_div(gaclock, 2)*/
  aclock = gaclock
  aretrig init 0
  kcps = (gktempo / 60) / 16 
  kcut = lfo(0.4, kcps , 1) + 0.6 

  iamp = ampdbfs(-6)

  agate = gatesig(aclock, 0.05)
  atrg = seqsig(aclock, gkpattern_synth) 
  aenv adsr140 agate * atrg, aretrig, 0.001, 0.25, 0.001, 0.25

  apch init cps2pch(10.03, 12)
  aout = vco(1, apch , 1, 0.5, gi_sine)
  aout += vco(0.5, apch * 1.5, 2, 0.5, gi_sine)
  aout += rand:a(0.5)

  aout *= 0.5 * iamp

  aout zdf_ladder aout, (200 * (1 + (kcut * 2))) * (1 + aenv * 8), a(.6)

  aout = aout * aenv 

  al, ar pan2 aout, 0.4

  outc(al, ar)

endin


;; Events to start always-on modular setup
event_i "i", "sequencer", 0, 1000000
event_i "i", "bass", 0, 1000000
event_i "i", "bass_vcf_mod", 0, 1000000
event_i "i", "bass_drum", 0, 1000000
event_i "i", "synth", 0, 1000000

</CsInstruments>
; ==============================================
<CsScore>

</CsScore>
</CsoundSynthesizer>

