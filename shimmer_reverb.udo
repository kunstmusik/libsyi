/* shimmer_reverb - stereo effect with reverb and spectrally processed pitch-shifted feedback

	Inputs:
		al - left input audio signal
		ar - right input audio signal 
		kpredelay - delay time in milliseconds for pre-delay of input signal before entering reverb 
		krvbfblvl - feedback setting for reverbsc (a large setting like 0.95 can be nice)
		krvbco - cutoff setting for reverbsc (affects brightness of effect)
		kfblvl - feedback amount for delayed signal that is fed back into reverb (0.45 is a good value to start with)
		kfbdeltime - delay time in milliseconds for delayed signal that is fed back into reverb (start with 100)
		kratio - amount to transpose feedback signal by. 2 transposes by octaves, 1.5 is up by fifths, etc.
			
*/
opcode shimmer_reverb, aa, aakkkkkk
	al, ar, kpredelay, krvbfblvl, krvbco, kfblvl, kfbdeltime, kratio  xin

  ; pre-delay
  al = vdelay3(al, kpredelay, 1000)
  ar = vdelay3(ar, kpredelay, 1000)
 
  afbl init 0
  afbr init 0

  al = al + (afbl * kfblvl)
  ar = ar + (afbr * kfblvl)

  ; important, or signal bias grows rapidly
  al = dcblock2(al)
  ar = dcblock2(ar)

	; tanh for limiting
  al = tanh(al)
  ar = tanh(ar)

  al, ar reverbsc al, ar, krvbfblvl, krvbco 

  ifftsize  = 2048 
  ioverlap  = ifftsize / 4 
  iwinsize  = ifftsize 
  iwinshape = 1; von-Hann window 

  fftin     pvsanal al, ifftsize, ioverlap, iwinsize, iwinshape 
  fftscale  pvscale fftin, kratio, 0, 1
  atransL   pvsynth fftscale

  fftin2    pvsanal ar, ifftsize, ioverlap, iwinsize, iwinshape 
  fftscale2 pvscale fftin2, kratio, 0, 1
  atransR   pvsynth fftscale2

  ;; delay the feedback to let it build up over time
  afbl = vdelay3(atransL, kfbdeltime, 4000)
  afbr = vdelay3(atransR, kfbdeltime, 4000)

  xout al, ar
endop
