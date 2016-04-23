/* unirect - generates a unipolar rectangular signal
 * suitable for use as an audio-rate periodic gate signal
 *
 * aout unirect kfreq, kduty
 *
 * OUTPUT
 *   aout - gate signal (1 or 0)
 *
 * INPUT
 *   kfreq - frequency of signal
 *   kduty - duty cycle of rectangle
 *
 * Author: Steven Yi
 * Date: 2016.04.23
 */

opcode unirect, a, kk

kfreq, kduty xin

ktime init 0
aout  init 0

kndx = 0

kdur = sr / kfreq
kduty_on = kduty * kdur

while (kndx < ksmps) do
  aout[kndx] = (ktime < kduty_on) ? 1 : 0

  ktime += 1

  if (ktime >= kdur) then
    ktime = 0
  endif

  kndx += 1
od

xout aout

endop

