/* seqsig - plays sequence of values from k-array and outputs
   a-rate signal
*/

opcode seqsig, a, ak[]
  agate, kpattern[] xin

  aout init 0
  karrlen = lenarray:k(kpattern)
  kpatindx init (lenarray:i(kpattern) - 1)

  kindx = 0
  while (kindx < ksmps) do
    if(agate[kindx] == 1) then 
      kpatindx = (kpatindx + 1) % karrlen
    endif

    aout[kindx] = kpattern[kpatindx]
    kindx += 1
  od

  xout aout

endop

