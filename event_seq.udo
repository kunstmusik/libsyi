
opcode event_seq, 0, aSK
  atrig, Sinstr_nam, kdur xin

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      event "i", Sinstr_nam, 0, kdur
    endif
    kndx += 1
  od
endop


opcode event_seq, 0, aSKK
  atrig, Sinstr_nam, kdur, kp4 xin

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      event "i", Sinstr_nam, 0, kdur, kp4
    endif
    kndx += 1
  od
endop


opcode event_seq, 0, aSKKK
  atrig, Sinstr_nam, kdur, kp4, kp5 xin

  kndx = 0
  while (kndx < ksmps) do
    if(atrig[kndx] == 1) then
      event "i", Sinstr_nam, 0, kdur, kp4, kp5
    endif
    kndx += 1
  od
endop
