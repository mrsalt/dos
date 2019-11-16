SCREEN 12 'unfortunately, it will not make it all the way across
CLS
INPUT "Xstart"; xstart
INPUT "Yend"; xend
INPUT "Ystart"; ystart
INPUT "yend"; yend

DATA 68,68,71,25,56,34
DATA 43,29,22,79,63,41
DATA 19,44,89,25,75,25
DATA 19,60,76,65,44,37
DATA 27,19,16
DATA 90,70,46,86,86,81
DATA 58,40,35,22,43,22

FOR i = 1 TO 13
READ red, green, blue
PALETTE i, 65536 * CINT(blue / 100 * 63) + 256 * CINT(green / 100 * 63) + CINT(red / 100 * 63)
NEXT i

DIM byte AS STRING * 1
OPEN "worldmap.dat" FOR BINARY AS #1
xsize = INT(640 / (((xend + 1) * 16 - 1) - (xstart * 16)))
ysize = INT(480 / (((yend + 1) * 10 - 1) - (ystart * 10)))

IF ysize < xsize THEN xsize = ysize ELSE ysize = xsize


FOR i = (xstart) * 16 TO ((xend + 1) * 16 - 1)
FOR j = (ystart) * 10 TO ((yend + 1) * 10 - 1)
byteposition& = i + j * (48 * 16)
GET #1, byteposition& + 1, byte$
C = 0
s = ASC(byte)
SELECT CASE s
CASE 1, 2                 'bridges
C = 1
CASE 56, 57               'trees
C = 2
CASE 6 TO 21              'mountains
C = 3
CASE 44 TO 55             'shores
C = 4
CASE 26                   ' ocean
C = 5
CASE 27                   ' plains
C = 6
CASE 22 TO 25, 28 TO 37, 60 TO 63   'rivers
C = 7
CASE 38 TO 43, 64 TO 67   'roads
C = 8
CASE 68 TO 70             'caves
C = 9
CASE 74 TO 82             ' deserts
C = 10
CASE 71 TO 73             'harbors
C = 11
CASE 58                   'hut
C = 12
CASE 3, 4, 5, 59          ' forest
C = 13
END SELECT
x1 = (i - ((xstart) * 16)) * xsize
y1 = (j - ((ystart) * 10)) * ysize
LINE (x1, y1)-STEP(xsize - 1, ysize - 1), C, BF
NEXT j
NEXT i

DO: LOOP WHILE INKEY$ = ""

SUB check
FOR byte = 1 TO 82
C = 0
SELECT CASE byte
CASE 1, 2                 'bridges
C = 1
CASE 3, 4, 5, 56, 57, 59  'trees
C = 1
CASE 6 TO 21              'mountains
C = 1
CASE 22 TO 25, 44 TO 55   'shores
C = 1
CASE 27                   ' ocean
C = 1
CASE 26                   ' plains
C = 1
CASE 28 TO 37, 60 TO 63   'rivers
C = 1
CASE 38 TO 43, 64 TO 67   'roads
C = 1
CASE 68 TO 70             'caves
C = 1
CASE 74 TO 82             ' deserts
C = 1
CASE 71 TO 73             'harbors
C = 1
'case
'case
'case
'case
'case
END SELECT
IF C = 0 THEN PRINT byte
NEXT

END SUB

