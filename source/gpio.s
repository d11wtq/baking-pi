/* -*- Baking Pi tutorial from cam.ac.uk -*-

   GPIO controller functions

   Author:       Chris Corbyn <chris@w3style.co.uk>
   Architecture: armv6
   Hardware:     Raspberry Pi Model B
*/

  /* global function declaration */
  .globl GetGpioAddress

  /* Returns the address of the GPIO controller */
GetGpioAddress:
  /* r0 is always the return value, as per ABI interface */
  ldr r0,=0x20200000
  /* pc is always the next instruction run (i.e. branch) */
  mov pc,lr

  /* global function declaration */
  .globl SetGpioFunction

  /* Enable a given function on a given GPIO pin */
SetGpioFunction:
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

  /* r0 is the pin; since there are only 54, it is 0-53 */
  cmp r0,#53
  /* r1 is the function to enable, 0-7 */
  cmpls r1,#7
  /* return early if neither of the above checks passed */
  movhi pc,lr

  /* put the current caller on the stack */
  push {lr}
  /* don't clobber pin number when returning gpio addr */
  mov r2,r0
  /* store gpio addr to r0 */
  bl GetGpioAddress

  /* find the set of 10 pins containing this pin */
functionLoop$:
  cmp r2,#9
  /* if pin number > 9, subtract 10 */
  subhi r2,#10
  /* if pin number > 9, add 4 bytes to gpio addr */
  addhi r0,#4
  /* keep looping while pin number > 9 */
  bhi functionLoop$

  /* Explanation: Multiplication is a slow operatation, so
     we exploit the fact that a * 3 == a + a * 2. Left-
     shifting by 1 is the same as multiplying by 2, but
     faster.

     The loop above changed r0 so we're in the right block
     of pins, and the remainder of r2 is however many pins
     into the block we need to be. Since it's 3 bits per
     pin, we multiply the remainder by 3, then shift our
     function value left by that many bits to set the right
     bit.
  */

  /* multiply r2 by 3 */
  add r2, r2,lsl #1
  /* shift the function value left accordingly */
  lsl r1,r2
  /* store the computed value to that memory address */
  str r1,[r0]
  /* take the caller back off the stack and return */
  pop {pc}

  /* global function declaration */
  .globl SetGpio

  /* Turns on or off a given GPIO pin */
SetGpio:
  /* aliases for the register numbers, for clarity */
  pinNum .req r0
  pinVal .req r1

  /* guard clause check for pin range */
  cmp pinNum,#53
  movhi pc,lr

  /* we're calling a function, so don't lose our caller */
  push {lr}

  /* don't clobber the pin number */
  mov r2,pinNum
  /* change the alias */
  .unreq pinNum
  pinNum .req r2

  /* get the gpio addr into r0 */
  bl GetGpioAddress
  gpioAddr .req r0

  /* two sets of 32 pins, 4 bytes each, so divide by 32 */
  pinBank .req r3
  lsr pinBank,pinNum,#5
  /* then multiply by 4, to know which block we're in */
  lsl pinBank,#2
  add gpioAddr,pinBank
  .unreq pinBank

  /* discard significant bits in pin numbers 32 and over */
  and pinNum,#31
  /* set the appropriate bit for this pin in this 4-bytes */
  setBit .req r3
  mov setBit,#1
  lsl setBit,pinNum
  .unreq pinNum

  /* test if turning on, or off (0 or 1) */
  teq pinVal,#0
  .unreq pinVal
  /* if = 0, turn off */
  streq setBit,[gpioAddr,#40]
  /* else turn on */
  strne setBit,[gpioAddr,#28]
  .unreq setBit
  .unreq gpioAddr

  /* return back to the caller */
  pop {pc}

/* -*- end of file -*- */
