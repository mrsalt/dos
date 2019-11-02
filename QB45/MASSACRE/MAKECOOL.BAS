SCREEN 12 'unfortunately, it will not make it all the way across

DIM byte AS STRING * 1
OPEN "worldmap.dat" FOR BINARY AS #1

a! = TIMER
RANDOMIZE TIMER
FOR i = 0 TO 48 * 16
FOR j = 0 TO 48 * 10
byteposition& = i + j * (48 * 16) + 1
GET #1, byteposition&, byte$

s = ASC(byte)

SELECT CASE s
CASE 44 TO 55             'shores
     shores& = shores& + 1
CASE 26                   ' ocean
     ocean& = ocean& + 1
     v = INT(RND * 3) + 1
     SELECT CASE v
     CASE 1: byte$ = CHR$(26)
     CASE 2: byte$ = CHR$(119)
     CASE 3: byte$ = CHR$(120)
     END SELECT
     PUT #1, byteposition&, byte$
CASE 27                   ' plains
     plains& = plains& + 1
     v = INT(RND * 3) + 1
     SELECT CASE v
     CASE 1: byte$ = CHR$(27)
     CASE 2: byte$ = CHR$(117)
     CASE 3: byte$ = CHR$(118)
     END SELECT
     PUT #1, byteposition&, byte$
CASE ELSE
     other& = other& + 1
END SELECT
NEXT j

LOCATE 1, 1: PRINT USING "###&"; CINT(i / 768 * 100); "% Done"
NEXT i

b! = TIMER
LOCATE 2, 1: PRINT "Program took "; b! - a!; "seconds to finish."
x& = 16 * 48
y& = 10 * 48
PRINT "There were"; shores&; " shore pieces."; (shores& / (x& * y&)) * 100; " percent."
PRINT "There were"; ocean&; " ocean pieces."; (ocean& / (x& * y&)) * 100; " percent."
PRINT "There were"; plains&; " plain pieces."; (plains& / (x& * y&)) * 100; " percent."
DO
LOOP WHILE INKEY$ <> CHR$(27)

