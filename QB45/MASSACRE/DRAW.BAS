DECLARE SUB largewindow (x!, y!)
DECLARE SUB smallwindow (x1!, x2!, y!, fill!)
DECLARE SUB smalldoor (x!, y!)
DECLARE SUB soldier (x!, y!, currentplayer!, q!, playerscastles())
DECLARE SUB training (playerscastles(), currentplayer, skillevel(), movement(), gold())
DECLARE SUB shootstar ()
DECLARE SUB drawplaymenu (degrees!, drawmenu, pause, topscroll())
DECLARE SUB drawvertbridge (x!, y!)
DECLARE SUB drawhorobridge (x!, y!)
DECLARE SUB castle (x!, y!, q!)
DECLARE FUNCTION currentcolor (currentplayer, playerscastles())

CONST pi = 3.14592, yes = 1, no = 0
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22

' $INCLUDE: 'c:\qb45\massacre\types.bas'

SUB castle (x, y, q)
x = x + 3: y = y - 4  'x + 3

a = x - 10
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

END SUB

SUB drawhorobridge (x, y)
       
       
        COLOR 1
        LINE (x + 1, y - 1)-(x + 19, y - 19), , BF
        colornumber = 65536 * 30 + 256 * 30 + 30
        PALETTE 7, colornumber
        COLOR 7
        FOR a = 3 TO 15
        z = 21 - a
        CIRCLE (x + 11, 20 + y - z), 20, , 1.1, 2.18
        NEXT a
        COLOR 0
        LINE (x, y)-(x + 20, y - 20), , B
END SUB

SUB drawplaymenu (degrees!, drawmenu, pause, topscroll())
CLS
SCREEN 12
IF pause <> 999 THEN
blue = CINT(35 * .94)    '27
red = CINT(55 * .94)     '36
green = CINT(52 * .94)   '50
papercolor = 65536 * blue + 256 * green + red
PALETTE 0, papercolor
brown = 65536 * 20 + 256 * 20 + 30
PALETTE 6, brown
END IF

COLOR 6'*************| everything is set to be drawn in brown |********************
radius = 1
x = 50
y = 50
IF pause = 999 THEN
num = 65536 * 1 + 256 * 1 + 1
FOR k = 1 TO 15
PALETTE k, num
NEXT k

        FOR degrees = 1 TO 900
       
        IF degrees > 345 THEN
        degrees = 1
        repeats = 1 + repeats
        END IF

        degree = degrees + 10
        r = (r + .023)
        radius = r
        IF radius < 1 THEN radius = 1

        radians = (degrees * 2 * pi) / 360
        radian = (degree * 2 * pi) / 360
        CIRCLE (x, y), radius, , radians, radian
        
          IF radius > 20.5 THEN
          EXIT FOR
          END IF
        NEXT degrees
PALETTE
blue = CINT(35 * .94)    '27
red = CINT(55 * .94)     '36
green = CINT(52 * .94)   '50
papercolor = 65536 * blue + 256 * green + red
PALETTE 0, papercolor

brown = 65536 * 20 + 256 * 20 + 30
PALETTE 6, brown
GET (25, 25)-(75, 70), topscroll
ELSE
PUT (25, 25), topscroll, PSET
END IF

LINE (x, y - 18)-(x + 300, y - 18)
LINE (x, y - 10.5)-(x + 13.5, y - 10.5)
LINE (x, y - 3)-(x + 7, y - 3)
LINE (x + 2, y)-(x + 7, y)
LINE (x + 1, y + 7)-(x + 13, y + 7)
LINE (x + 1, y + 15)-(x + 300, y + 15)
degrees = 90: degree = 270
        radians = (degrees * 2 * pi) / 360
        radian = (degree * 2 * pi) / 360

CIRCLE (x + 300, y - 1.4), 16.5, , radian, radians
x = 3
y = 140
'?****** degs = stop,deg = start
degree = 55: degrees = 320  'deg = 55 degs = 320
        radians = (degrees * 2 * pi) / 360
        radian = (degree * 2 * pi) / 360
CIRCLE (x, y), 100, , radians, radian, 2
degree = 48: degrees = 320  'deg = 55 degs = 320
        radians = (degrees * 2 * pi) / 360
        radian = (degree * 2 * pi) / 360
CIRCLE (x + 312, y), 100, , radians, radian, 2

degree = 240: degrees = 140  'deg = 48 degs = 320
        radians = (degrees * 2 * pi) / 360
        radian = (degree * 2 * pi) / 360
CIRCLE (x + 80, y + 120), 100, , radians, radian, 2
CIRCLE (x + 80 + 312, y + 120), 100, , radians, radian, 2
x1 = 36: x2 = 380: y1 = 39: y2 = 65

dimsize = 4 + INT(((380 - 300 + 1) * (1) + 7) / 8) * 4 * ((65 - 39) + 1)


DIM scroll(4756)
GET (x1, y1)-(x2, y2), scroll
PUT (20, 330), scroll, PSET
ERASE scroll
x1 = 300: x2 = 380: y1 = 39: y2 = 65
DIM edgescroll(1192)
GET (x1, y1)-(x2, y2), edgescroll
PUT (297, 330), edgescroll, PSET
ERASE edgescroll
colornumber = 65536 * 1 + 256 * 1 + 1
PALETTE 8, colornumber
COLOR 8
PAINT (600, 460), , 6

END SUB

SUB drawvertbridge (x, y)
colornumber = 65536 * 30 + 256 * 30 + 30
PALETTE 7, colornumber
COLOR 7
        x = x - 1
        FOR a = 4 TO 17
        LINE (x + a, y - 1)-(x + a, y - 19)
        NEXT a
        LINE (x + 3, y - 6)-(x + 3, y - 14): LINE (x + 18, y - 6)-(x + 18, y - 14)

END SUB

SUB largewindow (x, y)                '
COLOR 8                               '     x     x + 6
LINE (x, y)-(x, y + 10)               '     |     |
LINE (x + 6, y)-(x + 6, y + 10)       '     |     |
LINE (x, y)-(x + 2, y - 2)            'y-2-> ±±± 
LINE (x + 6, y)-(x + 4, y - 2)        '      ± ± ±
LINE (x, y + 10)-(x + 6, y + 10)      'y--> ±  ±  ±
LINE (x + 3, y - 2)-(x + 3, y + 10)   '     ±  ±  ±
LINE (x, y + 2)-(x + 6, y + 2)        'y+2  ±±±±±±±
LINE (x, y + 6)-(x + 6, y + 6)        '     ±  ±  ±
COLOR 1                               '     ±  ±  ±
PAINT (x + 1, y), , 8                 '     ±  ±  ±
PAINT (x + 4, y), , 8                 'y+6  ±±±±±±±
PAINT (x + 1, y + 4), , 8             '     ±  ±  ±
PAINT (x + 4, y + 4), , 8             '     ±  ±  ±
PAINT (x + 1, y + 8), , 8             '     ±  ±  ±
PAINT (x + 4, y + 8), , 8             'y+10>±±±±±±±
END SUB

SUB shootstar
COLOR 15
                        DO
                        x = (RND * 320) + 300
                        y = RND * 208
                        LOOP WHILE x > 640 AND y > 150
                      
                        DO
                        IF INKEY$ <> "" THEN EXIT DO
                        a = POINT(x, y)
                           
                        COLOR 0
                        CIRCLE (x, y), 1
                        COLOR 15
                        x = x - 1
                        y = y + 1
                        CIRCLE (x, y), 1
                        IF INKEY$ <> "" THEN EXIT DO
                        IF x < 1 OR y > 207 OR y < 1 THEN
                        COLOR 0
                        CIRCLE (x, y), 1
                        COLOR 15
                        EXIT DO
                        END IF
                       
                                IF a <> 0 THEN
                                k = 1
                                B = x: c = y
                                END IF
                                IF k = 2 THEN
                                CIRCLE (B - 1, c - 1), 1
                                k = 0
                                END IF
                        IF k <> 0 THEN k = k + 1

                      
                        LOOP WHILE INKEY$ = ""
             

END SUB

SUB smalldoor (x, y)
COLOR 8
LINE (x, y + 6)-(x, y)'left door
LINE (x + 4, y + 6)-(x + 4, y)
LINE (x + 1, y - 1)-(x + 3, y - 1)
COLOR 15
PAINT (x + 2, y + 2), , 8
END SUB

SUB smallwindow (x1, x2, y, fill)         '       x
FOR i = 1 TO 2                            '       |
COLOR 8
IF i = 1 THEN x = x1 ELSE x = x2          '       
LINE (x, y)-(x, y + 4)                    '        ±
LINE (x + 2, y)-(x + 2, y + 4)            ' y-->  ± ±
LINE (x + 1, y - 1)-(x + 1, y - 1)        '       ± ±
LINE (x, y + 4)-(x + 2, y + 4)            '       ± ±
                                          '       ± ±
COLOR fill                                '       ±±±
LINE (x + 1, y)-(x + 1, y + 3)
NEXT i
END SUB

SUB soldier (x, y, currentplayer, q, playerscastles())
SCREEN 12
COLOR 6
LINE (x + 5, y + 2)-(x + 5, y + 18)
COLOR 7
LINE (x + 3, y + 4)-(x + 5, y + 2)
LINE (x + 4, y + 3)-(x + 6, y + 3)
LINE (x + 5, y + 2)-(x + 7, y + 4)
LINE (x + 3, y + 4)-(x + 7, y + 4)
LINE (x + 10, y + 2)-(x + 12, y + 6), , BF
COLOR 15
LINE (x + 11, y + 9)-(x + 11, y + 7)
LINE (x + 4, y + 8)-(x + 15, y + 8)
LINE (x + 9, y + 8)-(x + 13, y + 14), , BF
LINE (x + 15, y + 8)-(x + 15, y + 14)
COLOR 8
LINE (x + 9, y + 2)-(x + 13, y + 6), , B
LINE (x + 11, y + 2)-(x + 11, y + 6)
LINE (x + 9, y + 4)-(x + 13, y + 6), , BF
LINE (x + 9, y + 14)-(x + 13, y + 18), , BF
LINE (x + 8, y + 18)-(x + 14, y + 18)
LINE (x + 11, y + 9)-(x + 15, y + 14), , BF
COLOR currentcolor(currentplayer, playerscastles())
LINE (x + 12, y + 10)-(x + 14, y + 13), , BF
LINE (x + 11, y + 14)-(x + 11, y + 18)

END SUB

SUB training (playerscastles(), currentplayer, skillevel(), movement(), gold())
SCREEN 13
CLS
COLOR 11
LINE (0, 0)-(320, 117), , BF
colornumber = 65536 * CINT(30 * .6) + 256 * CINT(35 * .6) + CINT(45 * .6)'30,35,45
PALETTE 20, colornumber
COLOR 20
LINE (0, 117)-(320, 200), , BF
'**************| PART THAT DRAWS MOUNTAINS |*********************************
colornumber = 65536 * CINT(30 * .9) + 256 * CINT(35 * .9) + CINT(45 * .9)'30,35,45
PALETTE 21, colornumber
COLOR 21
LINE (0, 79)-(60, 50)
LINE -STEP(70 * 1.3, 37 * 1.3)   '1.70
LINE -STEP(-70 * .51, -37 * .51)
LINE -STEP(80, -37)
LINE -STEP(25, 17)
LINE -STEP(-100, 58)
LINE -STEP(100 * 1.5, -58 * 1.5)
LINE -STEP(50, 21)
LINE (0, 117)-(320, 117)
PAINT (25, 100), , 21

colornumber = 65536 * CINT(30 * 1) + 256 * CINT(35 * 1) + CINT(45 * 1)'30,35,45
PALETTE 22, colornumber
COLOR 22
PAINT (150, 96), , 21

colornumber = 65536 * CINT(30 * .8) + 256 * CINT(35 * .8) + CINT(45 * .8)
PALETTE 23, colornumber
COLOR 23
PAINT (165, 96), , 21
LINE (120, 117)-(320, 117)


COLOR 50
LINE (0, 118)-(320, 118)
LINE (200, 200)-(130, 118)'
LINE (300, 200)-(130, 118)'120
PAINT (10, 190), , 50
PAINT (310, 190), , 50

FOR i = 1 TO 40
colornumber = 65536 * CINT(1 + i * .5) + 256 * CINT((43 + i \ 1.5) * .5) + CINT(1 + i * .5)
PALETTE i + 23, colornumber
NEXT i
p = 20

COLOR 50
LINE (0, 118)-(320, 118)
LINE (200, 200)-(130, 118)'
LINE (300, 200)-(130, 118)'120
PAINT (10, 190), , 50
PAINT (310, 190), , 50

RANDOMIZE TIMER
FOR F = 1 TO 10
k = k + 1
SELECT CASE k
CASE 1
x = 220: y = 95
CASE 2

CASE 3
x = 82: y = 100
CASE 6
x = 114 + 20: y = 147
CASE 4
x = 88 + 20: y = 120
CASE 5
x = 33 + 20: y = 118
CASE 7
x = 61 + 20: y = 147
CASE 8
x = 0 + 20: y = 130
CASE 11
x = 295: y = 135
CASE 10
x = 275: y = 120
CASE 9
x = 250: y = 105
END SELECT                                   '15.66667 8.25 33.28 17.23  53

FOR g = 1 TO 40
COLOR g + 23
distance = ((y - 80) / 10)
heigth = (y * 16 - 1410) / 80
distance = distance / 2 + 3
depth = 8 - distance
IF depth < 1 THEN depth = 1
LINE (x, y)-(x + g \ -depth, y + 28 + heigth * 2)
LINE (x, y)-(x + 1 + g \ depth, y + 28 + heigth * 2)
NEXT g

NEXT F
COLOR 20
FOR flag = 1 TO 10
across = (flag * 15) + flag ^ 2.3 / 1.5
downvalue = (flag * 8 + (flag ^ 2.3 / 4))
x = 120 + across
y = 110 + downvalue
newx = across - newx
newy = downvalue - newy
COLOR 20
LINE (x, y)-(x, y - (flag * 2) * 2)
COLOR currentcolor(currentplayer!, playerscastles())
LINE (x + 1, y - (flag * 2) * 2)-STEP(newx * .18, newy / 7)
LINE -STEP(newx * -.18, newy / 7)
LINE -STEP(0, -1 * newy / 3.5)
IF flag > 2 THEN
PAINT STEP(newx * .06, newy / 7), , currentcolor(currentplayer!, playerscastles())
END IF
NEXT flag
colornumber = 65536 * 63 + 256 * 63 + 63
PALETTE 0, colornumber
colornumber = 65536 * 1 + 256 * 1 + 1
PALETTE 230, colornumber
COLOR 230
x = 5: y = 5
a = 130: B = 55
LINE (x, y)-(x + a, y + B), , BF
x = x + 5: y = y + 5
COLOR 0
LINE (x, y)-(x + a, y + B), , BF
COLOR currentcolor(currentplayer!, playerscastles())
LOCATE 3, 3: PRINT "Select the area"
LOCATE 4, 3: PRINT "to train in:   "
IF gold(currentplayer) >= (skillevel(currentplayer)) * 100 THEN
LOCATE 5, 3: PRINT " 1. Skill in   "
LOCATE 6, 3: PRINT "    battle.    "
crap = 1 + crap
END IF
IF gold(currentplayer) >= (1 + movement(currentplayer)) * 100 THEN
LOCATE 7, 3: PRINT " 2. Movement   "
crap = 1 + crap
END IF
IF crap = 0 THEN EXIT SUB

DO
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""
SELECT CASE choice$
CASE "1"
        IF gold(currentplayer) - (100 * (skillevel(currentplayer) - 1)) < 0 THEN
        FOR i = 1 TO 5
        LOCATE 2 + i, 3: PRINT "               "
        NEXT i
        LOCATE 4, 3: PRINT " Not enough  "
        LOCATE 5, 3: PRINT "   money     "
        EXIT SUB
        ELSE
        skillevel(currentplayer) = skillevel(currentplayer) + 1
        gold(currentplayer) = gold(currentplayer) - (100 * (skillevel(currentplayer) - 1))
        EXIT DO
        END IF
CASE "2"
        IF gold(currentplayer) - (100 * (movement(currentplayer) + 1)) < 0 THEN
        FOR i = 1 TO 5
        LOCATE 2 + i, 3: PRINT "               "
        NEXT i
        LOCATE 4, 3: PRINT " Not enough  "
        LOCATE 5, 3: PRINT "   money     "
        EXIT SUB
        ELSE
        movement(currentplayer) = movement(currentplayer) + 1
        gold(currentplayer) = gold(currentplayer) - (100 * (movement(currentplayer)))
        EXIT DO
        END IF
CASE ELSE
BEEP
END SELECT
LOOP

LOCATE 3, 3: PRINT "Weeks of hard, "'
LOCATE 4, 3: PRINT "vigorous,      "
LOCATE 5, 3: PRINT "training and   "
LOCATE 6, 3: PRINT "mental focusing"; ""
LOCATE 7, 3: PRINT "have increased "
DO
LOOP WHILE INKEY$ = ""
FOR i = 1 TO 5
LOCATE 2 + i, 3: PRINT "               "
NEXT i
LOCATE 3, 3: PRINT "the abilities  "
LOCATE 4, 3: PRINT "of your army to"
LOCATE 5, 3: PRINT "kick butt.     "
LOCATE 6, 3: PRINT "However, it    "
LOCATE 7, 3: PRINT "used     gold. "
SELECT CASE choice$
CASE "1"
LOCATE 7, 7: PRINT skillevel(currentplayer) * 100
CASE "2"
LOCATE 7, 7: PRINT movement(currentplayer) * 100
END SELECT
DO
LOOP WHILE INKEY$ = ""

END SUB

