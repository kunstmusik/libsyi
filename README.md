# libsyi - Library of Csound UDO code 

by Steven Yi

## Files

* tdf2.udo - Implementations of Transposed Direct Form II Biquad filter (users
  are directed to use Csound's rbjeq for better performance) 
* waveseq.udo - Wave sequencing oscillator in the spirit of Korg Wavestation
* adsr140.udo - Gated, Retriggerable envelope generator based on Doepfer A-140
  module
* ringmod.udo - Implementation of Julian Parker's digital model of a Ring
  Modulator
* unirect.udo - Generates a unipolar rectangular signal suitable for use as an
  audio-rate gate signal
* audaciouseq.udo - Implementation of a 10-band EQ filter based on code from
  Audacious Media Player
* solina.udo - Chorus effect based on chorus module of Solina String Ensemble 
* gatesig.udo - reads a-rate trigger signal (e.g., from mpulse) and outputs
  gate signal that holds for given time in seconds
* seqsig.udo - reads a-rate trigger signal (e.g., from mpulse) and outputs a
  value from a k-rate array, cycling through the items 
* clock\_div.udo - reads a-rate trigger signal (e.g., from mpulse) and emits a
  slower rate trigger determined by the k-rate division value 
* pattern\_sequencer.udo - 128 pattern sequencer with 8 sequences per pattern,
  inspired by the Doepfer Schaltwerk; contains additional utility opcodes for
  creating and manipulating patterns and sequences 
* shimmer\_reverb.udo - stereo effect with reverb and spectrally processed
  pitch-shifted feedback


## Deprecated

These have been converted to C and added to core Csound. These files are left
here if anyone is interested to study the user-defined code versions.

* k35.udo - low-pass and high-pass filters based on Korg 35 module
  (found in MS-10 and MS-20) 
* zdf\_svf.udo - Zero Delay State Variable Filter 
* zdf.udo - Zero Delay Feedback Filters (zdf\_1pole...)
