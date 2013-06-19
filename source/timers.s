/* -*- Baking Pi tutorial from cam.ac.uk -*-

   Timer functions.

   Author:       Chris Corbyn <chris@w3style.co.uk>
   Architecture: armv6
   Hardware:     Raspberry Pi Model B
*/

/* Blocks for N milliseconds before returning */
.globl SleepForDelay
SleepForDelay:
  push {lr}
  delay .req r2
  start .req r3

  /* convert the delay into microseconds */
  ldr delay,=1000
  mul delay,r0,delay
  bl GetCurrentTime
  mov start,r0

sleepLoop$:
  bl GetCurrentTime
  elapsed .req r1
  sub elapsed,r0,start
  cmp elapsed,delay
  .unreq elapsed
  /* keep looping while not enough time elapsed */
  bls sleepLoop$

  .unreq delay
  .unreq start
  pop {pc}

GetTimerAddress:
  ldr r0,=0x20003000
  mov pc,lr

GetCurrentTime:
  push {lr}
  bl GetTimerAddress
  /* load 8 byte timestamp into registers r0, r1 */
  ldrd r0,r1,[r0,#4]
  /* return, but don't care about r1 */
  pop {pc}

/* -*- end of file -*- */
