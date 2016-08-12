; Zero Delay State Variable Filter
; 
; Based on code by Will Pirkle, presented in:
;
; http://www.willpirkle.com/Downloads/AN-4VirtualAnalogFilters.2.0.pdf
; 
; and in his book "Designing software synthesizer plug-ins in C++ : for 
; RackAFX, VST3, and Audio Units"
;
; ZDF using Trapezoidal integrator by Vadim Zavalishin, presented in "The Art 
; of VA Filter Design" (https://www.native-instruments.com/fileadmin/ni_media/
; downloads/pdf/VAFilterDesign_1.1.1.pdf)
;
; Implementation by Oli Larkin in Max/MSP/Gen also consulted:
; https://cycling74.com/forums/topic/zero-delay-feedback-svf-in-gen/
;
; UDO versions by Steven Yi (2016.08.16)

	opcode zdf_svf,aaa,aKK

ain, kcf, kR     xin

; pre-warp the cutoff- these are bilinear-transform filters
kwd = 2 * $M_PI * kcf
iT  = 1/sr 
kwa = (2/iT) * tan(kwd * iT/2) 
kG  = kwa * iT/2 

;; output signals
alp init 0
ahp init 0
abp init 0

;; state for integrators
kz1 init 0
kz2 init 0

;;
kindx = 0
while kindx < ksmps do
  khp = (ain[kindx] - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
  kbp = kG * khp + kz1
  klp = kG * kbp + kz2

  ; z1 register update
  kz1 = kG * khp + kbp  
  kz2 = kG * kbp + klp  

  alp[kindx] = klp
  ahp[kindx] = khp
  abp[kindx] = kbp
  kindx += 1
od

xout alp, abp, ahp


	endop


	opcode zdf_svf,aaa,aaa

ain, acf, aR     xin

iT  = 1/sr 

;; output signals
alp init 0
ahp init 0
abp init 0

;; state for integrators
kz1 init 0
kz2 init 0

;;
kindx = 0
while kindx < ksmps do

  ; pre-warp the cutoff- these are bilinear-transform filters
  kwd = 2 * $M_PI * acf[kindx]
  kwa = (2/iT) * tan(kwd * iT/2) 
  kG  = kwa * iT/2 

  kR = aR[kindx]

  khp = (ain[kindx] - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
  kbp = kG * khp + kz1
  klp = kG * kbp + kz2

  ; z1 register update
  kz1 = kG * khp + kbp  
  kz2 = kG * kbp + klp 

  alp[kindx] = klp
  ahp[kindx] = khp
  abp[kindx] = kbp
  kindx += 1
od

xout alp, abp, ahp


	endop

