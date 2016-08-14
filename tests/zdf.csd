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

#include "../zdf.udo"

	instr 1	 

ifilttype = p4

if(ifilttype == 0) then
  prints "Testing zdf_1pole (low-pass)...\n"
else
  prints "Testing zdf_1pole (high-pass)...\n"
endif

iamp = ampdbfs(-12) 
ipch = cps2pch(8.00, 12)

asig rand 1.0 

kcut = expon(20, p3, 20000) 

alp, ahp zdf_1pole asig, kcut

aout = (ifilttype == 0) ? alp : ahp 

aout = limit(aout, -1.0, 1.0)

outc(aout, aout)

	endin


	instr 2	 

ifilttype = p4

if(ifilttype == 0) then
  prints "Testing zdf_2pole (low-pass)...\n"
elseif(ifilttype == 1) then
  prints "Testing zdf_2pole (band-pass)...\n"
else
  prints "Testing zdf_2pole (high-pass)...\n"
endif

iamp = ampdbfs(-12) 
ipch = cps2pch(8.00, 12)

asig rand 1.0 

kcut = expon(20, p3, 20000) 
kres = expon(0.5, p3, 10) 

alp, abp, ahp zdf_2pole asig, kcut, kres

aout = (ifilttype == 0) ? alp : (ifilttype == 1) ? abp : ahp 

aout = limit(aout, -1.0, 1.0)

outc(aout, aout)

	endin


	instr 3	 
prints "Testing zdf_2pole_notch (notch)...\n"

iamp = ampdbfs(-12) 
ipch = cps2pch(8.00, 12)

asig rand 1.0 

kcut = expon(20, p3, 20000) 
kres = expon(0.5, p3, 10) 

alp, abp, ahp, anotch zdf_2pole_notch asig, kcut, kres

aout = limit(anotch, -1.0, 1.0)

outc(aout, aout)

	endin

</CsInstruments>

<CsScore>

i1 0 8 0  ; zdf_1pole low-pass
i1 10 8 1 ; zdf_1pole high-pass 
i2 20 8 0 ; zdf_2pole low-pass
i2 30 8 1 ; zdf_2pole high-pass 
i2 40 8 1 ; zdf_2pole band-pass 
i3 50 8 1 ; zdf_2pole_notch notch

</CsScore>

</CsoundSynthesizer>
