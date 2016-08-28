
/* uses global 128 x 8 x 16 k-array
   128 patterns, each pattern made up of 8x16 sequences
   atrigger signal drives each pattern
   kpattern_indx denotes which index to play

   pattern array is global for efficiency as otherwise
   arrays would be copied every k-pass
   */
  
gkpattern_sequencer_all[] init 128 * 8 * 16

opcode patternseq_seqsig, a, aak
  agate, astartIndx, klen xin

  aout init 0
  kpatindx init 15 

  kindx = 0
  while (kindx < ksmps) do
    if(agate[kindx] == 1) then 
      kpatindx = (kpatindx + 1) % klen 
    endif
    kstartIndx = astartIndx[kindx]
    aout[kindx] = gkpattern_sequencer_all[kstartIndx + kpatindx]
    kindx += 1
  od

  xout aout

endop

opcode pattern_sequencer, aaaaaaaa, aa
  atrigger, apattern_indx xin

  apatstart = apattern_indx * 128

  a1 patternseq_seqsig atrigger, apatstart, 16 
  a2 patternseq_seqsig atrigger, apatstart + 16, 16 
  a3 patternseq_seqsig atrigger, apatstart + 32, 16
  a4 patternseq_seqsig atrigger, apatstart + 48, 16
  a5 patternseq_seqsig atrigger, apatstart + 64, 16
  a6 patternseq_seqsig atrigger, apatstart + 80, 16
  a7 patternseq_seqsig atrigger, apatstart + 96, 16
  a8 patternseq_seqsig atrigger, apatstart + 112, 16

  xout a1, a2, a3, a4, a5, a6, a7, a8
endop

instr set_pat_seq_instr
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


opcode set_pattern_seq, 0,iiiiiiiiiiiiiiiiii
 ipat, iseq, i0, i1, i2, i3, i4, i5 ,i6, i7, \
 i8, i9, i10, i11, i12, i13, i14, i15 xin
  event_i "i", "set_pat_seq_instr", 0, 1, \
   ipat, iseq, i0, i1, i2, i3, i4, i5 ,i6, i7, \
   i8, i9, i10, i11, i12, i13, i14, i15
endop

instr copy_pat_seq_instr

  isrcpat_num = p4
  isrcseq_num = p5
  idestpat_num = p6
  idestseq_num = p7

  indx0 = isrcpat_num * 128 + isrcseq_num * 16 
  indx1 = idestpat_num * 128 + idestseq_num * 16 

  prints "Copying pattern %d sequence %d\n to pattern %d sequence %d\n", p4, p5, p6, p7
  gkpattern_sequencer_all[indx1]      = gkpattern_sequencer_all[indx0]     
  gkpattern_sequencer_all[indx1 + 1]  = gkpattern_sequencer_all[indx0 + 1] 
  gkpattern_sequencer_all[indx1 + 2]  = gkpattern_sequencer_all[indx0 + 2] 
  gkpattern_sequencer_all[indx1 + 3]  = gkpattern_sequencer_all[indx0 + 3] 
  gkpattern_sequencer_all[indx1 + 4]  = gkpattern_sequencer_all[indx0 + 4] 
  gkpattern_sequencer_all[indx1 + 5]  = gkpattern_sequencer_all[indx0 + 5] 
  gkpattern_sequencer_all[indx1 + 6]  = gkpattern_sequencer_all[indx0 + 6] 
  gkpattern_sequencer_all[indx1 + 7]  = gkpattern_sequencer_all[indx0 + 7] 
  gkpattern_sequencer_all[indx1 + 8]  = gkpattern_sequencer_all[indx0 + 8] 
  gkpattern_sequencer_all[indx1 + 9]  = gkpattern_sequencer_all[indx0 + 9] 
  gkpattern_sequencer_all[indx1 + 10] = gkpattern_sequencer_all[indx0 + 10]
  gkpattern_sequencer_all[indx1 + 11] = gkpattern_sequencer_all[indx0 + 11]
  gkpattern_sequencer_all[indx1 + 12] = gkpattern_sequencer_all[indx0 + 12]
  gkpattern_sequencer_all[indx1 + 13] = gkpattern_sequencer_all[indx0 + 13]
  gkpattern_sequencer_all[indx1 + 14] = gkpattern_sequencer_all[indx0 + 14]
  gkpattern_sequencer_all[indx1 + 15] = gkpattern_sequencer_all[indx0 + 15]

  turnoff
endin

/* copies sequence from one pattern to another 
   Arguments: isrcpat, isrcseq, idestpat, idestseq
   */
opcode copy_pattern_seq, 0, iiii
  ip0, is0, ip1, is1 xin
  event_i "i", "copy_pat_seq_instr", 0, 1, ip0, is0, ip1, is1
endop

opcode copy_pattern_measure, 0, iiii
  ip0, is0, ip1, is1 xin
  event_i "i", "copy_pat_seq_instr", 0, 1, ip0, is0, ip1, is1
  event_i "i", "copy_pat_seq_instr", 0, 1, ip0 + 1, is0, ip1 + 1, is1
  event_i "i", "copy_pat_seq_instr", 0, 1, ip0 + 2, is0, ip1 + 2, is1
  event_i "i", "copy_pat_seq_instr", 0, 1, ip0 + 3, is0, ip1 + 3, is1
endop
