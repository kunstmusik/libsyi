<CsoundSynthesizer>
<CsOptions>
</CsOptions>
; ==============================================
<CsInstruments>

sr	=	48000
ksmps	=	1
nchnls	=	2
0dbfs	=	1

#include "../k35.udo"

instr 1	

asig = vco2(0.5, cps2pch(6.00, 12))
asig = k35_lpf(asig, expseg:a(10000, p3, 30), 9.9, 0, 1)
asig *= 0.25
asig  = limit(asig, -1.0, 1.0)

outc(asig, asig)

endin


instr 2	

asig = vco2(0.5, cps2pch(6.00, 12))
asig = k35_lpf(asig, expseg:k(10000, p3, 30), 9.9, 0, 1)
asig *= 0.25
asig  = limit(asig, -1.0, 1.0)

outc(asig, asig)

endin

instr 3	

asig = vco2(0.5, cps2pch(6.00, 12))
asig = k35_hpf(asig, expseg:a(10000, p3, 30), 9.9, 0, 1)
asig *= 0.25
asig  = limit(asig, -1.0, 1.0)

outc(asig, asig)

endin


instr 4	

asig = vco2(0.5, cps2pch(6.00, 12))
asig = k35_hpf(asig, expseg:k(10000, p3, 30), 9.9, 0, 1)
asig *= 0.25
asig  = limit(asig, -1.0, 1.0)

outc(asig, asig)

endin

instr ms20_drum

ipch = cps2pch(p4, 12)
iamp = ampdbfs(p5)
aenv = expseg(20000, 0.05, ipch, p3 - .05, ipch)

asig = rand(1.0)
asig = k35_hpf(asig, 1000, 7, 0, 1)
asig = k35_lpf(asig, aenv, 9.8, 0, 1)

asig = tanh(asig * 8)

asig *= expon(iamp, p3, 0.0001)

outc(asig, asig)

endin

gktempo = 122

instr drums
  istep = p4 

  if(istep % 4 == 0) then
    schedule("ms20_drum", 0, 0.5, 4.00, -12)
  endif

  schedule("ms20_drum", 0, 0.125, 14.00, 
           (istep % 4 == 0) ? -12 : -18)

  if(istep == 4 || istep == 14) then
    schedule("ms20_drum", 0, 0.25, 11.00, -12)
  elseif (istep == 6 || istep == 12) then
    schedule("ms20_drum", 0, 0.25, 11.06, -12)
  endif

  schedule("drums", 60 / (112 * 4), 0.1, (istep + 1) % 16)
endin

</CsInstruments>
; ==============================================
<CsScore>
i1 0 5.0
i2 5 5.0
i3 10 5.0
i4 15 5.0

i "drums" 20 0.5 0
f0 3600

/*i"ms20_drum" 20 0.5 4.00 -12*/
/*i"ms20_drum" + 0.5 4.00 -12*/
/*i"ms20_drum" + 0.5 4.00 -12*/
/*i"ms20_drum" + 0.5 4.00 -12*/

/*i"ms20_drum" 20 0.125 14.00 -12*/
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */
/*i"ms20_drum" + . . . */


/*i"ms20_drum" 20.5 0.25 11.00 -12*/
/*i"ms20_drum" + .  11.06 .*/
/*i"ms20_drum" 21.5 0.25 11.06 -12*/
/*i"ms20_drum" + .  11.00 .*/

</CsScore>
</CsoundSynthesizer>

