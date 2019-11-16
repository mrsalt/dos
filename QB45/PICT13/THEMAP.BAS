DECLARE SUB mousehide ()
DECLARE SUB mouseshow ()
DECLARE SUB mousestatus (lb%, rb%, zx%, zy%)
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE FUNCTION MouseInit% ()
OPEN "c:\mark\map.dat" FOR BINARY AS #1
OPEN "c:\mark\worldmap.dat" FOR BINARY AS #2
DIM wholescreen(16001) AS LONG

DIM SHARED mouse$
mouse$ = SPACE$(57)
FOR i% = 1 TO 57
  READ a$
  h$ = CHR$(VAL("&H" + a$))
  MID$(mouse$, i%, 1) = h$

NEXT i%
DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
DATA 8B,5E,06,89,17,5D,CA,08,00

ms% = MouseInit%

colors:
DATA 68,68,71
DATA 25,56,34
DATA 43,29,22
DATA 79,63,41

DATA 17,42,85
DATA 19,44,89
DATA 21,47,94

DATA 23,70,23
DATA 25,75,25
DATA 27,80,27

DATA 19,60,76
DATA 65,44,37
DATA 27,19,16
DATA 90,70,46
DATA 86,86,81
DATA 58,40,35
DATA 22,43,22


SCREEN 13

RESTORE colors
FOR i = 1 TO 17
READ red, green, blue
PALETTE i, 65536 * CINT(blue / 100 * 63) + 256 * CINT(green / 100 * 63) + CINT(red / 100 * 63)
NEXT i

FOR i = 0 TO 16001
GET #1, , wholescreen&(i)
NEXT


PUT (0, 0), wholescreen&

mouseshow
DO
CALL mousestatus(lb%, rb%, zx%, zy%)
IF INKEY$ = CHR$(27) THEN EXIT DO
x = INT(zx% / 6.416667)
y = INT(zy% / 4)
LOCATE 1, 1: PRINT x
LOCATE 2, 1: PRINT y
           
           
            IF lb% = -1 OR rb% = -1 THEN
            IF lb% = -1 THEN c = 6: kind$ = CHR$(27)
            IF rb% = -1 THEN c = 5: kind$ = CHR$(26)

            byteposition& = (x) * 16 + (y) * 10 * (16 * 48)
            x1 = (x * 6.416667)
            y1 = y * 4
            x2 = ((x + 1) * 6.416667) - 1
            y2 = ((y + 1) * 4) - 1

           
            mousehide
            LINE (x1, y1)-(x2, y2), c, BF
            mouseshow

            FOR i = 0 TO 15
            FOR j = 0 TO 9
            PUT #2, byteposition& + i + j * (16 * 48) + 1, kind$
            NEXT
            NEXT
            END IF
LOOP

mousehide
GET (0, 0)-(319, 199), wholescreen
mouseshow

FOR i = 0 TO 16001
PUT #1, , wholescreen&(i)
NEXT

SUB MouseDriver (ax%, bx%, cx%, dx%)
  DEF SEG = VARSEG(mouse$)
  mouse% = SADD(mouse$)
  CALL Absolute(ax%, bx%, cx%, dx%, mouse%)

END SUB

SUB mousehide
 ax% = 2
 MouseDriver ax%, 0, 0, 0

END SUB

FUNCTION MouseInit%
  ax% = 0
  MouseDriver ax%, 0, 0, 0
  MouseInit% = ax%

END FUNCTION

SUB MousePut (x%, y%)
  ax% = 4
  cx% = x%
  dx% = y%
  MouseDriver ax%, 0, cx%, dx%

END SUB

SUB MouseRange (x1%, y1%, x2%, y2%)
  ax% = 7
  cx% = x1%
  dx% = x2%
  MouseDriver ax%, 0, cx%, dx%
  ax% = 8
  cx% = y1%
  dx% = y2%
  MouseDriver ax%, 0, cx%, dx%

END SUB

SUB mouseshow
  ax% = 1
  MouseDriver ax%, 0, 0, 0

END SUB

SUB mousestatus (lb%, rb%, zx%, zy%)
  ax% = 3
  MouseDriver ax%, bx%, cx%, dx%
  lb% = ((bx% AND 1) <> 0)
  rb% = ((bx% AND 2) <> 0)
  zx% = cx%
  zy% = dx%
  zx% = zx% / 2
END SUB

