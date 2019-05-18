/* wavefolder.udo

Port of Max/gen~ version of "Virtual Analog Model of the Lockhart Wavefolder"
by Fabián Esqueda, Henri Pöntynen, Julian D. Parker and Stefan Bilbao

http://research.spa.aalto.fi/publications/papers/smc17-wavefolder/

Csound UDO version by Steven Yi (2019.05.17)

*/

/*ANTIALIASED LOCKHART WAVEFOLDER*/

;; Custom Lambert-W Function
opcode wavefolder_lambert, k, kk
  kx, kLn1 xin

  ithresh = 10e-10
  kw = kLn1
  kndx = 0
  while (kndx < 1000) do
    kexpw = pow:k($M_E, kw)

    kp = kw * kexpw - kx
    kR = (kw + 1) * kexpw
    ks = (kw + 2) / (2 * (kw+1))        
    kerr = (kp / (kR - (kp * ks)))
    
    if (abs(kerr) < ithresh) then 
      kndx = 1000
    else 
      kw = kw - kerr;
       
      kndx += 1

    endif
    
  od
 
  xout kw
endop

opcode wavefolder, a,a
  ain xin
  asig init 0
 
  ;; State
  kLn1 init 0
  kFn1 init 0
  kxn1 init 0

  ;; Constants
  iRL = 7.5e3;
  iR = 15e3;  
  iVT = 26e-3;
  iIs = 10e-16;

  ia = 2*iRL/iR
  ib = (iR+2*iRL)/(iVT*iR)
  id = (iRL*iIs)/iVT

  
  ;; Antialiasing error threshold
  ithresh = 10e-10

  kndx = 0
  while (kndx < ksmps) do
    kin = ain[kndx]
    kout init 0

    ;; Compute Antiderivative
    kl = signum(kin)
    ku = id * pow($M_E,kl * ib * kin)
    kLn = wavefolder_lambert(ku, kLn1)
    kFn = (0.5 * iVT / ib) * (kLn * (kLn + 2)) - 0.5 * ia * kin * kin 

    ;; Check for ill-conditioning
    if (abs(kin-kxn1) < ithresh) then 
            
        // Compute Averaged Wavefolder Output
        kxn = 0.5 * (kin + kxn1)
        ku = id * pow($M_E,kl * ib * kxn)
        kLn = wavefolder_lambert(ku,kLn1)
        kout = kl * iVT * kLn - ia * kxn;

    else 
        
        ;; Apply AA Form
        kout = (kFn - kFn1) / (kin - kxn1)
        
    endif 

    aout[kndx] = kout

    ;; Update States
    kLn1 = kLn;
    kFn1 = kFn;
    kxn1 = kin;

    kndx += 1
  od

  xout aout
endop



