# My DOS repo
This repo attempts to recreate files that I had back when I started programming, in QuickBasic 4.5.  My parents upgraded their PC and my data would have been gone, except I had saved files onto different floppy discs.  I didn't save the files on the floppy discs in the same directory structure as on the original drive, and most of my code isn't portable, so figuring out the directory structure was a challenge.

## Starting up QuickBasic

There are a few command line switches that are important to know about:

/L   Loads the quickbasic library.  Without this switch, you'll see an error about "Subprogram not defined" on a CALL ABSOLUTE line in a subroutine named MouseDriver.
/AH  Allows dynamic arrays of records, fixed-length strings, and numeric data to be larger than 64K each.
/H   Displays the highest resolution possible on your hardware.

https://www.pcjs.org/pubs/pc/reference/microsoft/mspl13/basic/qbprog/

/L is mandatory for some of my programs, and probably /AH as well.

## My Programs
Here are some programs that I made, back in the day:
1. Medieval Massacre
2. PICT13
3. Music Editor
4. The 'Game'