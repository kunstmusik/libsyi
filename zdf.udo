
; Zero Delay Feedback Filters
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
; UDO versions by Steven Yi (2016.xx.xx)


;; 1-pole (6dB) lowpass/highpass filter
;; takes in a a-rate signal and cutoff value in frequency
opcode zdf_1pole, aa, ak
  ain, kcf  xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  kwd = 2 * $M_PI * kcf
  iT  = 1/sr 
  kwa = (2/iT) * tan(kwd * iT/2) 
  kg  = kwa * iT/2 

  ; big combined value
  kG  = kg / (1.0 + kg)

  ahp init 0
  alp init 0

  ;; state for integrators
  kz1 init 0

  kindx = 0
  while kindx < ksmps do
    ; do the filter, see VA book p. 46 
    ; form sub-node value v(n) 
    kin = ain[kindx]
    kv = (kin - kz1) * kG 

    ; form output of node + register 
    klp = kv + kz1 
    khp = kin - klp 

    ; z1 register update
    kz1 = klp + kv  

    alp[kindx] = klp
    ahp[kindx] = khp
    kindx += 1
  od

  xout alp, ahp
endop


;; 1-pole (6dB) lowpass/highpass filter
;; takes in a a-rate signal and cutoff value in frequency
opcode zdf_1pole, aa, aa
  ain, acf  xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  iT  = 1/sr 

  ahp init 0
  alp init 0

  ;; state for integrators
  kz1 init 0

  kindx = 0
  while kindx < ksmps do
    ; pre-warp the cutoff- these are bilinear-transform filters
    kwd = 2 * $M_PI * acf[kindx]
    kwa = (2/iT) * tan(kwd * iT/2) 
    kg  = kwa * iT/2 

    ; big combined value
    kG  = kg / (1.0 + kg)

    ; do the filter, see VA book p. 46 
    ; form sub-node value v(n) 
    kin = ain[kindx]
    kv = (kin - kz1) * kG 

    ; form output of node + register 
    klp = kv + kz1 
    khp = kin - klp 

    ; z1 register update
    kz1 = klp + kv  

    alp[kindx] = klp
    ahp[kindx] = khp
    kindx += 1
  od

  xout alp, ahp
endop

;; 1-pole allpass filter
;; takes in an a-rate signal and corner frequency where input
;; phase is shifted -90 degrees
opcode zdf_allpass_1pole, a, ak
  ain, kcf xin
  alp, ahp zdf_1pole ain, kcf
  aout = alp - ahp
  xout aout
endop


;; 1-pole allpass filter
;; takes in an a-rate signal and corner frequency where input
;; phase is shifted -90 degrees
opcode zdf_allpass_1pole, a, aa
  ain, acf xin
  alp, ahp zdf_1pole ain, acf
  aout = alp - ahp
  xout aout
endop


;; 2-pole (12dB) lowpass/highpass/bandpass filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole,aaa,aKK

  ain, kcf, kQ     xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  kwd = 2 * $M_PI * kcf
  iT  = 1/sr 
  kwa = (2/iT) * tan(kwd * iT/2) 
  kG  = kwa * iT/2 
  kR  = 1 / (2 * kQ)

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


;; 2-pole (12dB) lowpass/highpass/bandpass filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole,aaa,aaa

  ain, acf, aQ     xin

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

    kR = 1 / (2 * aQ[kindx]) 

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

;; 2-pole (12dB) lowpass/highpass/bandpass/notch filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole_notch,aaaa,aKK

  ain, kcf, kQ     xin

  ; pre-warp the cutoff- these are bilinear-transform filters
  kwd = 2 * $M_PI * kcf
  iT  = 1/sr 
  kwa = (2/iT) * tan(kwd * iT/2) 
  kG  = kwa * iT/2 
  kR  = 1 / (2 * kQ)

  ;; output signals
  alp init 0
  ahp init 0
  abp init 0
  anotch init 0

  ;; state for integrators
  kz1 init 0
  kz2 init 0

  ;;
  kindx = 0
  while kindx < ksmps do
    kin = ain[kindx]
    khp = (kin - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
    kbp = kG * khp + kz1
    klp = kG * kbp + kz2
    knotch = kin - (2 * kR * kbp)

    ; z1 register update
    kz1 = kG * khp + kbp  
    kz2 = kG * kbp + klp  

    alp[kindx] = klp
    ahp[kindx] = khp
    abp[kindx] = kbp
    anotch[kindx] = knotch
    kindx += 1
  od

  xout alp, abp, ahp, anotch

endop

;; 2-pole (12dB) lowpass/highpass/bandpass/notch filter
;; takes in a a-rate signal, cutoff value in frequency, and
;; Q factor for resonance
opcode zdf_2pole_notch,aaaa,aaa

  ain, acf, aQ     xin

  iT  = 1/sr 

  ;; output signals
  alp init 0
  ahp init 0
  abp init 0
  anotch init 0

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

    kR = 1 / (2 * aQ[kindx])

    kin = ain[kindx]
    khp = (kin - (2 * kR + kG) * kz1 - kz2) / (1 + (2 * kR * kG) + (kG * kG))
    kbp = kG * khp + kz1
    klp = kG * kbp + kz2
    knotch = kin - (2 * kR * kbp)

    ; z1 register update
    kz1 = kG * khp + kbp  
    kz2 = kG * kbp + klp 

    alp[kindx] = klp
    ahp[kindx] = khp
    abp[kindx] = kbp
    anotch[kindx] = knotch
    kindx += 1
  od

  xout alp, abp, ahp, anotch

endop

;; TODO - implement
opcode zdf_peak_eq, a, akkk
  ain, kcf, kres, kdB xin

  aout init 0

  xout aout
endop

opcode zdf_high_shelf_eq, a, akk
  ain, kcf, kdB xin

  aout init 0

  xout aout
endop

opcode zdf_low_shelf_eq, a, akk
  ain, kcf, kdB xin

  aout init 0

  xout aout
endop
