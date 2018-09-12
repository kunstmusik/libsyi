Title: Cellular Automata Streams
Author: Steven Yi<stevenyi@gmail.com>
Date: 2018.09.11
Description:

Implementation of 1-dimensional (Elementary) Cellular Automata as a
stream using feedback and circular buffer delay line. Stream
generates 1 (Live) and 0 (Dead) values, according to initial state
and rule. 

Initial state may be any length array.  Different array lengths
affects the rate of mutation, comparable to classical cellular
automata implementations that use a fixed array as value between CA
processing steps.  

Rule numbers are implemented using Wolfram-style encoding where
number is interpreted as bits. This allows user to use Wolfram rule
numbers. For example, Rule 30 gives bit value of 00011110.

For this project, the CA stream values are used to turn and off a
held note of a specific frequency and amplitude. Actions occur only
when the stream values has transitioned from 0 to 1 or vice versa.

<CsoundSynthesizer>
<CsOptions>
-odac --port=10000 -m0
</CsOptions>
; ==============================================
<CsInstruments>

sr	=	48000
ksmps	= 32	
nchnls	=	2
0dbfs	=	1

#include "../cellular_automata_streams.udo"

/* UTILITY CODE */

;; Stereo Audio Bus

gal init 0
gar init 0

instr Mixer 

  al, ar reverbsc gal, gar, 0.7, 4000 

  out(al, ar)
  
  gal = 0 
  gar = 0 
endin
schedule("Mixer", 0, -1)


/* SYNTHESIZER */

instr Syn
  asig = vco2(0.5, p4)
  asig += vco2(0.5, p4 * 2, 10)
  asig = zdf_ladder(asig, expsegr(4000, 9, 100, 9, 100), 10)
  asig *= expsegr(0.001, 0.01, 1, 1, 0.001) * p5

  ispread = 0.25 * limit(p4, 100, 2000) / 2000 
  al, ar  pan2 asig, random(0.5 - ispread, 0.5 + ispread)

  out(al, ar)
  gal += al * 0.1
  gar += ar * 0.1
endin

/* PERFORMANCE CODE */

opcode ca_stream_play, 0, ii[]Sii
  irule, init_states[], Sinstr, inotenum, iamp xin
  instr_num = nstrnum(Sinstr) + (inotenum / 1000)

  kca = ca_stream(init_states, irule)
  if(changed(kca) == 1) then
    if(kca == 1) then
      event("i", instr_num, 0, -1, cpsmidinn(inotenum), iamp)
    else
      turnoff2(instr_num, 4, 1)
    endif
  endif

endop

opcode rand_iarray, i[],i
  ilen xin 
  iout[] init ilen
  indx = 0
  while (indx < ilen) do
    iout[indx] = (random(0,1) < 0.5) ? 1 : 0
    indx += 1
  od
  xout iout
endop

instr Run	
  ktrig = metro(0.25)

  iendtime = 60 * 10 ;; 10 minutes

  if(timeinsts() < iendtime) then 

    if(ktrig == 1) then
      ca_stream_play(30, rand_iarray(43), "Syn", 60, ampdbfs(-12))
      ca_stream_play(30, rand_iarray(31), "Syn", 72, ampdbfs(-12))
      ca_stream_play(135, rand_iarray(29), "Syn", 36, ampdbfs(-12))
      ca_stream_play(135, rand_iarray(27), "Syn", 48, ampdbfs(-12))
    endif
    
    ktrig = metro(4)

    if(ktrig == 1) then
      ca_stream_play(30, rand_iarray(43), "Syn", 80, ampdbfs(-18))
      ca_stream_play(30, rand_iarray(29), "Syn", 82, ampdbfs(-18))
      ca_stream_play(30, rand_iarray(31), "Syn", 84, ampdbfs(-18))
    endif

    /* ktrig = metro(8)

    if(ktrig == 1) then
      ca_stream_play(30, rand_iarray(43), "Syn", 92, ampdbfs(-24))
      ca_stream_play(30, rand_iarray(29), "Syn", 94, ampdbfs(-24))
      ca_stream_play(30, rand_iarray(31), "Syn", 96, ampdbfs(-24))
    endif
    */
  else
    event("e", 0, 10)
    turnoff2(nstrnum("Syn"), 0, 1)
    turnoff
  endif

endin

seed(0)
schedule("Run", 0, -1)



</CsInstruments>
</CsoundSynthesizer>

