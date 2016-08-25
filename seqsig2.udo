/* seqsig - plays sequence of values from k-array and outputs
   a-rate signal
*/

#ifndef SEQSIG_UDO2
#define SEQSIG_UDO2 # 1 #

opcode seqsig2, a, ak[]kk
  agate, kpattern[], kstartIndx, klen xin

  aout init 0
  kpatindx init -1 

  kindx = 0
  while (kindx < ksmps) do
    if(agate[kindx] == 1) then 
      kpatindx = (kpatindx + 1) % klen 
    endif

    aout[kindx] = kpattern[kpatindx]
    kindx += 1
  od

  xout aout

endop

#endif

