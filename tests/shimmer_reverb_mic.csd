Title: Shimmer Reverb
Author: Steven Yi
Date: 2018.08.22

Description:

Shimmer Reverb using reverb tail that is delayed and fed back into itself after being pitch-shifted using and FFT-based approach 
Version using microphone as input

<CsoundSynthesizer>
<CsOptions>
-i adc -o dac --port=10000
</CsOptions>
<CsInstruments>

sr	=	48000
ksmps	= 32	
nchnls=	2
nchnls_i =	1
0dbfs	=	1

#include "../shimmer_reverb.udo"

instr ShimmerReverb 
  ain = inch(1)
  al = ain 
  ar = ain

	al, ar shimmer_reverb al, ar, 100, .95, 16000, 0.45, 100, 1.5 

  out(al, ar)
  
endin
schedule("ShimmerReverb", 0, -1)


</CsInstruments>
; ==============================================
<CsScore>

</CsScore>
</CsoundSynthesizer>

