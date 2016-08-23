/* clock_div - divides clock signal by given integer amount
   uses atrig signal to trigger when sample == 1 */


opcode clock_div, a, ak
  atrig, kdiv xin
  
  kcount init 1000 
  asig init 0

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      kcount += 1

      if(kcount >= kdiv) then
        asig[kndx] = 1
        kcount = 0
      else
        asig[kndx] = 0
      endif
    else
      asig[kndx] = 0
    endif

    kndx += 1
  od
 
  xout asig
endop

