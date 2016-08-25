
/* uses global 128 x 8 x 16 k-array
   128 patterns, each pattern made up of 8x16 sequences
   atrigger signal drives each pattern
   kpattern_indx denotes which index to play

   pattern array is global for efficiency as otherwise
   arrays would be copied every k-pass
   */
  
;#include "seqsig.udo"

gkpattern_sequencer_all[] init 128 * 8 * 16

opcode patternseq_seqsig, a, akk
  agate, kstartIndx, klen xin

  aout init 0
  kpatindx init 15 

  kindx = 0
  while (kindx < ksmps) do
    if(agate[kindx] == 1) then 
      kpatindx = (kpatindx + 1) % klen 
    endif

    aout[kindx] = gkpattern_sequencer_all[kstartIndx + kpatindx]
    kindx += 1
  od

  xout aout

endop

opcode pattern_sequencer, aaaaaaaa, ak
  atrigger, kpattern_indx xin

  kpatstart = kpattern_indx * 128

  a1 patternseq_seqsig atrigger, kpatstart, 16 
  a2 patternseq_seqsig atrigger, kpatstart + 16, 16 
  a3 patternseq_seqsig atrigger, kpatstart + 32, 16
  a4 patternseq_seqsig atrigger, kpatstart + 48, 16
  a5 patternseq_seqsig atrigger, kpatstart + 64, 16
  a6 patternseq_seqsig atrigger, kpatstart + 80, 16
  a7 patternseq_seqsig atrigger, kpatstart + 96, 16
  a8 patternseq_seqsig atrigger, kpatstart + 112, 16

  xout a1, a2, a3, a4, a5, a6, a7, a8
endop

instr set_pattern_seq
  ipatNum = p4
  iseqnum = p5

  indx = p4 * 128 + iseqnum * 16 
  prints "Setting pattern %d sequence %d\n", p4, p5 
  gkpattern_sequencer_all[indx] = p6
  gkpattern_sequencer_all[indx + 1] = p7
  gkpattern_sequencer_all[indx + 2] = p8
  gkpattern_sequencer_all[indx + 3] = p9
  gkpattern_sequencer_all[indx + 4] = p10
  gkpattern_sequencer_all[indx + 5] = p11
  gkpattern_sequencer_all[indx + 6] = p12
  gkpattern_sequencer_all[indx + 7] = p13
  gkpattern_sequencer_all[indx + 8] = p14
  gkpattern_sequencer_all[indx + 9] = p15
  gkpattern_sequencer_all[indx + 10] = p16
  gkpattern_sequencer_all[indx + 11] = p17
  gkpattern_sequencer_all[indx + 12] = p18
  gkpattern_sequencer_all[indx + 13] = p19
  gkpattern_sequencer_all[indx + 14] = p20
  gkpattern_sequencer_all[indx + 15] = p21

  turnoff
endin
