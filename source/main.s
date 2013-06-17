/* -*- Baking Pi tutorial from cam.ac.uk -*-

   This is just the code that is written during the
   'Baking Pi' course from the University of Cambridge,
   likely with some adjustments as I've played around with
   the code for exploratory purposes.

   The addresses of the various hardware components are
   only known from reading the manufacturers' manuals.

   Author:       Chris Corbyn <chris@w3style.co.uk>
   Architecture: armv6
   Hardware:     Raspberry Pi Model B
*/

  /* place all code at the start of the output */
  .section .init

  /* required declaration for the linker */
  .globl _start

  /* executable entry point */
_start:
  b main

  /* text section contains the main code */
  .section .text

  /* main routine */
main:
  /* start the stack at position 8000 (allow some space) */
  mov sp,#0x8000

enable_led:
  mov r0,#16
  mov r1,#1
  bl SetGpioFunction

loop$:

blink_on:
  mov r0,#16
  mov r1,#0
  bl SetGpio

  mov r2,#0x3F0000
  /* waste time subtracting 1 from big number */
wait1$:
  sub r2,#1
  cmp r2,#0
  bne wait1$

blink_off:
  mov r0,#16
  mov r1,#1
  bl SetGpio

  mov r2,#0x3F0000
  /* waste time subtracting 1 from big number */
wait2$:
  sub r2,#1
  cmp r2,#0
  bne wait2$

  /* repeat forever */
  b loop$

/* -*- end of file -*- */
