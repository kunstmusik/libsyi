# libsyi - Library of Csound UDO code 

by Steven Yi

## Files

* tdf2.udo - Implementations of Transposed Direct Form II Biquad filter (users are directed to use Csound's rbjeq for better performance) 
* waveseq.udo - Wave sequencing oscillator in the spirit of Korg Wavestation
* adsr140.udo - Gated, Retriggerable envelope generator based on Doepfer A-140 module
* ringmod.udo - Implementation of Julian Parker's digital model of a Ring Modulator
* unirect.udo - Generates a unipolar rectangular signal suitable for use as an audio-rate gate signal
* audaciouseq.udo - Implementation of a 10-band EQ filter based on code from Audacious Media Player
* solina.udo - Chorus effect based on chorus module of Solina String Ensemble 
* zdf\_svf.udo - Zero Delay State Variable Filter 
* zdf.udo - Zero Delay Feedback Filters (zdf\_1pole...)
* gatesig.udo - reads a-rate trigger signal (e.g., from mpulse) and outputs gate signal that holds for given time in seconds
* seqsig.udo - reads a-rate trigger signal (e.g., from mpulse) and outputs a value from a k-rate array, cycling through the items 
