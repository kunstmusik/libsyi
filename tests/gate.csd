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
#include "../event_seq.udo"
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


copy_pattern_seq 3,0, 8,0
copy_pattern_seq 3,0, 9,0
copy_pattern_seq 3,0, 10,0
copy_pattern_seq 3,0, 11,0

copy_pattern_measure 8,0, 12,0

;; CLAP 
set_pattern_seq 8, 2, \ 
  0, 0, 0 ,0, 1, 0, 0, 0, 0, 0, 0 ,0, 1, 0, 0 ,0

copy_pattern_seq 8,2, 9,2
copy_pattern_seq 8,2, 10,2
copy_pattern_seq 8,2, 11,2

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

/*gksong_pattern[] fillarray 0,1,2,3,2,3,2,3, 4, 5, 6, 7, 8, 9, 10, 11*/

gksong_pattern[] fillarray 8, 9, 10, 11
/*gksong_pattern[] fillarray 4, 5, 6, 7 */
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

  ivcodec = 0.36

  aenv adsr140 agate, aretrig, 0, ivcodec, 0.2, ivcodec 
  avcoenv adsr140 agate, aretrig, 0, ivcodec, 0.0001, ivcodec 

  aout = vco(1.0, apch * 1.005, 1, 0.6, gi_sine)
  aout += vco(1.0, apch * 0.5, 1, 0.5, gi_sine)

  aout *= 0.5

  aout zdf_ladder aout, 0.1 + avcoenv * 4000, a(0.34)

  aout = aout * iamp * aenv

  outc(aout, aout)

endin

instr bass_drum ;; drums
  kduty = 0.45
  agate = gatesig(gaclock, kduty * gkbeat)
  aretrig init 0

  iamp = ampdbfs(-18)

  aenv adsr140 agate * ga1, aretrig, 0.00, 0.25, 0.0001, 0.25
  avcoenv adsr140 agate * ga1, aretrig, 0.00, 0.1, 0.0001, 0.1

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

instr clap_module
  aclap_trig = gaclock * ga3 
  event_seq(aclap_trig, "clap", 0.5) 
endin

instr clap
;; Modified clap instrument by Istvan Varga (clap1.orc)
ibpfrq	=  1046.5				/* bandpass filter frequency */
kbpbwd	port ibpfrq*0.25, 0.03, ibpfrq*4.0	/* bandpass filter bandwidth */
idec	=  0.5					/* decay time		     */

a1	=  1.0
a1_	delay1 a1
a1	=  a1 - a1_
a2	delay a1, 0.011
a3	delay a1, 0.023
a4	delay a1, 0.031

a1	tone a1, 60.0
a2	tone a2, 60.0
a3	tone a3, 60.0
a4	tone a4, 1.0 / idec

aenv1	=  a1 + a2 + a3 + a4*60.0*idec

a_	unirand 2.0
a_	=  aenv1 * (a_ - 1.0)
a_	butterbp a_, ibpfrq, kbpbwd

aout = a_	* 80 ;; 
al, ar pan2 aout, 0.7
outc(al, ar)

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
  aenv adsr140 agate * atrg, aretrig, 0, 0.25, 0.001, 0.25

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
event_i "i", "bass_drum", 0, 1000000
event_i "i", "clap_module", 0, 1000000
/*event_i "i", "synth", 0, 1000000*/

</CsInstruments>
; ==============================================
<CsScore>

</CsScore>
</CsoundSynthesizer>

