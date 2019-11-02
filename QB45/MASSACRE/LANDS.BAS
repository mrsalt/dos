DECLARE SUB CoolLand (c, comland())
DECLARE SUB makecomland (comland())
DECLARE SUB castle (x!, y!, q!)
DECLARE SUB drawvertbridge (x!, y!)
DECLARE SUB drawhorobridge (x!, y!)
DECLARE SUB MarkLand (x!, y!, c!, players!, comland())
DECLARE SUB KimLand (c!, comland())
CONST pi = 3.14592, yes = 1, no = 0
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22
DECLARE SUB AwesomeLand (c!, comland())
' $INCLUDE: 'c:\qb45\massacre\types.bas'

SUB AwesomeLand (c, comland())
skipit = c
CLS
SCREEN 12: c = 2
colornumber = 65536 * 30 + 256 * 30 + 30
blue = CINT(17 * .95)    '17
red = CINT(36 * .95)     '36
green = CINT(50 * .95)   '50
colornumber = 65536 * blue + 256 * green + red
PALETTE c, colornumber
DO
COLOR 1
SELECT CASE y
        CASE 0
        CASE 20
        IF x > 520 AND x < 560 THEN COLOR c
        CASE 40
        IF x > 160 AND x < 200 THEN COLOR c
        IF x > 480 AND x < 580 THEN COLOR c
        CASE 60
        IF x > 140 AND x < 220 THEN COLOR c
        IF x > 380 AND x < 460 THEN COLOR c
        IF x > 460 AND x < 580 THEN COLOR c
        CASE 80
        IF x > 120 AND x < 240 THEN COLOR c
        IF x > 360 AND x < 600 THEN COLOR c
                                          
        CASE 100
        IF x > 100 AND x < 240 THEN COLOR c
        IF x > 300 AND x < 340 THEN COLOR c
        IF x > 340 AND x < 600 THEN COLOR c
        CASE 120
        IF x > 20 AND x < 60 THEN COLOR c
        IF x > 80 AND x < 260 THEN COLOR c
        IF x > 280 AND x < 340 THEN COLOR c
        IF x > 360 AND x < 580 THEN COLOR c
        CASE 140
        IF x > 20 AND x < 60 THEN COLOR c
        IF x > 60 AND x < 260 THEN COLOR c
        IF x > 280 AND x < 340 THEN COLOR c
        IF x > 380 AND x < 580 THEN COLOR c
        CASE 160
        IF x > 20 AND x < 280 THEN COLOR c
        IF x > 280 AND x < 320 THEN COLOR c
        IF x > 400 AND x < 580 THEN COLOR c
        CASE 180
        IF x > 20 AND x < 280 THEN COLOR c
        IF x > 400 AND x < 620 THEN COLOR c
                                           
        CASE 200
        IF x > 40 AND x < 260 THEN COLOR c
        IF x > 440 AND x < 620 THEN COLOR c
        CASE 220
        IF x > 40 AND x < 260 THEN COLOR c
        IF x > 420 AND x < 600 THEN COLOR c
        CASE 240
        IF x > 40 AND x < 300 THEN COLOR c
        IF x > 400 AND x < 620 THEN COLOR c
        CASE 260
        IF x > 60 AND x < 320 THEN COLOR c
        IF x > 400 AND x < 620 THEN COLOR c
                                          
        CASE 280
        IF x > 60 AND x < 320 THEN COLOR c
        IF x > 400 AND x < 600 THEN COLOR c
        CASE 300
        IF x > 60 AND x < 360 THEN COLOR c
        IF x > 380 AND x < 600 THEN COLOR c
        CASE 320
        IF x > 60 AND x < 580 THEN COLOR c
        CASE 340
        IF x > 60 AND x < 580 THEN COLOR c
        CASE 360
        IF x > 100 AND x < 560 THEN COLOR c
        CASE 380
        IF x > 100 AND x < 220 THEN COLOR c
        IF x > 260 AND x < 380 THEN COLOR c
        IF x > 380 AND x < 560 THEN COLOR c
        CASE 400
        IF x > 80 AND x < 200 THEN COLOR c
        IF x > 280 AND x < 380 THEN COLOR c
        IF x > 420 AND x < 520 THEN COLOR c
        CASE 420
        IF x > 80 AND x < 180 THEN COLOR c
        IF x > 320 AND x < 380 THEN COLOR c
        IF x > 420 AND x < 520 THEN COLOR c
        CASE 440
        IF x > 60 AND x < 140 THEN COLOR c
        IF x > 440 AND x < 480 THEN COLOR c
END SELECT
d = 3 - c:
LINE (x, y)-(x + (17 + d), y + (17 + d)), , BF
x = x + 20
IF x = 640 THEN
y = 20 + y
x = 0
END IF
LOOP WHILE y < 480
'***************| BRIDGE SECTION |********************************************
x = 279: y = 179: CALL drawhorobridge(x, y)
x = 339: y = 119: CALL drawhorobridge(x, y)
'***************| MOUNTAIN SECTION |******************************************
x1 = 159: y1 = 179
x = x1: y = y1
FOR a = 1 TO 4                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a
'139, 219;159,259;179,279
x1 = 139: y1 = 219
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a
x1 = 159: y1 = 259
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a
x1 = 179: y1 = 279
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a
FOR i = 1 TO 6
 SELECT CASE i
CASE 1: x = 479: y = 139
CASE 2: x = 499: y = 179
CASE 3: x = 519: y = 259
CASE 4: x = 499: y = 299
CASE 5: x = 479: y = 319
CASE 6: x = 459: y = 339
 END SELECT
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a

NEXT i
IF skipit <> 100 THEN

CALL makecomland(comland())
FOR i = 1 TO 5
                SELECT CASE i
                CASE 1: x = 140: y = 160: q = 9
                CASE 2: x = 140: y = 420: q = 4
                CASE 3: x = 340: y = 400: q = 10
                CASE 4: x = 540: y = 300: q = 14
                CASE 5
                x = 420: y = 100
 colornumber = 65536 * 40 + 256 * 20 + 40
 PALETTE 13, colornumber
 q = 13
              
                END SELECT
CALL castle(x, y, q)
NEXT i
END IF

END SUB

SUB CoolLand (c, comland())
skipit = c
CLS
SCREEN 12: c = 2
colornumber = 65536 * 30 + 256 * 30 + 30
blue = CINT(17 * .95)    '17
red = CINT(36 * .95)     '36
green = CINT(50 * .95)   '50
colornumber = 65536 * blue + 256 * green + red
PALETTE c, colornumber
DO
COLOR 1
SELECT CASE y
        CASE 0
        IF x > 120 AND x < 280 THEN COLOR c
        IF x > 560 AND x < 600 THEN COLOR c
        CASE 20
        IF x > 40 AND x < 100 THEN COLOR c
        IF x > 100 AND x < 300 THEN COLOR c
        IF x > 440 AND x < 520 THEN COLOR c
        IF x > 540 AND x < 620 THEN COLOR c
        CASE 40
        IF x > 0 AND x < 340 THEN COLOR c
        IF x > 400 AND x < 620 THEN COLOR c
        CASE 60
        IF x > 20 AND x < 360 THEN COLOR c
        IF x > 380 AND x < 620 THEN COLOR c
       
        CASE 80
        IF x > 40 AND x < 360 THEN COLOR c
        IF x > 360 AND x < 620 THEN COLOR c
    
        CASE 100
        IF x > -1 AND x < 20 THEN COLOR c
        IF x > 80 AND x < 340 THEN COLOR c
        IF x > 360 AND x < 620 THEN COLOR c
     
        CASE 120
        IF x > -1 AND x < 40 THEN COLOR c
        IF x > 60 AND x < 240 THEN COLOR c
        IF x > 280 AND x < 320 THEN COLOR c
        IF x > 340 AND x < 600 THEN COLOR c
        CASE 140
        IF x > -1 AND x < 60 THEN COLOR c
        IF x > 80 AND x < 200 THEN COLOR c
        IF x > 340 AND x < 580 THEN COLOR c
        CASE 160
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 200 THEN COLOR c
        IF x > 340 AND x < 580 THEN COLOR c
        CASE 180
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 240 THEN COLOR c
        IF x > 240 AND x < 280 THEN COLOR c
        IF x > 280 AND x < 580 THEN COLOR c
        CASE 200
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 600 THEN COLOR c
        CASE 220
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 260 THEN COLOR c
        IF x > 280 AND x < 600 THEN COLOR c
      
        CASE 240
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 240 THEN COLOR c
       
        IF x > 300 AND x < 600 THEN COLOR c
        CASE 260
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 200 THEN COLOR c
        IF x > 300 AND x < 600 THEN COLOR c
        CASE 280
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 180 THEN COLOR c
        IF x > 200 AND x < 260 THEN COLOR c
        IF x > 280 AND x < 600 THEN COLOR c
        CASE 300
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 160 THEN COLOR c
        IF x > 180 AND x < 580 THEN COLOR c
        CASE 320
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 160 THEN COLOR c
        IF x > 160 AND x < 560 THEN COLOR c
        CASE 340
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 80 AND x < 160 THEN COLOR c
        IF x > 200 AND x < 540 THEN COLOR c
        CASE 360
        IF x > -1 AND x < 80 THEN COLOR c
        IF x > 100 AND x < 180 THEN COLOR c
        IF x > 280 AND x < 520 THEN COLOR c
        CASE 380
        IF x > -1 AND x < 100 THEN COLOR c
        IF x > 120 AND x < 240 THEN COLOR c
        IF x > 300 AND x < 360 THEN COLOR c
        IF x > 460 AND x < 500 THEN COLOR c
        IF x > 540 AND x < 600 THEN COLOR c
        CASE 400
        IF x > -1 AND x < 120 THEN COLOR c
        IF x > 160 AND x < 280 THEN COLOR c
        IF x > 300 AND x < 340 THEN COLOR c
        IF x > 360 AND x < 440 THEN COLOR c
        IF x > 520 AND x < 620 THEN COLOR c
        CASE 420
        IF x > -1 AND x < 120 THEN COLOR c
        IF x > 180 AND x < 300 THEN COLOR c
        IF x > 340 AND x < 460 THEN COLOR c
        IF x > 460 AND x < 620 THEN COLOR c
        CASE 440
        IF x > -1 AND x < 140 THEN COLOR c
        IF x > 200 AND x < 300 THEN COLOR c
        IF x > 300 AND x < 460 THEN COLOR c
        IF x > 460 AND x < 520 THEN COLOR c
        IF x > 520 AND x < 600 THEN COLOR c
        CASE 460
        IF x > -1 AND x < 140 THEN COLOR c
        IF x > 220 AND x < 280 THEN COLOR c
        IF x > 320 AND x < 420 THEN COLOR c
END SELECT
d = 3 - c:
LINE (x, y)-(x + (17 + d), y + (17 + d)), , BF
x = x + 20
IF x = 640 THEN
y = 20 + y
x = 0
END IF
LOOP WHILE y < 480
'*************|MOUNTAIN SECTION|*********

FOR i = 1 TO 8
SELECT CASE i
CASE 1: x1 = 300: y1 = 340: number = 6: way = 1
CASE 2: x1 = 460: y1 = 100: number = 4: way = 1
CASE 3: x1 = 440: y1 = 180: number = 4: way = 1
CASE 4: x1 = 180: y1 = 240: number = 4: way = 1
CASE 5: x1 = 220: y1 = 120: number = 4: way = 1
CASE 6: x1 = 420: y1 = 140: number = 4: way = -1
CASE 7: x1 = 360: y1 = 260: number = 6: way = -1
CASE 8: x1 = 260: y1 = 120: number = 6: way = -1

END SELECT
x1 = x1 - 1: y1 = y1 - 1
x = x1: y = y1
FOR a = 1 TO number
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y - 20
x = x + 20 * way
IF a = number / 2 THEN x = 20 + x1
IF a = number / 2 THEN y = y1
NEXT a
NEXT i


FOR i = 1 TO 23
way = 1
SELECT CASE i
CASE 1: x1 = 20: y1 = 420: number = 3
CASE 2: x1 = 0: y1 = 440: number = 6
CASE 3: x1 = 480: y1 = 340: number = 3
CASE 4: x1 = 500: y1 = 300: number = 4
CASE 5: x1 = 480: y1 = 240: number = 7'''was 4
CASE 6: x1 = 500: y1 = 180: number = 2
CASE 7: x1 = 480: y1 = 240: number = 2
CASE 8: x1 = 480: y1 = 60: number = 1
CASE 9: x1 = 420: y1 = 360: number = 1
CASE 10: x1 = 400: y1 = 280: number = 1
CASE 11: x1 = 360: y1 = 280: number = 4
CASE 12: x1 = 260: y1 = 200: number = 1
CASE 13: x1 = 120: y1 = 160: number = 1
CASE 14: x1 = 480: y1 = 140: number = 2
CASE 15: x1 = 380: y1 = 260: number = 1
CASE 16: x1 = 340: y1 = 240: number = 2
CASE 17: x1 = 320: y1 = 220: number = 1
CASE 18: x1 = 180: y1 = 280: number = 1
CASE 19: x1 = 160: y1 = 300: number = 1
CASE 20: x1 = 200: y1 = 120: number = 1
CASE 21: x1 = 260: y1 = 120: number = 2
CASE 22: x1 = 240: y1 = 80: number = 1
CASE 23: x1 = 180: y1 = 220: number = 6: way = 2
END SELECT
x1 = x1 - 1: y1 = y1 - 1
x = x1: y = y1
FOR a = 1 TO number
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
SELECT CASE way
CASE 1: y = y - 20
CASE 2: x = x + 20
END SELECT
NEXT a
NEXT i

'********|BRIDGE SECTION|***********
        x = 79: y = 259: CALL drawhorobridge(x, y)
        x = 159: y = 339: CALL drawhorobridge(x, y)
        x = 459: y = 459: CALL drawhorobridge(x, y)
        x = 359: y = 99: CALL drawhorobridge(x, y)
        x = 319: y = 439: CALL drawvertbridge(x, y)
        x = 479: y = 419: CALL drawvertbridge(x, y)

IF skipit <> 100 THEN

CALL makecomland(comland())
FOR c = 1 TO 5
SELECT CASE c
 CASE 1
 x = 580
 y = 80
 q = 4
 CASE 2
 x = 580
 y = 440
 q = 9
 CASE 3
 x = 240
 y = 440
 q = 10
 CASE 4
 x = 40
 y = 340
 q = 14
 CASE 5
 x = 140
 y = 80
 colornumber = 65536 * 40 + 256 * 20 + 40
 PALETTE 13, colornumber
 q = 13
 END SELECT
 CALL castle(x, y, q)
NEXT c
END IF


END SUB

SUB JamieLand (c, comland())

END SUB

SUB KimLand (c, comland())
skipit = c
CLS
SCREEN 12: c = 2
colornumber = 65536 * 30 + 256 * 30 + 30
blue = CINT(17 * .95)    '17
red = CINT(36 * .95)     '36
green = CINT(50 * .95)   '50
colornumber = 65536 * blue + 256 * green + red
PALETTE c, colornumber
DO
COLOR 1
SELECT CASE y
        CASE 0
        CASE 20
        IF x > 100 AND x < 180 THEN COLOR c
        IF x > 240 AND x < 300 THEN COLOR c
        IF x > 400 AND x < 480 THEN COLOR c
        IF x > 520 AND x < 600 THEN COLOR c
        CASE 40
        IF x > 80 AND x < 180 THEN COLOR c
        IF x > 200 AND x < 340 THEN COLOR c
        IF x > 360 AND x < 500 THEN COLOR c
        IF x > 500 AND x < 620 THEN COLOR c
        CASE 60
        IF x > 60 AND x < 160 THEN COLOR c
        IF x > 180 AND x < 500 THEN COLOR c
        IF x > 500 AND x < 620 THEN COLOR c
        CASE 80
        IF x > 40 AND x < 160 THEN COLOR c
        IF x > 160 AND x < 500 THEN COLOR c
        IF x > 520 AND x < 620 THEN COLOR c
        CASE 100
        IF x > 40 AND x < 140 THEN COLOR c
        IF x > 160 AND x < 500 THEN COLOR c
        IF x > 520 AND x < 600 THEN COLOR c
        CASE 120
        IF x > 40 AND x < 140 THEN COLOR c
        IF x > 160 AND x < 520 THEN COLOR c
        IF x > 520 AND x < 600 THEN COLOR c
        CASE 140
        IF x > 40 AND x < 480 THEN COLOR c
        IF x > 520 AND x < 580 THEN COLOR c
        CASE 160
        IF x > 60 AND x < 260 THEN COLOR c
        IF x > 260 AND x < 420 THEN COLOR c
        IF x > 480 AND x < 600 THEN COLOR c
        CASE 180
        IF x > 60 AND x < 240 THEN COLOR c
        IF x > 280 AND x < 400 THEN COLOR c
        IF x > 420 AND x < 620 THEN COLOR c
        CASE 200
        IF x > 0 AND x < 40 THEN COLOR c
        IF x > 80 AND x < 220 THEN COLOR c
        IF x > 280 AND x < 360 THEN COLOR c
        IF x > 400 AND x < 620 THEN COLOR c
        CASE 220
        IF x > 0 AND x < 60 THEN COLOR c
        IF x > 120 AND x < 220 THEN COLOR c
        IF x > 220 AND x < 340 THEN COLOR c
        IF x > 380 AND x < 620 THEN COLOR c
        CASE 240
        IF x > 20 AND x < 120 THEN COLOR c
        IF x > 160 AND x < 340 THEN COLOR c
        IF x > 360 AND x < 540 THEN COLOR c
        IF x > 560 AND x < 600 THEN COLOR c
        CASE 260
        IF x > 20 AND x < 160 THEN COLOR c
        IF x > 180 AND x < 320 THEN COLOR c
        IF x > 380 AND x < 560 THEN COLOR c
        CASE 280
        IF x > 0 AND x < 340 THEN COLOR c
        IF x > 400 AND x < 580 THEN COLOR c
        CASE 300
        IF x > 0 AND x < 360 THEN COLOR c
        IF x > 380 AND x < 580 THEN COLOR c
        CASE 320
        IF x > 0 AND x < 580 THEN COLOR c
        CASE 340
        IF x > 20 AND x < 600 THEN COLOR c
        CASE 360
        IF x > 40 AND x < 600 THEN COLOR c
        CASE 380
        IF x > 60 AND x < 140 THEN COLOR c
        IF x > 160 AND x < 200 THEN COLOR c
        IF x > 220 AND x < 620 THEN COLOR c
        CASE 400
        IF x > 60 AND x < 120 THEN COLOR c
        IF x > 240 AND x < 620 THEN COLOR c
        CASE 420
        IF x = 0 THEN COLOR c
        IF x > 40 AND x < 120 THEN COLOR c
        IF x > 240 AND x < 600 THEN COLOR c
        CASE 440
        IF x = 0 THEN COLOR c
        IF x > 20 AND x < 140 THEN COLOR c
        IF x > 220 AND x < 560 THEN COLOR c
        CASE 460
        IF x < 160 THEN COLOR c
        IF x > 200 AND x < 540 THEN COLOR c
END SELECT
d = 3 - c:
LINE (x, y)-(x + (17 + d), y + (17 + d)), , BF
x = x + 20
IF x = 640 THEN
y = 20 + y
x = 0
END IF
LOOP WHILE y < 480
'*************|MOUNTAIN SECTION|*********
x1 = 390: y1 = 450
x1 = x1 - 11:  y1 = y1 - 11
x = x1: y = y1
FOR a = 1 TO 8
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
x = 20 + x
y = y - 20
IF a = 4 THEN x = 20 + x1
IF a = 4 THEN y = y1
NEXT a

x1 = 379: y1 = 259
x = x1: y = y1
FOR a = 1 TO 4
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
x = 20 + x
y = y + 20
IF a = 2 THEN x = 20 + x1
IF a = 2 THEN y = y1
NEXT a

x1 = 419: y1 = 279
x = x1: y = y1                        'These instructions
FOR a = 1 TO 6                        'will draw diagonal
COLOR 6                               'mountains.
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
x = 20 + x
y = y + 20
IF a = 3 THEN x = 20 + x1
IF a = 3 THEN y = y1
NEXT a

x1 = 459: y1 = 339
x = x1: y = y1
FOR a = 1 TO 2                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a

'(339,99),(319,139),(339,179)
x1 = 339: y1 = 99
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a
x1 = 319: y1 = 139
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a


x1 = 319: y1 = 139
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a
x1 = 339: y1 = 179
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a


x1 = 319: y1 = 219
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a
'299,399
x1 = 299: y1 = 239
x = x1: y = y1
FOR a = 1 TO 2                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a

x1 = 279: y1 = 239
x = x1: y = y1
FOR a = 1 TO 4
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
x = x - 20
y = y + 20
IF a = 2 THEN x = x1 - 20
IF a = 2 THEN y = y1
NEXT a

x1 = 239: y1 = 279
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a

x1 = 219: y1 = 319
x = x1: y = y1
FOR a = 1 TO 2                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a

x = 259: y = 279                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)

x1 = 219: y1 = 159
x = x1: y = y1
FOR a = 1 TO 4
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
x = x - 20
y = y + 20
IF a = 2 THEN x = x1 - 20
IF a = 2 THEN y = y1
NEXT a

x1 = 159: y1 = 179
x = x1: y = y1
FOR a = 1 TO 3                         'Vertical mountains
COLOR 6                                '
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
y = y + 20
NEXT a

x1 = 99: y1 = 179
x = x1: y = y1
FOR a = 1 TO 4
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
x = x + 20
y = y + 20
IF a = 2 THEN x = x1 + 20
IF a = 2 THEN y = y1
NEXT a

x1 = 79: y1 = 119
x = x1: y = y1
FOR a = 1 TO 4
COLOR 6
LINE (x + 1, y - 1)-(x + 10, y - 19)
LINE (x + 10, y - 19)-(x + 19, y - 1)
LINE (x + 19, y - 1)-(x + 1, y - 1)
PAINT (x + 9, y - 5)
x = x + 20
y = y + 20
IF a = 2 THEN x = x1
IF a = 2 THEN y = y1 + 20
NEXT a
'********|BRIDGE SECTION|*********** 
        x = 159: y = 99: CALL drawhorobridge(x, y)
        x = 99: y = 239: CALL drawvertbridge(x, y)
        x = 459: y = 179: CALL drawvertbridge(x, y)
IF skipit <> 100 THEN

CALL makecomland(comland())
FOR c = 1 TO 5
SELECT CASE c
 CASE 1
 x = 120
 y = 80
 q = 9
 CASE 2
 x = 80
 y = 460
 q = 4
 CASE 3
 x = 360
 y = 360
 q = 10
 CASE 4
 x = 560
 y = 400
 q = 14
 CASE 5
 x = 460
 y = 100
 colornumber = 65536 * 40 + 256 * 20 + 40
 PALETTE 13, colornumber
 q = 13
 END SELECT
 CALL castle(x, y, q)
NEXT c
END IF

END SUB

SUB makecomland (comland())
FOR i = 1 TO 32
        FOR j = 1 TO 24
                terrain = POINT(i * 20 - 10, j * 20 - 10)
                
                IF terrain = 6 OR terrain = 1 THEN
                comland(i, j) = 0
                END IF
                IF terrain = 2 THEN
                comland(i, j) = 1
                END IF
                IF terrain = 7 THEN
                comland(i, j) = -1
                END IF
        NEXT j
NEXT i



' The computer will look at the country in terms of an array that represents
' the land and every strategic detail of it.
'
' This array will be known as: ComLand(32,24)
'
' The number 0 will mean: off limits (mountains, seas)
'
' The number 1 will mean that it is unowned land.
'
' The numbers 4, 9, 10, 13, 14 will mean that the land is owned by the
' player that has that attribute for his/her color.
'
' That number * 5 will mean that it is a castle owned by that player, and
' if it is the number * 20 then that will mean it is that players current
' home castle.  (The only reason their is a home castle is because it is
' a base for their army.  When an army is defeated in a field battle, then
' it has to go back to it's home castle.)
'
' A negative number will represent the army.  Example: -9 would mean the army
' of the player with color 9.
END SUB

SUB MarkLand (x, y, c, players, comland())
skipit = c
CLS
SCREEN 12: c = 2
colornumber = 65536 * 30 + 256 * 30 + 30
blue = CINT(17 * .95)    '17
red = CINT(36 * .95)     '36
green = CINT(50 * .95)   '50
colornumber = 65536 * blue + 256 * green + red
PALETTE c, colornumber
DO
SELECT CASE y
        CASE 0
        COLOR 1
        CASE 20
        IF x < 320 OR x > 460 THEN COLOR 1
        IF x > 320 AND x < 480 THEN COLOR c
        CASE 40
        COLOR 1
        IF x > 60 AND x < 180 THEN COLOR c
        IF x > 240 AND x < 500 THEN COLOR c
        CASE 60
        COLOR 1
        IF x > 40 AND x < 540 THEN COLOR c
        CASE 80
        COLOR 1
        IF x > 20 AND x < 560 THEN COLOR c
        CASE 100
        COLOR 1
        IF x > 20 AND x < 560 THEN COLOR c
        CASE 120
        COLOR 1
        IF x > 40 AND x < 560 THEN COLOR c
        CASE 140
        COLOR 1
        IF x > 40 AND x < 360 THEN COLOR c
        IF x > 420 AND x < 560 THEN COLOR c
        CASE 160
        COLOR 1
        IF x > 20 AND x < 340 THEN COLOR c
        IF x > 440 AND x < 560 THEN COLOR c
        CASE 180
        COLOR 1
        IF x > 1 AND x < 160 THEN COLOR c
        IF x > 220 AND x < 320 THEN COLOR c
        IF x > 360 AND x < 420 THEN COLOR c
        IF x > 440 AND x < 560 THEN COLOR c
        CASE 200
        COLOR 1
        IF x > 20 AND x < 140 THEN COLOR c
        IF x > 160 AND x < 220 THEN COLOR c
        IF x > 340 AND x < 440 THEN COLOR c
        IF x > 440 AND x < 560 THEN COLOR c
        CASE 220
        COLOR 1
        IF x > 40 AND x < 120 THEN COLOR c
        IF x > 140 AND x < 240 THEN COLOR c
        IF x > 280 AND x < 340 THEN COLOR c
        IF x > 360 AND x < 420 THEN COLOR c
        IF x > 440 AND x < 560 THEN COLOR c
        CASE 240
        COLOR 1
        IF x > 120 AND x < 260 THEN COLOR c
        IF x > 280 AND x < 360 THEN COLOR c
        IF x > 440 AND x < 580 THEN COLOR c
        CASE 260
        COLOR 1
        IF x > 80 AND x < 280 THEN COLOR c
        IF x > 280 AND x < 400 THEN COLOR c
        IF x > 420 AND x < 580 THEN COLOR c
        CASE 280
        COLOR 1
        IF x > 40 AND x < 280 THEN COLOR c
        IF x > 280 AND x < 600 THEN COLOR c
        CASE 300
        COLOR 1
        IF x > 60 AND x < 280 THEN COLOR c
        IF x > 300 AND x < 620 THEN COLOR c
        CASE 320
        COLOR 1
        IF x > 60 AND x < 300 THEN COLOR c
        IF x > 300 AND x < 620 THEN COLOR c
        CASE 340
        COLOR 1
        IF x > 60 AND x < 300 THEN COLOR c
        IF x > 300 AND x < 620 THEN COLOR c
        CASE 360
        COLOR 1
        IF x > 60 AND x < 300 THEN COLOR c
        IF x > 320 AND x < 420 THEN COLOR c
        IF x > 440 AND x < 620 THEN COLOR c
        CASE 380
        COLOR 1
        IF x > 80 AND x < 140 THEN COLOR c
        IF x > 180 AND x < 300 THEN COLOR c
        IF x > 460 AND x < 620 THEN COLOR c
        CASE 400
        COLOR 1
        IF x > 460 AND x < 620 THEN COLOR c
        CASE 420
        COLOR 1
        IF x > 440 AND x < 620 THEN COLOR c
        CASE 440
        COLOR 1
        IF x > 520 AND x < 600 THEN COLOR c
        CASE 460
        COLOR 1
END SELECT
d = 3 - c:
LINE (x, y)-(x + (17 + d), y + (17 + d)), , BF
x = x + 20
IF x = 640 THEN
y = 20 + y
x = 0
END IF
LOOP WHILE y < 480

'CIRCLE (450, 340), 100, , .1, 1.46, 1.6   '   1.2
'CIRCLE (450, 340), 99, , .1, 1.46, 1.6    ' 1.2
'CIRCLE (450, 340), 98, , .1, 1.46, 1.6
'CIRCLE (460, 260), 15, , 1, 1.67
'*************|MOUNTAIN SECTION|*********
x = 463: y = 375
FOR a = 1 TO 6
COLOR 6
LINE (x, y)-(x + 9, y - 18)
LINE (x + 9, y - 18)-(x + 18, y)
LINE (x + 18, y)-(x, y)
PAINT (x + 9, y - 5)
x = 20 + x
y = y - 20
IF a = 3 THEN x = 479
IF a = 3 THEN y = 375
NEXT a

x = 420: y = 135
m = x: n = y
FOR a = 1 TO 6
COLOR 6
LINE (x, y)-(x + 9, y - 18)
LINE (x + 9, y - 18)-(x + 18, y)
LINE (x + 18, y)-(x, y)
PAINT (x + 9, y - 5)
x = 20 + x
y = y - 20
IF a = 3 THEN x = 16 + m
IF a = 3 THEN y = n
NEXT a

x = 220: y = 115
m = x: n = y
        FOR a = 1 TO 9
        COLOR 6
        LINE (x, y)-(x + 9, y - 18)
        LINE (x + 9, y - 18)-(x + 18, y)
        LINE (x + 18, y)-(x, y)
        PAINT (x + 9, y - 5)
        x = x - 20
        y = y - 20
        IF a = 3 THEN x = 16 + m
        IF a = 3 THEN y = n
        IF a = 6 THEN x = 220
        IF a = 6 THEN y = 115
        IF a = 6 THEN
        IF a = 6 THEN EXIT FOR
        END IF
        NEXT a
                FOR a = 1 TO 3
                 y = y + 20
                IF a > 1 THEN x = 240
                IF a = 2 THEN y = y - 20
                LINE (x, y)-(x + 9, y - 18)
                LINE (x + 9, y - 18)-(x + 18, y)
                LINE (x + 18, y)-(x, y)
                PAINT (x + 9, y - 5)
                IF a = 3 THEN EXIT FOR
                NEXT a

colornumber = 65536 * 30 + 256 * 30 + 30
PALETTE 7, colornumber
COLOR 7
'********|BRIDGE SECTION|***********   
      
        FOR a = 3 TO 15
        z = 21 - a
        CIRCLE (450, 238 - z), 20, , 1.1, 2.2
        NEXT a
      
        FOR a = 3 TO 15
        z = 21 - a
        CIRCLE (310, 358 - z), 20, , 1.1, 2.2
        NEXT a
      
        FOR a = 2 TO 15
        LINE (380 + a, 240)-(380 + a, 258)
        NEXT a
        LINE (381, 244)-(381, 254): LINE (396, 244)-(396, 254)
      
        FOR a = 2 TO 15
        LINE (180 + a, 180)-(180 + a, 198)
        NEXT a
        LINE (181, 184)-(181, 194): LINE (196, 184)-(196, 194)
      
        FOR a = 2 TO 15
        LINE (300 + a, 200)-(300 + a, 218)
        NEXT a
        LINE (301, 204)-(301, 214): LINE (316, 204)-(316, 214)
'****************|CASTLE SECTION|********************
IF skipit <> 100 THEN

CALL makecomland(comland())

FOR c = 1 TO 5
SELECT CASE c
 CASE 1
 x = 183
 y = 337
 a = x - 10
 q = 9
 CASE 2
 x = 523
 y = 377
 a = x - 10
 q = 4
 CASE 3
 x = 403
 y = 217
 a = x - 10
 q = 10
 CASE 4
  x = 343
  y = 97
  a = x - 10
  q = 14
  CASE 5
  x = 123
  y = 117
  a = x - 10
  colornumber = 65536 * 40 + 256 * 20 + 40
  PALETTE 13, colornumber
  q = 13
  END SELECT
COLOR 15
LINE (x, y)-(x + 12, y - 11), , BF
LINE (x, y - 9)-(x + 2, y - 14), , BF
LINE (x + 12, y - 9)-(x + 10, y - 14), , BF
COLOR 8
LINE (x + 13, y - 14)-(x + 11, y - 19)
LINE (x + 11, y - 19)-(x + 9, y - 14)
LINE (x + 9, y - 14)-(x + 13, y - 14)
PAINT (x + 11, y - 16)
LINE (a + 13, y - 14)-(a + 11, y - 19)
LINE (a + 11, y - 19)-(a + 9, y - 14)
LINE (a + 9, y - 14)-(a + 13, y - 14)
PAINT (a + 11, y - 16)
colornumber = 65536 * 45 + 256 * 45 + 45
PALETTE 5, colornumber
COLOR 5
LINE (x + 2, y)-(x + 2, y - 9)
LINE (x + 10, y)-(x + 10, y - 9)
COLOR 8
x = x - 10: y = y + 6
LINE (x + 13, y - 14)-(x + 11, y - 19)
LINE (x + 11, y - 19)-(x + 9, y - 14)
LINE (x + 9, y - 14)-(x + 13, y - 14)
PAINT (x + 11, y - 16)
x = x + 10
LINE (x + 13, y - 14)-(x + 11, y - 19)
LINE (x + 11, y - 19)-(x + 9, y - 14)
LINE (x + 9, y - 14)-(x + 13, y - 14)
PAINT (x + 11, y - 16)
COLOR 0
CIRCLE (x + 6, y - 10), 2
PAINT (x + 6, y - 10)
LINE (x + 4, y - 6)-(x + 8, y - 9), , BF
LINE (x + 6, y - 18)-(x + 6, y - 25)
COLOR q
LINE (x + 6, y - 22)-(x + 11, y - 25)
LINE (x + 11, y - 25)-(x + 6, y - 28)
LINE (x + 6, y - 28)-(x + 6, y - 22)
PAINT (x + 8, y - 25)
NEXT c
END IF


END SUB

SUB RyanLand (c, comland())

END SUB

