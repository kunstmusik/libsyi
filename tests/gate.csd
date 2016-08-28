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

gkpattern_synth[] fillarray \
  1, 0, 1, 0, 0, 0, 1, 0, \ 
  1, 0, 1, 0, 1, 0, 1, 0  
  
gktempo init 131 


gkporttime init 0.01 

gaclock init 0
gkbeat init 0

gkbass_vcf_depth init 12
gkbass_vcf_sens init 1 

;; PATTERN SEQUENCES
;; BD 

set_pattern_seq 0, 0, \ 
  1, 0, 0 ,0, 1, 0, 0, 0, 1, 0, 0 ,0, 1, 1, 1 ,1

set_pattern_seq 1, 0, \ 
  1, 1, 1 ,1, 1, 0, 0, 0, 1, 0, 0 ,0, 1, 0, 0 ,0

set_pattern_seq 2, 0, \ 
  1, 0, 0 ,0, 1, 0, 0, 0, 1, 1, 1 ,1, 1, 1, 1 ,1

set_pattern_seq 3, 0, \ 
  1, 0, 0 ,0, 1, 0, 0, 0, 1, 0, 0 ,0, 1, 0, 0 ,0

copy_pattern_seq 2,0, 4,0
copy_pattern_seq 3,0, 5,0
copy_pattern_seq 2,0, 6,0
copy_pattern_seq 3,0, 7,0

copy_pattern_measure 4,0, 8,0
copy_pattern_measure 4,0, 12,0

;; BASS

gibpchf = cps2pch(6.05,12)
gibpchc = cps2pch(6.00,12)
gibpchd = cps2pch(6.02,12)
gibpchg = cps2pch(6.07,12)
gibpchf2 = gibpchf * 2 
gibpchc2 = gibpchc * 2 
gibpchd2 = gibpchd * 2 
gibpchg2 = gibpchg * 2 

set_pattern_seq 4, 1, 
  gibpchf, 0, 0, 0, gibpchf, 0, 0, 0,
  gibpchc, 0, 0, 0, gibpchc, 0, 0, 0

set_pattern_seq 5, 1, 
  gibpchd, 0, 0, 0, gibpchd, 0, 0, 0,
  gibpchd, 0, 0, 0, gibpchd, 0, 0, 0

set_pattern_seq 6, 1, 
  gibpchf, 0, 0, 0, gibpchf, 0, 0, 0, 
  gibpchg, 0, 0, 0, gibpchg, 0, 0, 0 

copy_pattern_seq   5,1,7,1

set_pattern_seq 8, 1, 
  gibpchf, 0, gibpchf2, 0, gibpchf, 0, gibpchf2, 0,
  gibpchc, 0, gibpchc2, 0, gibpchc, 0, gibpchc2, 0

set_pattern_seq 9, 1, 
  gibpchd, 0, gibpchd2, 0, gibpchd, 0, gibpchd2, 0,
  gibpchd, 0, gibpchd2, 0, gibpchd, 0, gibpchd2, 0

set_pattern_seq 10, 1, 
  gibpchf, 0, gibpchf2, 0, gibpchf, 0, gibpchf2, 0,
  gibpchg, 0, gibpchg2, 0, gibpchg, 0, gibpchg2, 0 

copy_pattern_seq   9,1,11,1

gkpat_indx init 0

gksong_pattern[] fillarray 0,1,2,3,2,3,2,3, 4, 5, 6, 7, 8, 9, 10, 11
/*gksong_pattern[] fillarray 4, 5, 6, 7, 8, 9, 10, 11 */

instr sequencer 
  gkbeat = 60 / (gktempo * 4) ;; time in seconds, 1/16 note
  gaclock = mpulse(1, gkbeat)

  apatclock = clock_div(gaclock, 16)

  apat = seqsig(apatclock, gksong_pattern)

  ga1, ga2, ga3, ga4, \
  ga5, ga6, ga7, ga8 pattern_sequencer gaclock, apat 
endin


instr bass ;; bass line

  kduty init 2.0 
  agate = gatesig(gaclock, kduty * gkbeat )
  apch = limit:a(ga2, 0.001, 20000)

  agate *= limit:a(ga2, 0, 1)
  aretrig init 0

  iamp = ampdbfs(-6)

  aenv adsr140 agate, aretrig, 0.001, 0.3, 0.2, 0.2 
  avcoenv = aenv ;adsr140 agate, aretrig, 0.04, 0.2, 0.2, 0.15 

  aout = vco(1.0, apch * 1.005, 1, 0.5, gi_sine)
  aout += vco(1.0, apch * 0.50, 2, 0.6, gi_sine)

  aout *= 0.5

  kcps = (gktempo / 60) / 32 
  kcut = lfo(0.45, kcps , 1) + 0.5 

  aout zdf_ladder aout, apch * (4 + avcoenv * 32), a(0.0)

  aout = aout * aenv * iamp

  outc(aout, aout)

endin

instr bass_vcf_mod ;; bass vcf mod
  kcps = (gktempo / 60) / 8
  gkbass_vcf_sens = lfo(0.4, kcps, 1) + 0.6 
  gkbass_vcf_depth = lfo(0.4, kcps , 1) + 0.6 
endin


instr bass_drum ;; drums
  kduty = 0.45
  agate = gatesig(gaclock, kduty * gkbeat)
  aretrig init 0

  iamp = ampdbfs(-18)

  aenv adsr140 agate * ga1, aretrig, 0.01, 0.25, 0.0001, 0.25
  avcoenv adsr140 agate * ga1, aretrig, 0.001, 0.1, 0.0001, 0.1

  ;; good enough for sketching...
  aout = butterlp(
          reson(vco(1.0, 50 + avcoenv * 400, 3, 0.5, gi_sine), 800, 600),
          1200)

  aout += butterlp(noise(1.0, 0), 300) 
  aout *= 0.05 * iamp * aenv

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
/*event_i "i", "bass_vcf_mod", 0, 1000000*/
event_i "i", "bass_drum", 0, 1000000
/*event_i "i", "synth", 0, 1000000*/

</CsInstruments>
; ==============================================
<CsScore>

</CsScore>
</CsoundSynthesizer>

