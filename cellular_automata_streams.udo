/* Implementation of 1-dimensional (Elementary) Cellular Automata as a
  stream using feedback and circular buffer delay line. Stream
  generates 1 (Live) and 0 (Dead) values, according to initial state
  and rule. 

  Initial state may be any length array.  Different array lengths
  affects the rate of mutation, comparable to classical cellular
  automata implementations that use a fixed array as value between CA
  processing steps.  

  Rule numbers are implemented using Wolfram-style encoding where
  number is interpreted as bits. This allows user to use Wolfram rule
  numbers. For example, Rule 30 gives bit value of 00011110.
*/

opcode ca_print_rule, 0, i
  irule xin
  prints("Rule %d: %d %d %d %d %d %d %d %d\n",
    irule,
    (irule >> 7) & 1, (irule >> 6) & 1, 
    (irule >> 5) & 1, (irule >> 4) & 1, 
    (irule >> 3) & 1, (irule >> 2) & 1, 
    (irule >> 1) & 1, irule & 1)
endop

opcode ca_eval, i, iiii
  irule, ival0, ival1, ival2 xin
  ival = (ival0 << 2) | (ival1 << 1) | ival2

  iout = (irule >> ival) & 1

  xout iout
endop

opcode ca_eval, k, kkkk
  krule, kval0, kval1, kval2 xin
  kval = (kval0 << 2) | (kval1 << 1) | kval2

  kout = (krule >> kval) & 1

  xout kout
endop

/** Cellular Automata Stream
  Given initial states and rule number, generates a stream
  of 1's and 0's according to 1D cellular automata processing.
  */
opcode ca_stream, k, i[]i
  initial_states[], irule xin

  ilen = lenarray(initial_states)

  ;; create and populate delay-line for cells
  kindx init 0
  indx = 0
  kgoto skipPerf
  ;; only run this once at init-time
  kstates[] = initial_states
  skipPerf:

  prints("Cellular Automata Stream: Len: %d\n", ilen)
  ca_print_rule(irule)


  ;; evaluate indx, indx + 1, and indx + 2 for the next value
  k0 = kstates[kindx]
  k1 = kstates[(kindx + 1) % ilen]
  k2 = kstates[(kindx + 2) % ilen]
  kval = ca_eval(irule, k0, k1, k2)

  ;; write new value into current kindx, which becomes the 
  ;; end of the ring buffer after update kindx 
  kstates[kindx] = kval 
  kindx = (kindx + 1) % ilen

  xout kval
endop

