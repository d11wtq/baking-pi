/* -*- Baking Pi tutorial from cam.ac.uk -*-

   Linker script to build kernel.img.

   Author:       Chris Corbyn <chris@w3style.co.uk>
*/

SECTIONS {
    .init 0x0000 : {
        *(.init)
    }

    /* The main code needs to start well beyond address 100
       since that space gets rewritten.
    */
    .text 0x8000 : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    /DISCARD/ : {
        *(*)
    }
}
