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

  /* enable the led */
  mov r0,#16
  mov r1,#1
  bl SetGpioFunction

mainLoop$:

  /* blink the led on */
  bl WaitForInterval
  mov r0,#16
  mov r1,#0
  bl SetGpio

  /* blink the led off */
  bl WaitForInterval
  mov r0,#16
  mov r1,#1
  bl SetGpio

  /* repeat forever */
  b mainLoop$

/* Sleep for 2 seconds */
WaitForInterval:
  push {lr}
  ldr r0,=2000
  bl SleepForDelay
  pop {pc}

/* -*- end of file -*- */
