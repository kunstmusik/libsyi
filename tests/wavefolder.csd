Test for "Virtual Analog Model of the Lockhart Wavefolder"
by Fabián Esqueda, Henri Pöntynen, Julian D. Parker and Stefan Bilbao

Test instrument based on Max patch included at  

http://research.spa.aalto.fi/publications/papers/smc17-wavefolder/

<CsoundSynthesizer>
<CsOptions>
-o dac 
</CsOptions>
; ==============================================
<CsInstruments>

sr	= 88200 ;; as mentioned in paper to get around aliasing	
ksmps	= 64	
nchnls	=	2
0dbfs	=	1

#include "../wavefolder.udo"

instr WaveFolderTest	
  igain = p6  
  idcoffset = p7
  asig = oscili(igain, p4)

  asig += idcoffset

  asig *= 0.333

  asig = wavefolder(asig)
  asig = wavefolder(asig)
  asig = wavefolder(asig)
  asig = wavefolder(asig)

  asig *= 3 * 0.2

  asig = tanh(asig)

  asig *= linen(p5, 0.00, p3, 0.02)

  out(asig, asig)
endin

instr TestMelody 
  imelody[] = array(3,11,4,5, 3,8,20,21)
  itime = times() % 10
  ival = (itime > 5) ? (10 - itime) : itime
  ipercent = ival / 5
  igain = (ipercent * 20) + 0.5

  
  idcoffset = ((times() % 50) / 50) * 0.5

  schedule("WaveFolderTest", 0, p3, cpsmidinn(30 +  imelody[p4]), ampdbfs(-6), igain, idcoffset)
  if(times() < 50) then
    schedule(p1, p3, p3, (p4 + 1) % 8)
  endif
endin

schedule("TestMelody", 0, 0.10, 0)

</CsInstruments>
<CsScore>
f 0 50
</CsScore>
</CsoundSynthesizer>

