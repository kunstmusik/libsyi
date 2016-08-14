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

	instr 4	 
prints "Testing zdf_allpass_1pole as phaser...\n"

iamp = ampdbfs(-12) 
ipch = cps2pch(8.00, 12)

adry = vco2(1, ipch) 
adry += vco2(1, cps2pch(8.03, 12)) 
adry += vco2(1, cps2pch(7.07, 12)) 
adry += vco2(1, cps2pch(6.00, 12), 0) 
adry *= 0.25 * iamp

adry, ahp, abp zdf_2pole adry, 6000, 0.25 

;; simple phaser
kcut = (lfo(0.75, 0.5, 0) + 1) * 3000

awet zdf_allpass_1pole adry, kcut
awet zdf_allpass_1pole awet, kcut
awet zdf_allpass_1pole awet, kcut

kmix = lfo(0.1, 0.75, 0) + 0.5 

aout = ntrpol(awet, adry, kmix) 

aout = limit(aout, -1.0, 1.0)

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

i4 60 8 1 ; zdf_allpas_1pole

</CsScore>

</CsoundSynthesizer>
