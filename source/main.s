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

/* executable entry point */
.globl _start
_start:
  b main

/* text section contains the main code */
.section .text

/* main routine */
main:
  /* start the stack at position 8000 (allow some space) */
  mov sp,#0x8000

  /* enable output on the led */
  mov r0,#16
  mov r1,#1
  bl SetGpioFunction

  ptrn .req r4
  mask .req r5
  /* create a pointer to the sequence bitmap */
  ldr ptrn,=blink_sequence
  /* load the bitmap into the register */
  ldr ptrn,[ptrn]
  /* the current bit to mask */
  mov mask,#1
mainLoop$:
  mov r0,#16
  /* set the led state to the result of masking */
  mov r1,mask
  and r1,ptrn
  bl SetGpio
  bl WaitForInterval
  /* mov the bit in the mask for next iteration */
  lsl mask,#1
  /* if the mask overflowed, reset it to 1 */
  movcs mask,#1
  b mainLoop$
  .unreq ptrn
  .unreq mask

/* Sleep for 250 milliseconds */
WaitForInterval:
  push {lr}
  ldr r0,=250
  bl SleepForDelay
  pop {pc}

/* constants are kept in the .data section */
.section .data

/* morse code pattern: 1 = led on, 0 = led off */
.align 2 /* keep in neat 4-byte (2^2) blocks */
blink_sequence:
  .int 0b11111111101010100010001000101010

/* -*- end of file -*- */
