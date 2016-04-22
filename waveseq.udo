
/* waveseq_preposc - utility UDO for waveseq to setup tables to use */

opcode waveseq_preposc,kkkkkk,iKKK

iwaveseqtab, koscTableStart, kdurUnit, kosc2fadenum xin

kosc1table table koscTableStart, iwaveseqtab
kosc1table_sr table koscTableStart + 1, iwaveseqtab
kosc1amp table koscTableStart + 2, iwaveseqtab
kosc1fadenum table koscTableStart + 4, iwaveseqtab
kosc1repeat table koscTableStart + 5, iwaveseqtab

kosc1repeat = kosc2fadenum + kosc1repeat  
kosc1fadeStart = kosc1repeat - kosc1fadenum

kosc1repeat = int(kosc1repeat * kdurUnit)
kosc1fadeStart = int(kosc1fadeStart * kdurUnit)


xout kosc1table, kosc1table_sr, kosc1amp, kosc1fadenum, kosc1repeat, kosc1fadeStart

endop

/* waveseq - oscillator for wave sequencing */

opcode waveseq,a,KiO

kfreq, iwaveseqtab, ktempo xin

setksmps 1

iSubTableSize init 6
ioscTableStart init 5
inumwaves table 0, iwaveseqtab

iplaymode table 1, iwaveseqtab
kplayincr init 1

istartwave table 2, iwaveseqtab
iloopstart table 3, iwaveseqtab
iloopend table 4, iwaveseqtab

kwaveindex init istartwave
kxfade init 0

kosc1active init 1
kosc1table init 0
kosc1amp init 1
kosc1table_sr init 0
kosc1index init 0
kosc1kcnt init 0
kosc1repeat init 0
kosc1fadenum init 0
kosc1fadeStart init 0

kosc2active init 0
kosc2table init 0
kosc2amp init 1
kosc2table_sr init 0
kosc2index init 0
kosc2kcnt init 0
kosc2repeat init 0
kosc2fadenum init 0
kosc2fadeStart init 0

kfadeval init 0

kfirstwave init 1

aout init 0

/* MACROS ======================================== */

#define INCR_WAVEINDEX #
kwaveindex = kwaveindex + kplayincr

if(kwaveindex > iloopend) then
  if(iplaymode == 1) then
    kplayincr = -1
    kwaveindex = kwaveindex - 2
  else
    kwaveindex = iloopstart
  endif
elseif(kwaveindex < iloopstart) then
  kplayincr = 1
  kwaveindex = iloopstart + 1
endif
#

/* END MACROS ========================================  */


if(ktempo > 0) then
  kdurUnit = ((60 / ktempo) / 24) * kr
else
  kdurUnit = .024 * kr
endif

if(kfirstwave == 1) then

kosc1table, kosc1table_sr, kosc1amp, kosc1fadenum, \
    kosc1repeat, kosc1fadeStart waveseq_preposc iwaveseqtab, ioscTableStart + (istartwave * iSubTableSize), kdurUnit, 0

  kfirstwave = 0
else
  aout init 0
endif

kincr = kfreq * (1 / sr)

  ;kcount = 0

  ;until(kcount >= ksmps) do

if(kosc1active == 1) then

  kosc1kcnt = kosc1kcnt + 1 

  if(kosc1table_sr == 0) then

    a1 tablexkt kosc1index, kosc1table, 0, 4, 1, 0, 1
    kosc1index = kosc1index + kincr

    if(kosc1index > 1.0) then
      kosc1index = kosc1index - 1.0
    endif
  else 
    if(kosc1table_sr > 0) then
      a1 tablexkt kosc1index, kosc1table, 0, 4, 0, 0, 0
    else
      a1 tablexkt kosc1index, kosc1table, 0, 4, 0, 0, 1
    endif

    kosc1index = kosc1index + (abs(kosc1table_sr) / sr )

  endif


  if(kosc1kcnt == kosc1fadeStart) then
    kosc2active = 1
    kosc2kcnt = 0

    $INCR_WAVEINDEX

    ktabStart = iSubTableSize * kwaveindex + ioscTableStart

    kosc2table, kosc2table_sr, kosc2amp, kosc2fadenum, \
      kosc2repeat, kosc2fadeStart waveseq_preposc iwaveseqtab, ktabStart, kdurUnit, kosc1fadenum
    kosc2index = 0
  endif

  if(kosc1kcnt >= kosc1fadeStart) then
    kfadeval = (kosc1kcnt - kosc1fadeStart) / (kosc1fadenum * kdurUnit)
  endif

  if(kosc1kcnt >= kosc1repeat) then
    kosc1active = 0
    kfadeval = 1
  endif

else
  a1 = 0
endif

if(kosc2active == 1) then

  if(kosc2table_sr == 0) then

    a2 tablexkt kosc2index, kosc2table, 0, 4, 1, 0, 1
    kosc2index = kosc2index + kincr

    if(kosc2index > 1.0) then
      kosc2index = kosc2index - 1.0
    endif
  else 
    if(kosc2table_sr > 0) then
      a2 tablexkt kosc2index, kosc2table, 0, 4, 0, 0, 0
    else
      a2 tablexkt kosc2index, kosc2table, 0, 4, 0, 0, 1
    endif

    kosc2index = kosc2index + ksmps * (abs(kosc2table_sr) / sr )
  endif


  kosc2kcnt = kosc2kcnt + 1

  if(kosc2kcnt == kosc2fadeStart) then

    kosc1active = 1
    kosc1kcnt = 0

    $INCR_WAVEINDEX

    ktabStart = iSubTableSize * kwaveindex + ioscTableStart

    kosc1table, kosc1table_sr, kosc1amp, kosc1fadenum, \
      kosc1repeat, kosc1fadeStart waveseq_preposc iwaveseqtab, ktabStart, kdurUnit, kosc2fadenum
      kosc1index = 0
  endif

  if(kosc2kcnt >= kosc2fadeStart) then
    kfadeval = 1 - ((kosc2kcnt - kosc2fadeStart) / (kosc2fadenum * kdurUnit))
  endif

  if(kosc2kcnt >= kosc2repeat) then
    kosc2active = 0
    kfadeval = 0
  endif

else
  a2 = 0
endif

aout sum a1 * kosc1amp * (1 - kfadeval), a2 * kosc2amp * kfadeval

xout aout

#undef INCR_WAVEINDEX

endop

