/* gatesig - outputs gate signal
   uses atrig signal to trigger when sample == 1; holds for
   khold amount of time in seconds */
opcode gatesig, a, ak
  atrig, khold xin

  kcount init 0
  asig init 0

  kndx = 0
  kholdsamps = khold * sr
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      kcount = 0
    endif

    asig[kndx] = (kcount < kholdsamps) ? 1 : 0 

    kndx += 1
    kcount += 1
  od

  xout asig

endop

