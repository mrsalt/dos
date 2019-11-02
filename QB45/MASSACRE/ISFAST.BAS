SCREEN 12 'unfortunately, it will not make it all the way across
DATA 68,68,71
DATA 25,56,34
DATA 43,29,22
DATA 79,63,41 

DATA 19,44,89
DATA 21,47,94
DATA 17,41,84

DATA 25,75,25
DATA 28,79,28
DATA 22,71,22

DATA 19,60,76
DATA 65,44,37
DATA 27,19,16
DATA 90,70,46
DATA 86,86,81
'DATA 58,40,35
DATA 22,43,22

FOR i = 0 TO 15
READ red, green, blue
PALETTE i, 65536 * CINT(blue / 100 * 63) + 256 * CINT(green / 100 * 63) + CINT(red / 100 * 63)
NEXT i
a! = TIMER
DIM byte AS STRING * 768
OPEN "c:\mark\worldmap.dat" FOR BINARY AS #1

FOR j = 0 TO 48 * 10
byteposition& = j * (48 * 16)
GET #1, byteposition& + 1, byte$
z = 0
FOR i = 0 TO 48 * 16
IF i / 5 <> i \ 5 THEN
b$ = MID$(byte$, i, 1)
s = ASC(b$)
SELECT CASE s
CASE 1, 2: c = 0                 'bridges
CASE 56, 57: c = 1              'trees
CASE 6 TO 21: c = 2               'mountains
CASE 44 TO 55: c = 3            'shores
CASE 26: c = 4                           ' ocean
CASE 119: c = 5
CASE 120: c = 6
CASE 27: c = 7                           ' plains
CASE 117: c = 8
CASE 118: c = 9
CASE 22 TO 25, 28 TO 37, 60 TO 63: c = 10   'rivers
CASE 38 TO 43, 64 TO 67: c = 11    'roads
CASE 68 TO 70: c = 12                'caves
CASE 74 TO 82: c = 13                   ' deserts
CASE 71 TO 73: c = 14                  'harbors
CASE 58: c = 12                      'hut
CASE 3, 4, 5, 59: c = 15         ' forest
END SELECT
PSET (z, j), c
z = z + 1
END IF
NEXT
NEXT
b! = TIMER
DO
LOOP WHILE INKEY$ <> CHR$(27)
COLOR 12: LOCATE 1, 1: PRINT b! - a!; " seconds"

SUB check
FOR byte = 1 TO 82
c = 0
SELECT CASE byte
CASE 1, 2                 'bridges
c = 1
CASE 3, 4, 5, 56, 57, 59  'trees
c = 1
CASE 6 TO 21              'mountains
c = 1
CASE 22 TO 25, 44 TO 55   'shores
c = 1
CASE 27                   ' ocean
c = 1
CASE 26                   ' plains
c = 1
CASE 28 TO 37, 60 TO 63   'rivers
c = 1
CASE 38 TO 43, 64 TO 67   'roads
c = 1
CASE 68 TO 70             'caves
c = 1
CASE 74 TO 82             ' deserts
c = 1
CASE 71 TO 73             'harbors
c = 1
'case
'case
'case
'case
'case
END SELECT
IF c = 0 THEN PRINT byte
NEXT

END SUB

