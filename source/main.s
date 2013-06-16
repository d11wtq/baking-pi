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
  .text

  /* required declaration for the linker */
  .globl _start

  /* begin main program instructions */
_start:
  /* load address of GPIO controller to register r0 */
  ldr r0,gpio_ctrl

  /* Explanation: The GPIO controller allocates 4 bytes for
     each 10 pins. There are 54 pins, ~ 6 x 4 = 24 bytes of
     space. Each 4 btes is sub-divided to 3 bits per pin.
     Since we need the 16th pin, we want 3 x 6 bits within
     the correct set of pins. That's 6 x 3 = 18 bits, hence
     the left-shift 18 bits. We then store the bit for the
     address of the pin to the memory location of the GPIO
     controller (from r0), offset by 4 bytes, so that we're
     operating on the second set of 10 pins (10-19).

     This doesn't do anything yet; we're simply 'marking'
     the pin, before we send an instruction to a different
     memory location to turn the pin 'off' (it's backwards)
     thus turning the LED 'on'.
  */

  /* put the number 1 to register r1 */
  mov r1,#1
  /* left-shift the value in r1 by 18 bits */
  lsl r1,#18
  /* store value at r1 to mem r0, offset 4 bytes (pin 16) */
  str r1,[r0,#4]

  /* Explanation: The instruction to turn 'off' a GPIO pin
     involves writing to the memory address 40 bytes into
     the GPIO controller. We write the bit for the pin that
     needs to be turned off. Conversely, offset 28 is used
     to turn a pin 'on' instead of off.
  */

  mov r1,#1
  /* left-shift to just the 16th bit, for the 16th pin */
  lsl r1,#16

blink_on:
  /* store value to r0, offset 40 bytes (turn off) */
  str r1,[r0,#40]
  mov r2,#0x3F0000

  /* waste time subtracting 1 from big number */
wait1$:
  sub r2,#1
  cmp r2,#0
  bne wait1$

blink_off:
  /* store value to r0, offset 28 bytes (turn on) */
  str r1,[r0,#28]
  mov r2,#0x3F0000

  /* waste time subtracting 1 from big number */
wait2$:
  sub r2,#1
  cmp r2,#0
  bne wait2$
  /* branch back to on state */
  b blink_on

  /* address of GPIO controller */
gpio_ctrl:
  .word 0x20200000

/* -*- end of file -*- */
