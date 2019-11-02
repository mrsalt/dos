DECLARE SUB castle (x!, y!, q!)
DECLARE SUB savegame (land(), xcastle(), ycastle())

CLS
SCREEN 12
COLOR 1
KEY 1, "q" ' land/water
KEY 2, "x" ' mountains
KEY 31, "s"' save
KEY 3, "b" ' bridge
KEY 4, "t" ' castle

CONST down = 80, up = 72, left = 75, right = 77, bridge = 6, lands = 1
CONST contour = 2, fortress = 7, diskfile$ = "land.dat"

DIM land(32, 24)
DIM xcastle(5)
DIM ycastle(5)
FOR i = 1 TO 24
FOR j = 1 TO 32
LINE (j * 20 - 19, i * 20 - 19)-(j * 20 - 1, i * 20 - 1), , BF
land(j, i) = 1
NEXT j
NEXT i
COLOR 4 + lands
LINE (x, y)-(x + 20, y + 20), , B
mode = lands

DO
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""
choice$ = RIGHT$(choice$, 1)

SELECT CASE choice$
        CASE CHR$(up)
        IF y > 2 THEN
        COLOR 0: LINE (x, y)-(x + 20, y + 20), , B
        y = y - 20
        already = 0
        COLOR 4 + mode: LINE (x, y)-(x + 20, y + 20), , B
        ELSE : BEEP
        END IF

        CASE CHR$(down)
        IF y < 460 THEN
        COLOR 0: LINE (x, y)-(x + 20, y + 20), , B
        y = y + 20
        already = 0
        COLOR 4 + mode: LINE (x, y)-(x + 20, y + 20), , B
        ELSE : BEEP
        END IF

        CASE CHR$(left)
        IF x > 2 THEN
        COLOR 0: LINE (x, y)-(x + 20, y + 20), , B
        x = x - 20
        already = 0
        COLOR 4 + mode: LINE (x, y)-(x + 20, y + 20), , B
        ELSE : BEEP
        END IF

        CASE CHR$(right)
        IF x < 620 THEN
        COLOR 0: LINE (x, y)-(x + 20, y + 20), , B
        x = x + 20
        already = 0
        COLOR 4 + mode: LINE (x, y)-(x + 20, y + 20), , B
        ELSE : BEEP
        END IF

        CASE "q"
        mode = lands
        COLOR 4 + mode
        LINE (x, y)-(x + 20, y + 20), , B
       
        CASE "x"
        mode = contour
        COLOR 4 + mode
        LINE (x, y)-(x + 20, y + 20), , B
       
        CASE "s"
        mode = 3
       
        CASE "b" 'bridge
        mode = bridge
        COLOR 4 + mode
        LINE (x, y)-(x + 20, y + 20), , B
       
        CASE "t" 'castle
        mode = fortress
        COLOR 4 + mode
        LINE (x, y)-(x + 20, y + 20), , B
       
       
       
        CASE CHR$(13)'enter
                SELECT CASE mode
                CASE lands
                IF land((x + 19) / 20, (y + 19) / 20) = 1 THEN
                land((x + 19) / 20, (y + 19) / 20) = 2
                COLOR 2
                LINE (x + 1, y + 1)-STEP(18, 18), , BF
                ELSE
                COLOR 1
                land((x + 19) / 20, (y + 19) / 20) = 1
                LINE (x + 1, y + 1)-STEP(18, 18), , BF
                END IF
               
                CASE contour
                IF land((x + 19) / 20, (y + 19) / 20) = 2 THEN
                land((x + 19) / 20, (y + 19) / 20) = 6
                COLOR 6
                placex = x: placey = y
                y = y + 20
                LINE (x + 1, y - 1)-(x + 10, y - 19)
                LINE (x + 10, y - 19)-(x + 19, y - 1)
                LINE (x + 19, y - 1)-(x + 1, y - 1)
                PAINT (x + 9, y - 5)
                x = placex: y = placey
                ELSEIF land((x + 19) / 20, (y + 19) / 20) = 6 THEN
                land((x + 19) / 20, (y + 19) / 20) = 2
                COLOR 2
                LINE (x + 1, y + 1)-STEP(18, 18), , BF
                END IF
               
                CASE bridge
                IF x > 0 AND x < 620 THEN
                IF already <> 1 AND land((x + 19) / 20 - 1, (y + 19) / 20) = 2 AND land((x + 19) / 20 + 1, (y + 19) / 20) = 2 AND land((x + 19) / 20, (y + 19) / 20) = 1 THEN
                'ллллллллллллллллллллллллллллллллллллллллллллллллллл
                'ллллл                   ллллллллллллллллллллллллллл
                'ллллл horizontal bridge ллллллллллллллллллллллллллл
                'ллллл                   ллллллллллллллллллллллллллл
                'ллллллллллллллллллллллллллллллллллллллллллллллллллл
                land((x + 19) / 20, (y + 19) / 20) = 7  'a horizontal bridge
                y1 = y
                y = y + 20
                COLOR 1
                already = 1
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
                y = y1
                END IF
                END IF
              
                IF y > 0 AND y < 460 THEN
                IF already <> 1 AND land((x + 19) / 20, (y + 19) / 20 - 1) = 2 AND land((x + 19) / 20, (y + 19) / 20 + 1) = 2 AND land((x + 19) / 20, (y + 19) / 20) = 1 THEN
                'vertical bridge*******************************
                '**********************************************
                y1 = y: x1 = x
                y = y + 20
                already = 1
                land((x + 19) / 20, (y + 19) / 20) = 8  'a vertical bridge 
                colornumber = 65536 * 30 + 256 * 30 + 30
                PALETTE 7, colornumber
                COLOR 7
                x = x - 1
                FOR a = 4 TO 17
                LINE (x + a, y - 1)-(x + a, y - 19)
                NEXT a
                LINE (x + 3, y - 6)-(x + 3, y - 14): LINE (x + 18, y - 6)-(x + 18, y - 14)
                y = y1: x = x1
                END IF
                END IF
               
                CASE 3'savemode
                CALL savegame(land(), xcastle(), ycastle())
               
                CASE fortress
                IF already = 0 AND land((x + 19) / 20, (y + 19) / 20) = 2 AND numofcast < 5 THEN
                        numofcast = numofcast + 1
                        xcastle(numofcast) = x - 1
                        ycastle(numofcast) = y + 19
                        already = 1
                        SELECT CASE numofcast
                        CASE 1: q = 9
                        CASE 2: q = 4
                        CASE 3: q = 10
                        CASE 4: q = 14
                        CASE 5: q = 13
                        END SELECT
                        colornumber = 65536 * 40 + 256 * 20 + 40
                        PALETTE 13, colornumber
                        CALL castle(x, y, q)
                        land((x + 19) / 20, (y + 19) / 20) = 10 'castle
                ELSEIF land((x + 19) / 20, (y + 19) / 20) = 10 THEN
                        COLOR 2
                        LINE (x + 1, y + 1)-STEP(18, 18), , BF
                        land((x + 19) / 20, (y + 19) / 20) = 2
                        numofcast = numofcast - 1
                ELSE
                        BEEP
                END IF
                END SELECT
        CASE ELSE: BEEP
END SELECT
LOOP

SUB castle (x, y, q)
x1 = x: y1 = y
y = y + 20
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

x = x1: y = y1
END SUB

SUB savegame (land(), xcastle(), ycastle())
LOCATE 1, 1: PRINT
OPEN diskfile$ FOR RANDOM AS #1
CLOSE #1
OPEN diskfile$ FOR OUTPUT AS #1
'**************|making file begins here!|****************8
PRINT "skipit = c"
PRINT "CLS"
PRINT "SCREEN 12: c = 2"
PRINT "colornumber = 65536 * 30 + 256 * 30 + 30"
PRINT "blue = CINT(17 * .95)    '17"
PRINT "red = CINT(36 * .95)     '36"
PRINT "green = CINT(50 * .95)   '50"
PRINT "colornumber = 65536 * blue + 256 * green + red"
PRINT "PALETTE c, colornumber"
PRINT "DO"
PRINT "COLOR 1"
PRINT "SELECT CASE y"
               
                FOR j = 1 TO 24
                firsttime = 1
                FOR i = 1 TO 32
                SELECT CASE land(i, j)
                CASE 1
                     IF currentland = 1 THEN
                             currentland = 0
                             IF firsttime = 1 THEN
                                     firsttime = 0
                                     number$ = STR$(j * 20 - 20)
                                     writestring$ = "CASE " + number$
PRINT writestring$
                             END IF
                          
                             stringlow$ = STR$(lowerx): stringmax$ = STR$(maxx)
                             writestring$ = "if x >" + stringlow$ + " and x <" + stringmax$ + " then color c"
PRINT writestring$
                     END IF
                CASE 2, 6
                     IF currentland = 0 THEN
                     currentland = 1
                     lowerx = i * 20 - 40
                     maxx = i * 20
                     END IF
                     maxx = i * 20
                    
                END SELECT
                NEXT i
                NEXT j
PRINT "END SELECT"
PRINT "d = 3 - c:"
PRINT "LINE (x, y)-(x + (17 + d), y + (17 + d)), , BF"
PRINT "x = x + 20"
PRINT "IF x = 640 THEN"
PRINT "y = 20 + y"
PRINT "x = 0"
PRINT "END IF"
PRINT "LOOP WHILE y < 480"
PRINT "'*************|mountain part |***********"
PRINT "DO"
PRINT "l = l + 1"
PRINT "select case l"
                FOR j = 1 TO 24
                FOR i = 1 TO 32
                IF land(i, j) = 6 OR land(i, j) = 7 OR land(i, j) = 8 THEN
                number = number + 1
                number$ = STR$(number)
                writestring$ = "CASE " + number$
                writestring$ = writestring$ + ":x =" + STR$(20 * i - 20) + ":y =" + STR$(20 * j - 20)
                kind = land(i, j)
PRINT writestring$ + ":type = " + STR$(kind)
                END IF
                NEXT i
                NEXT j
IF j = 24 AND i = 32 THEN
number$ = STR$(number + 1)
writestring$ = "CASE " + number$
writestring$ = writestring$ + ":x =" + STR$(999) + ":y =" + STR$(999)
END IF
PRINT "end select"
PRINT "select case type"
PRINT "case 6"
PRINT "if x = 999 and y = 999 then exit do"
PRINT "COLOR 6"
PRINT "y = y + 20"
PRINT "LINE (x + 1, y - 1)-(x + 10, y - 19)"
PRINT "LINE (x + 10, y - 19)-(x + 19, y - 1)"
PRINT "LINE (x + 19, y - 1)-(x + 1, y - 1)"
PRINT "PAINT (x + 9, y - 5)"
PRINT "case 7"
PRINT "y1 = y"
PRINT "y = y + 20"
PRINT "COLOR 1"
PRINT "LINE (x + 1, y - 1)-(x + 19, y - 19), , BF"
PRINT "colornumber = 65536 * 30 + 256 * 30 + 30"
PRINT "PALETTE 7, colornumber"
PRINT "COLOR 7"
PRINT "FOR a = 3 TO 15"
PRINT "z = 21 - a"
PRINT "CIRCLE (x + 11, 20 + y - z), 20, , 1.1, 2.18"
PRINT "NEXT a"
PRINT "COLOR 0"
PRINT "LINE (x, y)-(x + 20, y - 20), , B"
PRINT "y = y1"
PRINT "case 8"
PRINT "y1 = y: x1 = x"
PRINT "y = y + 20"
PRINT "colornumber = 65536 * 30 + 256 * 30 + 30"
PRINT "PALETTE 7, colornumber"
PRINT "COLOR 7"
PRINT "x = x - 1"
PRINT "FOR a = 4 TO 17"
PRINT "LINE (x + a, y - 1)-(x + a, y - 19)"
PRINT "NEXT a"
PRINT "LINE (x + 3, y - 6)-(x + 3, y - 14): LINE (x + 18, y - 6)-(x + 18, y - 14)"
PRINT "y = y1: x = x1"
PRINT "end select"
PRINT "loop"
PRINT "IF skipit <> 100 THEN"
PRINT "'CALL makecomland(comland())"
PRINT "FOR c = 1 TO 5"
PRINT "SELECT CASE c"
PRINT " CASE 1"
PRINT " x = " + STR$(xcastle(1))
PRINT " y = " + STR$(ycastle(1) + 20)
PRINT " q = 9"
PRINT " CASE 2"
PRINT " x = " + STR$(xcastle(2))
PRINT " y = " + STR$(ycastle(2) + 20)
PRINT " q = 4"
PRINT " CASE 3"
PRINT " x = " + STR$(xcastle(3))
PRINT " y = " + STR$(ycastle(3) + 20)
PRINT " q = 10"
PRINT " CASE 4"
PRINT " x = " + STR$(xcastle(4))
PRINT " y = " + STR$(ycastle(4) + 20)
PRINT " q = 14"
PRINT " CASE 5"
PRINT " x = " + STR$(xcastle(5))
PRINT " y = " + STR$(ycastle(5) + 20)
PRINT " colornumber = 65536 * 40 + 256 * 20 + 40"
PRINT " PALETTE 13, colornumber"
PRINT " q = 13"
PRINT " END SELECT"
PRINT " 'CALL castle(x, y, q)"
PRINT "NEXT c"
PRINT "END IF"
              
              
              


END SUB

