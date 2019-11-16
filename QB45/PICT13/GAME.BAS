DECLARE SUB showarea (xscreen!, yscreen!)
DECLARE SUB joyinit ()
DECLARE SUB joystatus (x%, y%, choice$)
DECLARE SUB eraseplain (zx%, zy%, BYTEPOSITION&, currentscreen%())
DECLARE SUB caves (zx%, zy%, currentscreen%(), xscreen!, yscreen!)
DECLARE SUB forestdraw (zx%, zy%, currentscreen%(), xscreen!, yscreen!)
DECLARE SUB DrawRivAndRoads (squaretype%, xscreen!, yscreen!, zx%, zy%, currentscreen%())
DECLARE SUB selectroadriver (x1%, x2%, y1%, y2%, ror%, newp%)
DECLARE SUB getattributes (piece%, x1%, x2%, y1%, y2%)
DECLARE SUB setpieces (kind%, xattrib%, yattrib%)
DECLARE SUB SHORElinedraw (kind%, xscreen!, yscreen!, pieces%(), xattrib%, yattrib%, currentscreen%())
DECLARE SUB MousePut (x%, y%)
DECLARE SUB special (xscreen!, yscreen!, direction%, currentscreen%(), xb!, yb!)
DECLARE SUB mountainfix (xscreen, yscreen, currentscreen%())
DECLARE FUNCTION round! (DP!, number!)
DECLARE SUB mousestatus (lb%, rb%, zx%, zy%)
DECLARE SUB mouseshow ()
DECLARE SUB mousehide ()
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE FUNCTION MouseInit% ()
DECLARE SUB DrawScreen (xscreen!, yscreen!, currentscreen%(), direction%, xb!, yb!)
DECLARE SUB putpicture (f!, x, y)
DECLARE SUB loadpics (filename$())
DECLARE SUB putscreen (currentscreen%())
DECLARE SUB openpalette (pal&(), currentpalette%)
DECLARE SUB GetData (xscreen, yscreen, currentscreen%(), byte$)
CLS
CONST xscreenmax = 48, yscreenmax = 48, maxpalettes = 2
CONST plds = 148' number of pld files
CONST downleft = 1, downright = 3, upright = 9, upleft = 7
CONST up = 8, down = 2, left = 4, right = 6
CONST yes = -1, no = 1
CONST DP% = 2 ' for decimal place, used in the rounding function
CONST mapfound$ = "c:\qb45\pict13\plds\worldmap.dat"
CONST pals = 6
DEFINT A-Z
'$DYNAMIC
DIM xscreen AS SINGLE, yscreen AS SINGLE, xb AS SINGLE, yb AS SINGLE
DIM SHARED byte AS STRING * 1
DIM currentscreen(16, 10) AS INTEGER 'tells what type of land each square is.
DIM pal(255, pals) AS LONG 'maxpalettes different palettes
DIM wholescreen(16001) AS LONG
DIM filename$(plds)
DIM pieces(3, 2)
DIM SHARED piece(plds)
DIM SHARED opiece(plds)


INPUT "Where are the data files"; where$
IF where$ <> "" THEN
CHDIR where$
ELSE
CHDIR "c:\qb45\pict13\plds"
END IF
INPUT "Do you have a joystick (y/n)"; joy$
IF LEFT$((UCASE$(joy$)), 1) = "Y" THEN joy = yes

xscreen = 0      '   40     possible
yscreen = 0      '   30     possible
                 '
                 '  each square will be 20 * 20 pixels, making
                 '  for a screen of 16 * 10
                 '
' when the xscreen becomes > (xscreen - 1) then it starts to wrap around the other side
DIM SHARED mouse$

RESTORE mousedat
mouse$ = SPACE$(57)
FOR i% = 1 TO 57
  READ a$
  h$ = CHR$(VAL("&H" + a$))
  MID$(mouse$, i%, 1) = h$

NEXT i%

mousedat:
DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
DATA 8B,5E,06,89,17,5D,CA,08,00

ms% = MouseInit%

DIM SHARED picture(101, plds) AS LONG
                  
'the size of each screen is 16* 10, but the numbers 0 and 17 for across
' and 0 and 11 for down will be squares not on the screen, but which will
' affect the current screen.
DIM SHARED xjmin AS INTEGER, xjmax AS INTEGER, yjmin AS INTEGER, yjmax AS INTEGER

IF joy = yes THEN
joyinit
END IF

CLS
LOCATE 1, 1: PRINT "Opening palettes..."
CALL openpalette(pal&(), currentpalette)

    SCREEN 13
    PALETTE USING pal&(0, 4)                      ' Change the palette to the first one
                 'starting with first color, the first palette
    currentpalette = 4
LOCATE 1, 1: PRINT "Opening pictures...";

DIM SHARED smallpics(1, plds) AS LONG

RESTORE NAMES
FOR i = 1 TO plds

SELECT CASE i
CASE 1: a& = -991244614
CASE 2: a& = -993072454
CASE 47: a& = -993072704
CASE 48: a& = -825966359
CASE 49: a& = -991506852
CASE 50: a& = -826227482
CASE 51: a& = -991640347
CASE 52: a& = -993729052
CASE 3, 11, 18: a& = -356861254
CASE 4: a& = -1162155334
CASE 5: a& = -356861254
CASE 6: a& = -1159021894
CASE 7, 12, 15: a& = -340071750
CASE 8, 9, 16: a& = -336938310
CASE 10, 13, 14, 17: a& = -336926022
CASE 23, 30: a& = -826623302
CASE 19, 24, 27: a& = -826618182
CASE 20, 21, 28: a& = -825312582
CASE 22, 25, 26, 29: a& = -825307462
CASE 31: a& = -423565632
CASE 32: a& = -1058619162
CASE 33: a& = -437337920
CASE 34: a& = -1061099803
CASE 35: a& = -423566107
CASE 36: a& = -1058489664
CASE 37: a& = -454629952
CASE 38: a& = -1161772824
CASE 39: a& = -1058675228
CASE 40: a& = -390020934
CASE 41: a& = -454835995
CASE 42: a& = -1061492800
CASE 43: a& = -437590336
CASE 44: a& = -354041626
CASE 45: a& = -437982528
CASE 46: a& = -356456987
CASE 53 TO 68: a& = -943011633
CASE 68: a& = -909587505
CASE 69 TO 72: a& = -1162759501
CASE 73, 74: a& = -1347637587
CASE 75 TO 90, 97: a& = -623191079
CASE 91: a& = -1145390406
CASE 92: a& = -1145389737
CASE 93: a& = -1128547652
CASE 94: a& = -454892060
CASE 95: a& = -471669277
CASE 96: a& = -488315677
CASE 98 TO 101, 106: a& = -657008937
CASE 102: a& = -675621161
CASE 103: a& = -673786182
CASE 104: a& = -1160259368
CASE 105: a& = -690432070
CASE 131 TO 133: a& = -741813552
CASE 134: a& = -623256871
CASE 135: a& = -623584549
CASE 136: a& = -1044006205
CASE 137: a& = -1042693183
CASE 138 TO 142: a& = -1027488829
CASE 143 TO 145: a& = -440286014
CASE 146 TO 148: a& = -1025129279
END SELECT
smallpics(0, i) = 131088
smallpics(1, i) = a&

READ k$
IF k$ = "-1" THEN
i = 127
ELSE
filename$(i) = k$
END IF
NEXT i

CALL loadpics(filename$())
OPEN mapfound$ FOR BINARY ACCESS READ WRITE AS #1
CLS

OPEN "lastpos.dat" FOR BINARY AS #2
GET #2, , xscreen
GET #2, , yscreen
CLOSE #2

CALL DrawScreen(xscreen, yscreen, currentscreen%(), direction, xb!, yb!)
   ' turn numlock off
   DEF SEG = 0
   POKE (1047), 32
   DEF SEG


a! = TIMER


mouseshow
DIM box(3000) AS LONG
squaretype = 73
f = 1

DO
direction = 0

DO
            DO
                        q = zx%: w = zy%: leftcheck = lb%: rightcheck = rb%
                        CALL mousestatus(lb%, rb%, zx%, zy%)
                        choice$ = INKEY$
                       
                             IF joy = yes AND zx% = q AND zy% = w AND lb% <> yes AND rb% <> yes AND choice$ = "" THEN
                             CALL joystatus(x, y, choice$)
                             END IF
           
            LOOP WHILE choice$ = "" AND zx% = q AND zy% = w AND (leftcheck = lb% AND ((squaretype = 94 OR squaretype = 95 OR squaretype = 96) OR (squaretype = 91 OR squaretype = 92 OR squaretype = 93)) AND squaretype = os) AND rb% = NOT yes
       
            IF lb% = -1 THEN
                
                IF holddown = no THEN     'if check = 1 then the mouse is being dragged
                        startx% = zx%             ' with the left button held down
                        starty% = zy%
                        holddown = yes
                END IF
                
            ELSE
              clickpause = yes
              IF (pieces(3, 1) <> (zx% \ 20 + 1) OR pieces(3, 2) <> (zy% \ 20 + 1)) AND lb% <> -1 THEN
                        f = 1
                        check = 0
              END IF
              holddown = no
            END IF
        
LOOP WHILE choice$ = "" AND lb% = NOT yes AND rb% = NOT yes



doubleclick = no
       
IF lb% = -1 THEN
        GOSUB LEFTBUTTON
        
       
        IF doubleclick = yes THEN
                mousehide
                GET (5 * 8 - 1, 11 * 8 - 1)-(30 * 8 + 1, 12 * 8 + 1), box(0)
                LINE (39, 87)-(241, 97), 0, BF
                LOCATE 12, 6: INPUT "Square to change to"; s
                IF s > 0 AND s < plds + 1 THEN squaretype = s
                PUT (5 * 8 - 1, 11 * 8 - 1), box(0), PSET
                mouseshow
                erse = no
        ELSE
                   
                    IF ((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%) AND squaretype > 30 AND squaretype < 43 AND check <> 0 AND (pieces(3, 1) <> (zx% \ 20 + 1) OR pieces(3, 2) <> (zy% \ 20 + 1)) THEN  'SHOREpiece
                                mousehide
                                pieces(1, 1) = pieces(2, 1)
                                pieces(1, 2) = pieces(2, 2)
                                pieces(2, 1) = pieces(3, 1)
                                pieces(2, 2) = pieces(3, 2)
                                pieces(3, 1) = zx% \ 20 + 1
                                pieces(3, 2) = zy% \ 20 + 1
                                CALL SHORElinedraw(kind%, xscreen!, yscreen!, pieces(), xattrib, yattrib, currentscreen())
                                mouseshow
                                ox% = (zx% \ 20): oy% = (zy% \ 20)
                    ELSE
                               
                                IF (squaretype = 131) THEN
                                           
                                            mousehide
                                            CALL caves(zx%, zy%, currentscreen%(), xscreen!, yscreen!)
                                           
                                            'CALL mountainfix(xscreen, yscreen, currentscreen%())
                                            ox% = (zx% \ 20): oy% = (zy% \ 20)
                                            mouseshow
                                END IF
                               
                                IF (((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%) OR os <> 72) AND (squaretype = 72) THEN
                                            mousehide
                                            CALL forestdraw(zx%, zy%, currentscreen%(), xscreen!, yscreen!)
                                            ox% = (zx% \ 20): oy% = (zy% \ 20)
                                            os = 72
                                            mouseshow
                                END IF
                               
                                IF (squaretype = 30 OR squaretype = 18) AND (((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%) OR lastaction = 0) THEN
                                'reassign the four pieces around, then change the one in the middle
                                mousehide
                                CALL DrawRivAndRoads(squaretype, xscreen!, yscreen!, zx%, zy%, currentscreen%())
                                ox% = (zx% \ 20): oy% = (zy% \ 20)
                                mouseshow
                                lastaction = 1
                                ELSEIF ((((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%)) OR (squaretype <> os OR rb% = -1)) AND (squaretype <> 30 AND squaretype <> 18) THEN
                                           
                                            mousehide
                                            
                                            yfig! = yscreen + (zy% \ 20) / 10
                                            xfig! = xscreen + (zx% \ 20) / 16
                                            IF xscreen + (zx% \ 20) / 16 >= xscreenmax THEN xfig! = xscreen + (zx% \ 20) / 16 - xscreenmax
                                            IF yscreen + (zy% \ 20) / 10 >= yscreenmax THEN yfig! = yscreen + (zy% \ 20) / 10 - yscreenmax
                                            BYTEPOSITION& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax)
                                            currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = squaretype
                                            byte$ = CHR$(squaretype)
                                            PUT #1, BYTEPOSITION& + 1, byte$
                                            PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, squaretype), PSET
                                            ox% = (zx% \ 20): oy% = (zy% \ 20)
                                            os = squaretype
                                            IF erse = yes THEN CALL eraseplain(zx%, zy%, BYTEPOSITION&, currentscreen())

                                            IF (squaretype > 90 AND squaretype < 97) AND rb% = yes AND holddown = yes THEN
                                                        IF zx% \ 20 < startx% \ 20 THEN
                                                        si = (zx% \ 20) + 1
                                                        ei = (startx% \ 20) + 1
                                                        ELSE
                                                        si = (startx% \ 20) + 1
                                                        ei = (zx% \ 20) + 1
                                                        END IF
                                                        IF zy% \ 20 < starty% \ 20 THEN
                                                        sj = (zy% \ 20) + 1
                                                        ej = (starty% \ 20) + 1
                                                        ELSE
                                                        sj = (starty% \ 20) + 1
                                                        ej = (zy% \ 20) + 1
                                                        END IF
                                                       
                                                        FOR i = si TO ei
                                                        FOR j = sj TO ej
                                                                    currentscreen%(i, j) = squaretype
                                                                    yfig! = yscreen + (j - 1) / 10
                                                                    xfig! = xscreen + (i - 1) / 16
                                                                    IF xscreen + (i - 1) / 16 >= xscreenmax THEN xfig! = xscreen + (i - 1) / 16 - xscreenmax
                                                                    IF yscreen + (j - 1) / 10 >= yscreenmax THEN yfig! = yscreen + (j - 1) / 10 - yscreenmax
                                                                    BYTEPOSITION& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax)
                                                                    byte$ = CHR$(squaretype)
                                                                    PUT #1, BYTEPOSITION& + 1, byte$
                                                                    PUT ((i - 1) * 20, (j - 1) * 20), picture&(0, squaretype), PSET
                                                        NEXT
                                                        NEXT
                                            
                                            END IF
                                            mouseshow
                                lastaction = 0
                                END IF
                    END IF
       
                    IF check = 0 AND squaretype > 30 AND squaretype < 43 AND (pieces(f, 1) <> zx% \ 20 + 1 OR pieces(f, 2) <> zy% \ 20 + 1) THEN 'if check = 1 then the mouse is being dragged
                                f = f + 1
                                'IF zx% \ 20 < 1 OR zx% \ 20 > 14 THEN
                                '            f = 3
                                '            IF zx% \ 20 < 1 THEN
                                '            pieces(2, 1) = zx% \ 20
                                '            pieces(2, 2) = zy% \ 20 + 1
                                '            ELSE
                                '            pieces(2, 1) = zx% \ 20 + 2
                                '            pieces(2, 2) = zy% \ 20 + 1
                                '            END IF
                                '                        kind = squaretype
                                '                        CALL setpieces(kind, xattrib, yattrib)
                                'END IF
                                'IF zy% \ 20 < 1 OR zy% \ 20 > 8 THEN
                                '            f = 3
                                '           IF zx% \ 20 < 1 THEN
                                '            pieces(2, 1) = zx% \ 20 + 1
                                '           pieces(2, 2) = zy% \ 20
                                '            ELSE
                                '            pieces(2, 1) = zx% \ 20 + 1
                                '            pieces(2, 2) = zy% \ 20 + 2
                                '            END IF
                                '                        kind = squaretype
                                '                        CALL setpieces(kind, xattrib, yattrib)
                                'END IF
                               
                                pieces(f, 1) = zx% \ 20 + 1
                                pieces(f, 2) = zy% \ 20 + 1
                                            IF f = 2 THEN
                                                        kind = squaretype
                                                        CALL setpieces(kind, xattrib, yattrib)
                                                      
                                            END IF
                                IF f = 3 THEN
                                            check = 1
                                            f = 1
                                END IF
                    END IF
                   
        END IF

ELSE
            IF choice$ = "" THEN choice$ = ","
            IF ASC(choice$) > 48 AND ASC(choice$) < 58 THEN

                    
                        SELECT CASE choice$
                        CASE "H", "8"
                        direction = up
                        mousehide
                        GET (0, 0)-(319, 179), wholescreen&(0)
                        PUT (0, 20), wholescreen&(0), PSET
                        yb! = yscreen
                        yscreen = yscreen - .1

                        IF LEN(STR$(yscreen)) > 5 THEN     ' what in the heck is going on?
                                number! = yscreen
                                yscreen = round(DP, number!)
                        END IF

                        IF yscreen < 0 THEN yscreen = (yscreenmax - 1 / 10)

                        CASE "P", "2"
                        direction = down
                        mousehide
                        GET (0, 20)-(319, 199), wholescreen&(0)
                        PUT (0, 0), wholescreen&(0), PSET
                        yb! = yscreen
                        yscreen = yscreen + (1 / 10)

                        IF LEN(STR$(yscreen)) > 5 THEN     ' what in the heck is going on?
                                number! = yscreen
                                yscreen = round(DP, number!)
                        END IF

                        IF yscreen = yscreenmax THEN yscreen = 0

                        CASE "K", "4"

                        direction = left
                        mousehide
                        GET (0, 0)-(299, 199), wholescreen&(0)
                        PUT (20, 0), wholescreen&(0), PSET
                        xb! = xscreen
                        xscreen = xscreen - .0625
                        IF xscreen < 0 THEN xscreen = (xscreenmax - 1 / 16)

                        CASE "M", "6"
                        direction = right
                        mousehide
                        GET (20, 0)-(319, 199), wholescreen&(0)
                        PUT (0, 0), wholescreen&(0), PSET
                        xb! = xscreen
                        xscreen = xscreen + .0625
                        IF xscreen = xscreenmax THEN xscreen = 0

                        CASE "1"
                        direction = downleft
                        mousehide
                        GET (0, 20)-(299, 199), wholescreen&(0)
                        PUT (20, 0), wholescreen&(0), PSET
                        xb! = xscreen
                        yb! = yscreen
                        xscreen = xscreen - .0625
                        yscreen = yscreen + .1
                        IF LEN(STR$(yscreen)) > 5 THEN     ' what in the heck is going on?
                                number! = yscreen
                                yscreen = round(DP, number!)
                        END IF
                        IF xscreen < 0 THEN xscreen = (xscreenmax - 1 / 16)
                        IF yscreen = yscreenmax THEN yscreen = 0

                        CASE "3"
                        direction = downright
                        mousehide
                        GET (20, 20)-(319, 199), wholescreen&(0)
                        PUT (0, 0), wholescreen&(0), PSET
                        xb! = xscreen
                        yb! = yscreen
                        xscreen = xscreen + .0625
                        yscreen = yscreen + .1
                        IF LEN(STR$(yscreen)) > 5 THEN     ' what in the heck is going on?
                                number! = yscreen
                                yscreen = round(DP, number!)
                        END IF
                        IF xscreen = xscreenmax THEN xscreen = 0
                        IF yscreen = yscreenmax THEN yscreen = 0

                        CASE "7"
                        direction = upleft
                        mousehide
                        GET (0, 0)-(299, 179), wholescreen&(0)
                        PUT (20, 20), wholescreen&(0), PSET
                        xb! = xscreen
                        yb! = yscreen
                        xscreen = xscreen - .0625
                        yscreen = yscreen - .1
                        IF LEN(STR$(yscreen)) > 5 THEN     ' what in the heck is going on?
                                number! = yscreen
                                yscreen = round(DP, number!)
                        END IF
                        IF yscreen < 0 THEN yscreen = (yscreenmax - 1 / 10)
                        IF xscreen < 0 THEN xscreen = (xscreenmax - 1 / 16)

                        CASE "9"
                        direction = upright
                        mousehide
                        GET (20, 0)-(319, 179), wholescreen&(0)
                        PUT (0, 20), wholescreen&(0), PSET
                        xb! = xscreen
                        yb! = yscreen
                        xscreen = xscreen + .0625
                        yscreen = yscreen - .1
                        IF LEN(STR$(yscreen)) > 5 THEN     ' what in the heck is going on?
                                number! = yscreen
                                yscreen = round(DP, number!)
                        END IF
                        IF xscreen = xscreenmax THEN xscreen = 0
                        IF yscreen < 0 THEN yscreen = (yscreenmax - 1 / 10)
                        END SELECT

                        
                        CALL DrawScreen(xscreen, yscreen, currentscreen%(), direction, xb!, yb!)
                        mouseshow

            ELSE
                        SELECT CASE choice$
                        CASE CHR$(13): CALL mountainfix(xscreen, yscreen, currentscreen%())
                        
                        CASE CHR$(32):
                            
                                FOR i = 1 TO 15
                                LINE (i * 20, 0)-(i * 20, 199), 0
                                NEXT i
                                FOR i = 1 TO 9
                                LINE (0, i * 20)-(319, i * 20), 0
                                NEXT
                                LOCATE 1, 1: PRINT "x:"; zx%
                                PRINT "y:"; zy%
                                PRINT "XSquare"; xscreen * 16 + (zx% \ 20)
                                PRINT "YSquare"; yscreen * 10 + (zy% \ 20)
                                PRINT "XScreen"; xscreen
                                PRINT "YScreen"; yscreen
                                PRINT "Type:"; currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1)
                        CASE "`"
                             CALL showarea(xscreen!, yscreen!)
                              DO
                              CALL mousestatus(lb%, rb%, zx%, zy%)
                              IF lb% = -1 OR rb% = -1 THEN EXIT DO
                              LOOP WHILE INKEY$ = ""
                              choice$ = "c"
                              
                        CASE "s"
                             currentpalette = currentpalette + 1
                             IF currentpalette > pals THEN currentpalette = 1
                             PALETTE USING pal&(0, currentpalette)
                        CASE "v": squaretype = 131: erse = no
                        CASE "h": squaretype = 68: erse = no
                        CASE "r": squaretype = 30: erse = no
                        CASE "R": squaretype = 18: erse = no
                        CASE "f": squaretype = 72: erse = no
                        CASE "p": squaretype = 91: erse = no
                        CASE "o": squaretype = 94: erse = no
                        CASE "e": squaretype = 91: erse = yes
                        CASE "t": squaretype = 74: erse = no
                        CASE "T": squaretype = 73: erse = no
                        CASE "m"
                                        mousehide
                                        GET (5 * 8 - 1, 11 * 8 - 1)-(30 * 8 + 1, 12 * 8 + 1), box(0)
                                        LOCATE 12, 6: INPUT "X Coordinate"; xscreen
                                        LOCATE 12, 6: INPUT "Y Coordinate"; yscreen
                                        IF xscreen >= xscreenmax OR xscreen < 0 THEN xscreen = 0
                                        IF yscreen >= yscreenmax OR yscreen < 0 THEN yscreen = 0
                                        PUT (5 * 8 - 1, 11 * 8 - 1), box(0), PSET
                                        choice$ = "c"
                                        MousePut 160, 100
                       
                        CASE CHR$(0) + "H"
                        choice$ = "c"
                        yscreen = yscreen - 1: IF yscreen < 0 THEN yscreen = yscreen + yscreenmax
                        CASE CHR$(0) + "P":
                        choice$ = "c"
                        yscreen = yscreen + 1: IF yscreen >= yscreenmax THEN yscreen = yscreen - yscreenmax
                        CASE CHR$(0) + "K"
                        choice$ = "c"
                        xscreen = xscreen - 1: IF xscreen < 0 THEN xscreen = xscreen + xscreenmax
                        CASE CHR$(0) + "M"
                        choice$ = "c"
                        xscreen = xscreen + 1: IF xscreen >= xscreenmax THEN xscreen = xscreen - xscreenmax
                        END SELECT
                       
                        IF rb% = -1 THEN
                        ox% = (zx% \ 20): oy% = (zy% \ 20)
                        lastaction = 0
                        squaretype = currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1)
                        erse = no
                        END IF

                        IF UCASE$(choice$) = "C" THEN
                        mousehide
                        CALL DrawScreen(xscreen, yscreen, currentscreen%(), direction, xb!, yb!): mouseshow
                        mouseshow
                        END IF

                        IF choice$ = CHR$(27) THEN
                                    FOR j = 1 TO 5
                                    i = 170
                                    DO
                                    blue = INT(pal&(i, currentpalette) / 65536): pal&(i, currentpalette) = pal&(i, currentpalette) - blue * 65536
                                    green = INT(pal&(i, currentpalette) / 256): pal&(i, currentpalette) = pal&(i, currentpalette) - green * 256
                                    red = pal&(i, currentpalette)
                                    blue = blue * (10 - (j / 3)) / 10: green = green * (10 - (j / 3)) / 10: red = red * (10 - (j / 3)) / 10
                                    PALETTE i, 65536 * blue + 256 * green + red
                                    pal&(i, currentpalette) = 65536 * blue + 256 * green + red
                                    IF i = 240 THEN EXIT DO
                                    i = i + 1
                                    LOOP
                                    NEXT
                                            
                                             OPEN "lastpos.dat" FOR BINARY AS #2
                                             PUT #2, , xscreen
                                             PUT #2, , yscreen
                                             CLOSE #2
                                             CLOSE #1
                                   
                                    END
                        END IF
            END IF

END IF


LOOP
 

LEFTBUTTON:
thisclick! = TIMER
IF ((thisclick! - lastclick!) > .1 AND (thisclick! - lastclick!) < .2) AND clickpause = yes THEN
doubleclick = yes
END IF
clickpause = no
lastclick! = thisclick!
RETURN


NAMES:
DATA "BRIDGE1.PLD"
' # 1
DATA "BRIDGE2.PLD"
' # 2
DATA "RIVBEGN2.PLD"
' # 3
DATA "RIVBEGN4.PLD"
' # 4
DATA "RIVBEGN1.PLD"
' # 5
DATA "RIVBEGN3.PLD"
' # 6
DATA "RIVER6.PLD"
' # 7
DATA "RIVER1.PLD"
' # 8
DATA "RIVER3.PLD"
' # 9
DATA "RIVER2.PLD"
' # 10
DATA "RIVER5.PLD"
' # 11
DATA "RIVER4.PLD"
' # 12
DATA "RIVJOIN3.PLD"
' # 13
DATA "RIVJOIN2.PLD"
' # 14
DATA "RIVJOIN4.PLD"
' # 15
DATA "RIVJOIN1.PLD"
' # 16
DATA "RIVJOIN5.PLD"
' # 17
DATA "RIVER7.PLD"
' # 18
DATA "ROAD1.PLD"
' # 19
DATA "ROAD2.PLD"
' # 20
DATA "ROAD3.PLD"
' # 21
DATA "ROAD4.PLD"
' # 22
DATA "ROAD5.PLD"
' # 23
DATA "ROAD6.PLD"
' # 24
DATA "RODJOIN1.PLD"
' # 25
DATA "RODJOIN2.PLD"
' # 26
DATA "RODJOIN3.PLD"
' # 27
DATA "RODJOIN4.PLD"
' # 28
DATA "RODJOIN5.PLD"
' # 29
DATA "ROAD7.PLD"
' # 30
DATA "SHORE3.PLD"
' # 31
DATA "SHORE4.PLD"
' # 32
DATA "SHORE1.PLD"
' # 33
DATA "SHORE2.PLD"
' # 34
DATA "SHORE10.PLD"
' # 35
DATA "SHORE8.PLD"
' # 36
DATA "SHORE9.PLD"
' # 37
DATA "SHORE5.PLD"
' # 38
DATA "SHORE11.PLD"
' # 39
DATA "SHORE7.PLD"
' # 40
DATA "SHORE12.PLD"
' # 41
DATA "SHORE6.PLD"
' # 42
DATA "MOUTH1.PLD"
' # 43
DATA "MOUTH2.PLD"
' # 44
DATA "MOUTH4.PLD"
' # 45
DATA "MOUTH3.PLD"
' # 46
DATA "BRIDGE3.PLD"
' # 47
DATA "BRIDGE4.PLD"
' # 48
DATA "BRIDGE6.PLD"
' # 49
DATA "BRIDGE7.PLD"
' # 50
DATA "BRIDGE8.PLD"
' # 51
DATA "BRIDGE5.PLD"
' # 52
DATA "MOUNTAN1.PLD"
' # 53
DATA "MOUNTAN2.PLD"
' # 54
DATA "MOUNTAN3.PLD"
' # 55
DATA "MOUNTAN4.PLD"
' # 56
DATA "MOUNTAN5.PLD"
' # 57
DATA "MOUNTAN6.PLD"
' # 58
DATA "MOUNTAN7.PLD"
' # 59
DATA "MOUNTAN8.PLD"
' # 60
DATA "MOUNTAN9.PLD"
' # 61
DATA "MOUNTA10.PLD"
' # 62
DATA "MOUNTA11.PLD"
' # 63
DATA "MOUNTA12.PLD"
' # 64
DATA "MOUNTA13.PLD"
' # 65
DATA "MOUNTA14.PLD"
' # 66
DATA "MOUNTA15.PLD"
' # 67
DATA "MOUNTA16.PLD"
' # 68
DATA "FOREST2.PLD"
' # 69
DATA "FOREST1.PLD"
' # 70
DATA "FOREST3.PLD"
' # 71
DATA "FOREST4.PLD"
' # 72
DATA "TREES1.PLD"
' # 73
DATA "TREES2.PLD"
' # 74
DATA "WALL1.PLD"
' # 75
DATA "WALL2.PLD"
' # 76
DATA "WALL3.PLD"
' # 77
DATA "WALL4.PLD"
' # 78
DATA "WALL5.PLD"
' # 79
DATA "WALL6.PLD"
' # 80
DATA "WALL7.PLD"
' # 81
DATA "WALL8.PLD"
' # 82
DATA "WALL9.PLD"
' # 83
DATA "WALL10.PLD"
' # 84
DATA "WALL11.PLD"
' # 85
DATA "WALL12.PLD"
' # 86
DATA "WALL13.PLD"
' # 87
DATA "WALL14.PLD"
' # 88
DATA "WALL15.PLD"
' # 89
DATA "WALL16.PLD"
' # 90
DATA "PLAINS1.PLD"
' # 91
DATA "PLAINS2.PLD"
' # 92
DATA "PLAINS3.PLD"
' # 93
DATA "OCEAN1.PLD"
' # 94
DATA "OCEAN2.PLD"
' # 95
DATA "OCEAN3.PLD"
' # 96
DATA "BOULDER.PLD"
' # 97
DATA "DESERT8.PLD"
' # 98
DATA "DESERT9.PLD"
' # 99
DATA "DESERT6.PLD"
' # 100
DATA "DESERT7.PLD"
' # 101
DATA "DESERT5.PLD"
' # 102
DATA "DESERT2.PLD"
' # 103
DATA "DESERT4.PLD"
' # 104
DATA "DESERT3.PLD"
' # 105
DATA "DESERT1.PLD"
' # 106
DATA "-1"
' the next one is actually # 128
DATA "HARBOR1.PLD"
' # 241
DATA "HARBOR2.PLD"
' # 242
DATA "HARBOR3.PLD"
' # 243
DATA "CAVE1.PLD"
' # 244
DATA "CAVE2.PLD"
' # 245
DATA "CAVE3.PLD"
' # 246
DATA "CASTLE1.PLD"
' # 247
DATA "CASTLE2.PLD"
' # 248
DATA "CASTLE3.PLD"
' # 249
DATA "CASTLE4.PLD"
' # 250
DATA "HUT1.PLD"
' # 251
DATA "TOWN1.PLD"
' # 252
DATA "TOWN2.PLD"
' # 253
DATA "TOWN3.PLD"
' # 254
DATA "TOWN4.PLD"
' # 255


DATA "HARBOR1.PLD"
       
DATA "HARBOR2.PLD"
'
DATA "HARBOR3.PLD"
'
DATA "HARBOR4.PLD"
'
DATA "HARBOR5.PLD"
'
DATA "HARBOR6.PLD"
'

neworder:
DATA 1,2                    
'road/river-bridge
DATA 61,63,60,62            
'rivbegin
DATA 33,28,30,29,32,31,36,35,37,34,110,116
'rivers
DATA 38,39,40,41,42,43,64,65,66,67,109,115
'road
DATA 46,47,44,45,53,51,52,48,54,50,55,49
'shores
DATA 22,23,25,24,103,104,106,107,108,105
'mouths/bridges
DATA 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
'mountains                                                                                                      2,13,14,15,16,17,18,19,20,21      'mountains
DATA 4,3,5,59,56,57         
'forests/trees
DATA 83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98
'walls
DATA 27,117,118             
'plains
DATA 26,119,120             
'oceans
DATA 121                    
'boulder
DATA 81,82,79,80            
'deserts
DATA 78,  75,  77,  76      
'deserts
DATA 74                     
'deserts

DATA -1

'the next one would be # 241
DATA 71,72,73             
'harbors
DATA 68,69,70               
'caves
DATA 111,112,113,114        
'castle
DATA 58                     
'huts
DATA 99,100,101,102

REM $STATIC
SUB caves (zx%, zy%, currentscreen%(), xscreen!, yscreen!)

newp = 131
piece = currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1)
IF piece = 65 THEN newp = 133
IF piece = 133 THEN newp = 65
IF piece = 63 THEN newp = 132
IF piece = 132 THEN newp = 63
IF piece = 131 THEN newp = 68

yfig! = yscreen! + (zy% \ 20) / 10
xfig! = xscreen! + (zx% \ 20) / 16
IF xscreen! + (zx% \ 20) / 16 >= xscreenmax THEN xfig! = xscreen! + (zx% \ 20) / 16 - xscreenmax
IF yscreen! + (zy% \ 20) / 10 >= yscreenmax THEN yfig! = yscreen! + (zy% \ 20) / 10 - yscreenmax
byte$ = CHR$(newp)
BYTEPOSITION& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax) + 1
PUT #1, BYTEPOSITION&, byte$
PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = newp
END SUB

SUB DrawRivAndRoads (squaretype, xscreen!, yscreen!, zx%, zy%, currentscreen%())

centerpiece = currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1)

yfig! = yscreen! + (zy% \ 20) / 10
xfig! = xscreen! + (zx% \ 20) / 16
IF xscreen! + (zx% \ 20) / 16 >= xscreenmax THEN xfig! = xscreen! + (zx% \ 20) / 16 - xscreenmax
IF yscreen! + (zy% \ 20) / 10 >= yscreenmax THEN yfig! = yscreen! + (zy% \ 20) / 10 - yscreenmax

BYTEPOSITION& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax) + 1

IF squaretype = 30 THEN ror = 1 ELSE ror = 2
j1 = no: j2 = no: j3 = no: j4 = no

GET #1, BYTEPOSITION& - (16 * xscreenmax), byte$
piece = ASC(byte$)
IF (ror = 1 AND piece = 1 OR piece = 50 OR piece = 51 OR piece = 49) OR (ror = 2 AND piece = 2 OR piece = 46) THEN j1 = yes
IF (ror = 2 AND piece > 6 AND piece < 17) OR (ror = 1 AND piece > 18 AND piece < 25) OR (ror = 2 AND piece > 2 AND piece < 7) OR (ror = 1 AND piece > 24 AND piece < 29) OR (ror = 1 AND piece = 30 OR ror = 2 AND piece = 18) OR (ror = 1 AND piece = 29 _
 OR ror = 2 AND piece = 17) THEN
j1 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF y2 <> yes THEN
y2 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, BYTEPOSITION& - (16 * xscreenmax), byte$
n = ((zy% \ 20) - 1)
IF n >= 0 THEN
PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, n + 1) = newp
END IF
END IF
END IF

GET #1, BYTEPOSITION& + (16 * xscreenmax), byte$
piece = ASC(byte$)
IF (ror = 1 AND piece = 1 OR piece = 50 OR piece = 51 OR piece = 49) OR (ror = 2 AND piece = 2 OR piece = 45) THEN j2 = yes
IF (ror = 2 AND piece > 6 AND piece < 17) OR (ror = 1 AND piece > 18 AND piece < 25) OR (ror = 2 AND piece > 2 AND piece < 7) OR (ror = 1 AND piece > 24 AND piece < 29) OR (ror = 1 AND piece = 30 OR ror = 2 AND piece = 18) OR (ror = 1 AND piece = 29 _
 OR ror = 2 AND piece = 17) THEN
j2 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF y1 <> yes THEN
y1 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, BYTEPOSITION& + (16 * xscreenmax), byte$
n = ((zy% \ 20) + 1)
IF n < 10 THEN
PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, n + 1) = newp
END IF
END IF
END IF

GET #1, BYTEPOSITION& - 1, byte$
piece = ASC(byte$)
IF (ror = 2 AND piece = 1) OR (ror = 1 AND (piece = 2 OR piece = 44 OR piece = 48 OR ((piece = 47 OR piece = 52) AND (centerpiece = 94 OR centerpiece = 95 OR centerpiece = 96)))) THEN j3 = yes
IF (ror = 2 AND piece > 6 AND piece < 17) OR (ror = 1 AND piece > 18 AND piece < 25) OR (ror = 2 AND piece > 2 AND piece < 7) OR (ror = 1 AND piece > 24 AND piece < 29) OR (ror = 1 AND piece = 30 OR ror = 2 AND piece = 18) OR (ror = 1 AND piece = 29 _
 OR ror = 2 AND piece = 17) THEN
j3 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF x2 <> yes THEN
x2 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, BYTEPOSITION& - 1, byte$
n = ((zx% \ 20) - 1)
IF n >= 0 THEN
PUT (n * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(n + 1, zy% \ 20 + 1) = newp
END IF
END IF
END IF

GET #1, BYTEPOSITION& + 1, byte$
piece = ASC(byte$)
IF (ror = 2 AND piece = 1) OR (ror = 1 AND (piece = 2 OR piece = 43 OR piece = 47 OR ((piece = 52 OR piece = 48) AND (centerpiece = 94 OR centerpiece = 95 OR centerpiece = 96)))) THEN j4 = yes
IF (ror = 2 AND piece > 6 AND piece < 17) OR (ror = 1 AND piece > 18 AND piece < 25) OR (ror = 2 AND piece > 2 AND piece < 7) OR (ror = 1 AND piece > 24 AND piece < 29) OR (ror = 1 AND piece = 30 OR ror = 2 AND piece = 18) OR (ror = 1 AND piece = 29 _
 OR ror = 2 AND piece = 17) THEN
j4 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF x1 <> yes THEN
x1 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, BYTEPOSITION& + 1, byte$
n = ((zx% \ 20) + 1)
IF n < 16 THEN
PUT (n * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(n + 1, zy% \ 20 + 1) = newp
END IF
END IF
END IF

y1 = j1: y2 = j2: x1 = j3: x2 = j4
newp = squaretype
CALL selectroadriver(x1, x2, y1, y2, ror, newp)

SELECT CASE centerpiece
CASE 94, 95, 96
IF ror = 1 THEN
IF j1 = yes OR j2 = yes THEN newp = 51
IF j3 = yes OR j4 = yes THEN newp = 52
END IF
CASE 8: IF ror = 1 THEN newp = 1
CASE 7: IF ror = 1 THEN newp = 2
CASE 19: IF ror = 2 THEN newp = 1
CASE 20: IF ror = 2 THEN newp = 2
CASE 33: IF ror = 1 THEN newp = 49 ELSE newp = 45
CASE 34: IF ror = 1 THEN newp = 50 ELSE newp = 46
CASE 31: IF ror = 1 THEN newp = 47 ELSE newp = 43
CASE 32: IF ror = 1 THEN newp = 48 ELSE newp = 44
END SELECT

byte$ = CHR$(newp)
PUT #1, BYTEPOSITION&, byte$
PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = newp

END SUB

SUB DrawScreen (xscreen!, yscreen!, currentscreen%(), direction, xb!, yb!)
'
'  each squares byte position goes as follows:
'  xscreen! * 16 + yscreen! * 10

'bytepositon right now is defining the upper left corner of a screen

DIM horobyte AS STRING * 16
DIM vertbyte AS STRING * 10


IF (direction / 2 <> direction \ 2 AND (xscreen! > (xscreenmax - 1) OR yscreen! > (yscreenmax - 1))) OR (((direction = up OR direction = down) AND xscreen! > (xscreenmax - 1) OR ((direction = left OR direction = right) AND yscreen! > (yscreenmax - 1 _
)))) THEN

CALL special(xscreen!, yscreen!, direction, currentscreen%(), xb!, yb!)
EXIT SUB
END IF


xfig! = xscreen!
yfig! = yscreen!
IF xscreen! > (xscreenmax - 1) AND direction <> left THEN
xfig! = (xscreen! - xscreenmax)
END IF
IF yscreen! > (yscreenmax - 1) AND direction <> up THEN
yfig! = (yscreen! - yscreenmax)
END IF
BYTEPOSITION& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax)


SELECT CASE direction
CASE downright
        FOR x = 1 TO 15
        FOR y = 1 TO 9
        currentscreen%(x, y) = currentscreen%(x + 1, y + 1)
        NEXT
        NEXT
       
        FOR x = 1 TO 16
        GET #1, BYTEPOSITION& + (x - 1) + (9) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 180), picture&(0, f), PSET
        currentscreen%(x, 10) = f
        NEXT
        FOR y = 1 TO 9
        GET #1, BYTEPOSITION& + (15) + (y - 1) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT (300, (y - 1) * 20), picture&(0, f), PSET
        currentscreen%(16, y) = f
        NEXT
CASE downleft
        FOR x = 2 TO 16
        FOR y = 1 TO 9
        currentscreen%(18 - x, y) = currentscreen%(17 - x, y + 1)
        NEXT
        NEXT
       
        FOR x = 2 TO 16
        GET #1, BYTEPOSITION& + (x - 1) + (9) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 180), picture&(0, f), PSET
        currentscreen%(x, 10) = f
        NEXT
       
        FOR y = 1 TO 10
        GET #1, BYTEPOSITION& + (0) + (y - 1) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT (0, (y - 1) * 20), picture&(0, f), PSET
        currentscreen%(1, y) = f
        NEXT
CASE upright
        FOR x = 1 TO 15
        FOR y = 2 TO 10
        currentscreen%(x, 12 - y) = currentscreen%(x + 1, 11 - y)
        NEXT
        NEXT
        FOR x = 1 TO 16
        GET #1, BYTEPOSITION& + (x - 1) + (0) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 0), picture&(0, f), PSET
        currentscreen%(x, 1) = f
        NEXT
        FOR y = 2 TO 10
        GET #1, BYTEPOSITION& + (15) + (y - 1) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT (300, (y - 1) * 20), picture&(0, f), PSET
        currentscreen%(16, y) = f
        NEXT



CASE upleft
        FOR x = 2 TO 16
        FOR y = 2 TO 10
        currentscreen%(18 - x, 12 - y) = currentscreen%(17 - x, 11 - y)
        NEXT
        NEXT
        FOR x = 2 TO 16
        GET #1, BYTEPOSITION& + (x - 1) + (0) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 0), picture&(0, f), PSET
        currentscreen%(x, 1) = f
        NEXT
        FOR y = 1 TO 10
        GET #1, BYTEPOSITION& + (0) + (y - 1) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT (0, (y - 1) * 20), picture&(0, f), PSET
        currentscreen%(1, y) = f
        NEXT


CASE up
        
        FOR x = 1 TO 16
        FOR y = 2 TO 10
        currentscreen%(x, 12 - y) = currentscreen%(x, 11 - y)
        NEXT
        NEXT
       
        GET #1, BYTEPOSITION& + 1, horobyte$
       
        FOR x = 1 TO 16
        f = ASC(MID$(horobyte$, x, 1))
        PUT ((x - 1) * 20, 0), picture&(0, f), PSET
        currentscreen%(x, 1) = f
        NEXT
CASE down
        
        FOR x = 1 TO 16
        FOR y = 1 TO 9
        currentscreen%(x, y) = currentscreen%(x, y + 1)
        NEXT
        NEXT

        FOR x = 1 TO 16
        GET #1, BYTEPOSITION& + (x - 1) + (9) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 180), picture&(0, f), PSET
        currentscreen%(x, 10) = f
        NEXT

CASE left
       
        FOR x = 2 TO 16
        FOR y = 1 TO 10
        currentscreen%(18 - x, y) = currentscreen%(17 - x, y)
        NEXT
        NEXT

       
        FOR y = 1 TO 10
        GET #1, BYTEPOSITION& + (0) + (y - 1) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT (0, (y - 1) * 20), picture&(0, f), PSET
        currentscreen%(1, y) = f
        NEXT
CASE right
        FOR x = 1 TO 15
        FOR y = 1 TO 10
        currentscreen%(x, y) = currentscreen%(x + 1, y)
        NEXT
        NEXT
       
        FOR y = 1 TO 10
        GET #1, BYTEPOSITION& + (15) + (y - 1) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        
        PUT (300, (y - 1) * 20), picture&(0, f), PSET
        currentscreen%(16, y) = f
        NEXT

CASE ELSE


FOR n = 1 TO 10
FOR m = 1 TO 16
GET #1, BYTEPOSITION& + (m - 1) + (n - 1) * (16 * xscreenmax) + 1, byte$
f = ASC(byte$)
IF f <> 0 THEN
PUT ((m - 1) * 20, (n - 1) * 20), picture&(0, f), PSET
END IF
currentscreen%(m, n) = f
NEXT m
NEXT n
END SELECT

END SUB

SUB eraseplain (zx%, zy%, BYTEPOSITION&, currentscreen())


GET #1, BYTEPOSITION& - (16 * xscreenmax) + 1, byte$: top$ = byte$
GET #1, BYTEPOSITION& + (16 * xscreenmax) + 1, byte$: bottom$ = byte$
GET #1, BYTEPOSITION&, byte$: lft$ = byte$
GET #1, BYTEPOSITION& + 2, byte$: rgt$ = byte$
top = ASC(top$)
bottom = ASC(bottom$)
lft = ASC(lft$)
rgt = ASC(rgt$)

ror = 0
IF (top > 6 AND top < 17) OR (top > 2 AND top < 7) OR (top = 17) THEN ror = 2
IF (top > 18 AND top < 25) OR (top > 24 AND top < 29) OR (top = 29) THEN ror = 1

IF top = 46 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = top: CALL getattributes(piece, x1, x2, y1, y2)
     y2 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 34
     END IF
     IF newp <> top THEN
          byte$ = CHR$(newp)
          PUT #1, BYTEPOSITION& - (16 * xscreenmax) + 1, byte$
          n = ((zy% \ 20) - 1)
       
          IF n >= 0 THEN
               PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
               currentscreen%(zx% \ 20 + 1, n + 1) = newp
          END IF
     END IF
END IF
ror = 0

IF (bottom > 6 AND bottom < 17) OR (bottom > 2 AND bottom < 7) OR (bottom = 17) THEN ror = 2
IF (bottom > 18 AND bottom < 25) OR (bottom > 24 AND bottom < 29) OR (bottom = 29) THEN ror = 1

IF bottom = 45 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = bottom: CALL getattributes(piece, x1, x2, y1, y2)
     y1 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 33
     END IF
     IF newp <> bottom THEN
          byte$ = CHR$(newp)
          PUT #1, BYTEPOSITION& + (16 * xscreenmax) + 1, byte$
          n = ((zy% \ 20) + 1)
        
          IF n < 10 THEN
               PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
               currentscreen%(zx% \ 20 + 1, n + 1) = newp
          END IF
     END IF
END IF

ror = 0
IF (lft > 6 AND lft < 17) OR (lft > 2 AND lft < 7) OR (lft = 17) THEN ror = 2
IF (lft > 18 AND lft < 25) OR (lft > 24 AND lft < 29) OR (lft = 29) THEN ror = 1
IF lft = 44 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = lft: CALL getattributes(piece, x1, x2, y1, y2)
     x2 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 32
     END IF
     IF newp <> lft THEN
          byte$ = CHR$(newp)
          PUT #1, BYTEPOSITION&, byte$

          n = ((zx% \ 20) - 1)
          IF n >= 0 THEN
               PUT (n * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
               currentscreen%(n + 1, zy% \ 20 + 1) = newp
          END IF
     END IF
END IF

ror = 0
IF (rgt > 6 AND rgt < 17) OR (rgt > 2 AND rgt < 7) OR (rgt = 17) THEN ror = 2
IF (rgt > 18 AND rgt < 25) OR (rgt > 24 AND rgt < 29) OR (rgt = 29) THEN ror = 1
IF rgt = 43 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = rgt: CALL getattributes(piece, x1, x2, y1, y2)
     x1 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 31
     END IF
     IF newp <> rgt THEN
          byte$ = CHR$(newp)
          PUT #1, BYTEPOSITION& + 2, byte$

          n = ((zx% \ 20) + 1)
          IF n < 16 THEN
               PUT (n * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
               currentscreen%(n + 1, zy% \ 20 + 1) = newp
          END IF
     END IF
END IF

IF top = 70 OR top = 69 THEN
IF top = 70 THEN newp = 71
IF top = 69 THEN newp = 72
          byte$ = CHR$(newp)
          PUT #1, BYTEPOSITION& - (16 * xscreenmax) + 1, byte$
          n = ((zy% \ 20) - 1)
      
          IF n >= 0 THEN
               PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
               currentscreen%(zx% \ 20 + 1, n + 1) = newp
          END IF
END IF
IF bottom = 70 OR bottom = 71 THEN
IF bottom = 70 THEN newp = 69
IF bottom = 71 THEN newp = 72
          byte$ = CHR$(newp)
          PUT #1, BYTEPOSITION& + (16 * xscreenmax) + 1, byte$
          n = ((zy% \ 20) + 1)
     
          IF n < 10 THEN
               PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
               currentscreen%(zx% \ 20 + 1, n + 1) = newp
          END IF
END IF



END SUB

SUB forestdraw (zx%, zy%, currentscreen%(), xscreen!, yscreen!)
yfig! = yscreen! + (zy% \ 20) / 10
xfig! = xscreen! + (zx% \ 20) / 16
IF xscreen! + (zx% \ 20) / 16 >= xscreenmax THEN xfig! = xscreen! + (zx% \ 20) / 16 - xscreenmax
IF yscreen! + (zy% \ 20) / 10 >= yscreenmax THEN yfig! = yscreen! + (zy% \ 20) / 10 - yscreenmax
j1 = no: j2 = no
BYTEPOSITION& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax) + 1

GET #1, BYTEPOSITION& - 768, byte$
piece = ASC(byte$)
IF (piece > 68 AND piece < 73) THEN
            j1 = yes
            newp = 0
            IF piece = 71 THEN newp = 70
            IF piece = 72 THEN newp = 69
                                                          
            IF newp <> 0 THEN
                        byte$ = CHR$(newp)
                        PUT #1, BYTEPOSITION& - 768, byte$
                                                          
                        n = ((zy% \ 20) - 1)
                        IF n >= 0 THEN
                        PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
                        currentscreen%(zx% \ 20 + 1, n + 1) = newp
                        END IF
                                              
            END IF
END IF
                                  
GET #1, BYTEPOSITION& + 768, byte$
piece = ASC(byte$)
IF (piece > 68 AND piece < 73) THEN
            j2 = yes
            newp = 0
            IF piece = 69 THEN newp = 70
            IF piece = 72 THEN newp = 71
                                                         
            IF newp <> 0 THEN
                        byte$ = CHR$(newp)
                        PUT #1, BYTEPOSITION& + 768, byte$
                                                         
                        n = ((zy% \ 20) + 1)
                        IF n < 10 THEN
                        PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
                        currentscreen%(zx% \ 20 + 1, n + 1) = newp
                        END IF
                                             
            END IF
END IF

newp = 0
IF j1 = no AND j2 = yes THEN newp = 69
IF j1 = yes AND j2 = yes THEN newp = 70
IF j1 = yes AND j2 = no THEN newp = 71
IF j1 = no AND j2 = no THEN newp = 72
byte$ = CHR$(newp)
PUT #1, BYTEPOSITION&, byte$

PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = newp


END SUB

SUB getattributes (piece, x1, x2, y1, y2)

SELECT CASE piece
CASE 29, 17, 1, 2: v = 1
CASE 26, 14: v = 2
CASE 28, 16: v = 3
CASE 20, 8: v = 4
CASE 25, 13: v = 5
CASE 22, 20: v = 6
CASE 21, 9: v = 7
CASE 6: v = 8
CASE 27, 15: v = 9
CASE 24, 12: v = 10
CASE 23, 11: v = 11
CASE 5: v = 12
CASE 19, 7: v = 13
CASE 3: v = 14
CASE 4: v = 15
CASE 30, 18: v = 16
END SELECT
x1 = no: x2 = no: y1 = no: y2 = no

SELECT CASE v
CASE 1: x1 = yes: x2 = yes: y1 = yes: y2 = yes
CASE 2: x1 = yes: x2 = yes: y1 = yes
CASE 3: x1 = yes: x2 = yes: y2 = yes
CASE 4: x1 = yes: x2 = yes
CASE 5: x1 = yes: y1 = yes: y2 = yes
CASE 6: x1 = yes: y1 = yes
CASE 7: x1 = yes: y2 = yes
CASE 8: x1 = yes
CASE 9:  x2 = yes: y1 = yes: y2 = yes
CASE 10: x2 = yes: y1 = yes
CASE 11: x2 = yes: y2 = yes
CASE 12: x2 = yes
CASE 13: y1 = yes: y2 = yes
CASE 14: y2 = yes
CASE 15: y1 = yes
CASE 16:
END SELECT


END SUB

SUB joyinit
LOCATE 10, 5: PRINT "Move Joystick to the topleft and press button 1"
DO

IF STRIG(1) = yes THEN

xjmin = STICK(0): yjmin = STICK(1): EXIT DO
END IF
LOOP
LOCATE 10, 5: PRINT "Move Joystick to the bottomright and press button 2"
DO
IF STRIG(5) = yes THEN

xjmax = STICK(0): yjmax = STICK(1): EXIT DO
END IF
LOOP

END SUB

SUB joystatus (x, y, choice$)
x = STICK(0): y = STICK(1)

IF (x - xjmin) / xjmax < .3 THEN
xd = -1
ELSEIF (x - xjmin) / xjmax > .7 THEN
xd = 1
END IF

IF (y - yjmin) / yjmax < .3 THEN
yd = -1
ELSEIF (y - yjmin) / yjmax > .7 THEN
yd = 1
END IF


SELECT CASE xd
CASE -1
     SELECT CASE yd
     CASE -1: choice$ = "7"
     CASE 0: choice$ = "4"
     CASE 1: choice$ = "1"
     END SELECT
CASE 0
     SELECT CASE yd
     CASE -1: choice$ = "8"
     CASE 0
     CASE 1: choice$ = "2"
     END SELECT
CASE 1
SELECT CASE yd
     CASE -1: choice$ = "9"
     CASE 0: choice$ = "6"
     CASE 1: choice$ = "3"
     END SELECT
END SELECT
END SUB

SUB junk
IF (rgt > 6 AND rgt < 17) OR (rgt > 2 AND rgt < 7) OR (rgt = 17) THEN ror = 2
IF (rgt > 18 AND rgt < 25) OR (rgt > 24 AND rgt < 29) OR (rgt = 29) THEN ror = 1

END SUB

DEFSNG A-Z
SUB loadpics (filename$())

num = 1
FOR f = 1 TO plds

IF f = 107 THEN f = 128

LOCATE 2, 1: PRINT "Opening "; filename$(f); "     "
LOCATE 3, 1: PRINT USING "###%"; CINT(f / plds * 100)
OPEN filename$(f) FOR BINARY AS num
FOR i = 0 TO 101
GET #num, , number&
picture&(i, f) = number&
NEXT
CLOSE num
NEXT

END SUB

SUB mountainfix (xscreen, yscreen, currentscreen%())
mousehide

FOR i = 1 TO 16

FOR j = 1 TO 10
IF (currentscreen%(i, j) > 52 AND currentscreen%(i, j) < 69) THEN
       
        t = no: b = no: l = no: r = no
       
        IF j = 1 THEN
                    yfi! = yscreen! + (j - 2) / 10: xfi! = xscreen! + (i - 1) / 16
                    IF xscreen! + (i - 1) / 16 >= xscreenmax THEN xfi! = xscreen! + (i - 1) / 16 - xscreenmax
                    IF yscreen! + (j - 1) / 10 >= yscreenmax THEN yfi! = yscreen! + (j - 1) / 10 - yscreenmax
                    IF yfi! < 0 THEN yfi! = yscreenmax - (1 / 10)
                    IF xfi! < 0 THEN xfi! = xscreenmax - (1 / 16)
                    bytepos& = xfi! * 16 + (yfi! * 10) * (16 * xscreenmax) + 1
                    GET #1, bytepos&, byte$: t = ASC(byte$)
        ELSE
        t = currentscreen%(i, j - 1)
        END IF

        IF j = 10 THEN
                    yfi! = yscreen! + (j) / 10: xfi! = xscreen! + (i - 1) / 16
                    IF xscreen! + (i - 1) / 16 >= xscreenmax THEN xfi! = xscreen! + (i - 1) / 16 - xscreenmax
                    IF yscreen! + (j - 1) / 10 >= yscreenmax THEN yfi! = yscreen! + (j - 1) / 10 - yscreenmax
                    IF yfi! < 0 THEN yfi! = yscreenmax - (1 / 10)
                    IF xfi! < 0 THEN xfi! = xscreenmax - (1 / 16)
                    bytepos& = xfi! * 16 + (yfi! * 10) * (16 * xscreenmax) + 1
                    GET #1, bytepos&, byte$: b = ASC(byte$)
        ELSE
        b = currentscreen%(i, j + 1)
        END IF

        IF i = 1 THEN
                    yfi! = yscreen! + (j - 1) / 10: xfi! = xscreen! + (i - 2) / 16
                    IF xscreen! + (i - 1) / 16 >= xscreenmax THEN xfi! = xscreen! + (i - 1) / 16 - xscreenmax
                    IF yscreen! + (j - 1) / 10 >= yscreenmax THEN yfi! = yscreen! + (j - 1) / 10 - yscreenmax
                    IF yfi! < 0 THEN yfi! = yscreenmax - (1 / 10)
                    IF xfi! < 0 THEN xfi! = xscreenmax - (1 / 16)
                    bytepos& = xfi! * 16 + (yfi! * 10) * (16 * xscreenmax) + 1
                    GET #1, bytepos&, byte$: l = ASC(byte$)
        ELSE
        l = currentscreen%(i - 1, j)
        END IF

        IF i = 16 THEN
                    yfi! = yscreen! + (j - 1) / 10: xfi! = xscreen! + (i) / 16
                    IF xscreen! + (i - 1) / 16 >= xscreenmax THEN xfi! = xscreen! + (i - 1) / 16 - xscreenmax
                    IF yscreen! + (j - 1) / 10 >= yscreenmax THEN yfi! = yscreen! + (j - 1) / 10 - yscreenmax
                    IF yfi! < 0 THEN yfi! = yscreenmax - (1 / 10)
                    IF xfi! < 0 THEN xfi! = xscreenmax - (1 / 16)
                    bytepos& = xfi! * 16 + (yfi! * 10) * (16 * xscreenmax) + 1
                    GET #1, bytepos&, byte$: r = ASC(byte$)
        ELSE
        r = currentscreen%(i + 1, j)
        END IF
       
        IF (t > 52 AND t < 69) THEN
        t = yes
        ELSE
        t = no
        END IF
        IF (b > 52 AND b < 69) OR (b > 131 AND b < 134) THEN
        b = yes
        ELSE
        b = no
        END IF
        IF (l > 52 AND l < 69) OR (l = 133) THEN
        l = yes
        ELSE
        l = no
        END IF
        IF (r > 52 AND r < 69) OR (r = 133) THEN
        r = yes
        ELSE
        r = no
        END IF

        IF t = yes AND b = no THEN
                IF l = yes AND r = no THEN kind = 54
                IF r = yes AND l = no THEN kind = 55
                IF l = no AND r = no THEN kind = 63
                IF l = yes AND r = yes THEN kind = 65
        END IF

        IF b = yes AND t = no THEN
                IF l = no AND r = yes THEN kind = 56
                IF r = no AND l = yes THEN kind = 57
                IF l = no AND r = no THEN kind = 61
                IF l = yes AND r = yes THEN kind = 67
        END IF

        IF b = yes AND t = yes THEN
                IF l = yes AND r = yes THEN kind = 53
                IF r = no AND l = no THEN kind = 58
                IF l = yes AND r = no THEN kind = 64
                IF r = yes AND l = no THEN kind = 66
        END IF

        IF b = no AND t = no THEN
                IF l = yes AND r = yes THEN kind = 59
                IF l = yes AND r = no THEN kind = 60
                IF l = no AND r = yes THEN kind = 62
                IF l = no AND r = no THEN kind = 68
        END IF

        byte$ = CHR$(kind)
        BYTEPOSITION& = xscreen * 16 + (yscreen * 10) * (16 * xscreenmax)
        PUT #1, BYTEPOSITION& + (i - 1) + (j - 1) * (16 * xscreenmax) + 1, byte$

        PUT ((i - 1) * 20, (j - 1) * 20), picture&(0, kind), PSET
        currentscreen%(i, j) = kind

END IF
NEXT
NEXT

mouseshow
END SUB

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

SUB Mouserange (x1%, y1%, x2%, y2%)
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
  zx% = cx% \ 2
  zy% = dx%

END SUB

DEFINT A-Z
SUB openpalette (pal&(), currentpalette)
        FOR i = 1 TO 6
        num = FREEFILE
        SELECT CASE i
        CASE 1: f$ = "WINTER.PAL"
        CASE 2: f$ = "SPRING1.PAL"
        CASE 3: f$ = "SPRING2.PAL"
        CASE 4: f$ = "SUMMER.PAL"
        CASE 5: f$ = "FALL1.PAL"
        CASE 6: f$ = "FALL2.PAL"
        END SELECT
        OPEN f$ FOR BINARY AS num ' Open the file
                FOR index = 0 TO 255             ' Load each RGB value ( write me for tech info )
                  
                    GET #num, , byte: red = ASC(byte)
                    GET #num, , byte: green = ASC(byte)
                    GET #num, , byte: blue = ASC(byte)
                  
                    pal&(index, i) = red + green * &H100 + blue * &H10000
                  
                NEXT
                    'pal&(index, i) = 65536 * 63 + 256 * 63 + 63
             
                CLOSE #num
               
    NEXT

END SUB

DEFSNG A-Z
FUNCTION round (DP, number!)
IF INT(number! * 10 ^ DP) >= INT(number! * 10 ^ (DP - 1)) * 10 + 5 THEN
round = (INT(number! * 10 ^ (DP - 1) + 1)) / (10 ^ (DP - 1))
ELSE
round = (INT(number! * 10 ^ (DP - 1))) / (10 ^ (DP - 1))
END IF
END FUNCTION

DEFINT A-Z
SUB selectroadriver (x1, x2, y1, y2, ror, newp)


IF x1 = yes AND x2 = yes AND y1 = yes AND y2 = yes THEN v = 1 ' 1
IF x1 = yes AND x2 = yes AND y1 = yes AND y2 = no THEN v = 2 ' 2
IF x1 = yes AND x2 = yes AND y1 = no AND y2 = yes THEN v = 3 ' 3
IF x1 = yes AND x2 = yes AND y1 = no AND y2 = no THEN v = 4 ' 4
IF x1 = yes AND x2 = no AND y1 = yes AND y2 = yes THEN v = 5 ' 5
IF x1 = yes AND x2 = no AND y1 = yes AND y2 = no THEN v = 6 ' 6
IF x1 = yes AND x2 = no AND y1 = no AND y2 = yes THEN v = 7 ' 7
IF x1 = yes AND x2 = no AND y1 = no AND y2 = no THEN v = 8 ' 8
IF x1 = no AND x2 = yes AND y1 = yes AND y2 = yes THEN v = 9 ' 1
IF x1 = no AND x2 = yes AND y1 = yes AND y2 = no THEN v = 10 ' 2
IF x1 = no AND x2 = yes AND y1 = no AND y2 = yes THEN v = 11 ' 3
IF x1 = no AND x2 = yes AND y1 = no AND y2 = no THEN v = 12 ' 4
IF x1 = no AND x2 = no AND y1 = yes AND y2 = yes THEN v = 13 ' 5
IF x1 = no AND x2 = no AND y1 = yes AND y2 = no THEN v = 14 ' 6
IF x1 = no AND x2 = no AND y1 = no AND y2 = yes THEN v = 15 ' 7
IF x1 = no AND x2 = no AND y1 = no AND y2 = no THEN v = 16 ' 8
SELECT CASE ror
CASE 1
SELECT CASE v
CASE 1: newp = 29
CASE 2: newp = 26
CASE 3: newp = 28
CASE 4: newp = 20
CASE 5: newp = 25
CASE 6: newp = 22
CASE 7: newp = 21
CASE 8: newp = 20
CASE 9: newp = 27
CASE 10: newp = 24
CASE 11: newp = 23
CASE 12: newp = 20
CASE 13: newp = 19
CASE 14: newp = 19
CASE 15: newp = 19
CASE 16: newp = 30
END SELECT
CASE 2
SELECT CASE v
CASE 1: newp = 17
CASE 2: newp = 14
CASE 3: newp = 16
CASE 4: newp = 8
CASE 5: newp = 13
CASE 6: newp = 10
CASE 7: newp = 9
CASE 8: newp = 6
CASE 9: newp = 15
CASE 10: newp = 12
CASE 11: newp = 11
CASE 12: newp = 5
CASE 13: newp = 7
CASE 14: newp = 4
CASE 15: newp = 3
CASE 16: newp = 18
END SELECT
END SELECT
END SUB

SUB setpieces (kind, xattrib, yattrib)
xattrib = 0: yattrib = 0
SELECT CASE kind
CASE 33: yattrib = 1
CASE 34: yattrib = 2
CASE 31: xattrib = 1
CASE 32: xattrib = 2
CASE 38: xattrib = 2: yattrib = 2
CASE 42: xattrib = 1: yattrib = 2
CASE 40: xattrib = 1: yattrib = 1
CASE 36: xattrib = 2: yattrib = 1
CASE 37: xattrib = 1: yattrib = 1
CASE 35: xattrib = 1: yattrib = 2
CASE 39: xattrib = 2: yattrib = 2
CASE 41: xattrib = 2: yattrib = 1
END SELECT
END SUB

SUB SHORElinedraw (kind, xscreen!, yscreen!, pieces(), xattrib, yattrib, currentscreen())
xdir1 = pieces(1, 1) - pieces(2, 1)
ydir1 = pieces(1, 2) - pieces(2, 2)

xdir2 = pieces(3, 1) - pieces(2, 1)
ydir2 = pieces(3, 2) - pieces(2, 2)

vert = 2
SELECT CASE ABS(xdir1 - xdir2)
CASE 0'goes straight up
            SELECT CASE xattrib
            CASE 1: kind = 31
            CASE 2: kind = 32
            END SELECT
CASE 1'goes across and up
           
            IF xdir2 = 0 THEN
            SWAP xdir1, xdir2
            dir = vert
            END IF
            SELECT CASE xdir2
            CASE -1
                        IF ydir1 = 0 THEN
                        SWAP ydir1, ydir2
                        END IF
                        SELECT CASE ydir1
                        CASE -1
                                   
                                    IF (xdir2 = -1 AND yattrib = 2 AND (xattrib <> 1 OR dir = 2)) OR (ydir1 = -1 AND xattrib = 2 AND (yattrib <> 1 OR dir = 0)) THEN
                                    kind = 38
                                    ELSE
                                    kind = 37
                                    END IF
                        CASE 1
                                   
                                    IF (ydir1 = 1 AND xattrib = 2 AND (yattrib <> 2 OR dir = 0)) OR (xdir2 = -1 AND yattrib = 1 AND (xattrib <> 1 OR dir = 2)) THEN
                                    kind = 36
                                    ELSE
                                    kind = 35
                                    END IF
                        END SELECT
            CASE 1
                        IF ydir1 = 0 THEN
                        SWAP ydir1, ydir2
                        END IF
                        SELECT CASE ydir1
                        CASE -1
                                   
                                    IF (ydir1 = -1 AND xattrib = 1 AND (yattrib <> 1 OR dir = 0)) OR (xdir2 = 1 AND (yattrib = 2) AND (xattrib <> 2 OR dir = 2)) THEN
                                    kind = 42
                                    ELSE
                                    kind = 41
                                    END IF
                        CASE 1
                                   
                                    IF (ydir1 = 1 AND xattrib = 1 AND (yattrib <> 2 OR dir = 0)) OR (xdir2 = 1 AND yattrib = 1 AND (xattrib <> 2 OR dir = 2)) THEN
                                    kind = 40
                                    ELSE
                                    kind = 39
                                    END IF
                        END SELECT
            END SELECT
                                   
CASE 2'goes straight across
            SELECT CASE yattrib
            CASE 1: kind = 33
            CASE 2: kind = 34
            END SELECT
END SELECT
IF kind <> 0 THEN
CALL setpieces(kind, xattrib, yattrib)
currentscreen(pieces(2, 1), pieces(2, 2)) = kind
PUT ((pieces(2, 1) - 1) * 20, (pieces(2, 2) - 1) * 20), picture&(0, kind), PSET
BYTEPOSITION& = xscreen! * 16 + yscreen! * 10 * 16 * xscreenmax
b$ = CHR$(kind)
PUT #1, BYTEPOSITION& + pieces(2, 1) - 1 + (pieces(2, 2) - 1) * 16 * xscreenmax + 1, b$
END IF
END SUB

DEFSNG A-Z
SUB showarea (xscreen!, yscreen!)
startx = (xscreen! - 4.5) * 16
starty = (yscreen! - 4.5) * 10
DIM across AS STRING * 160
DIM lin(161) AS LONG

DIM box(1) AS LONG
mousehide
CLS
GET (0, 0)-(319, 1), lin&(0)



lin&(0) = 133632


a! = TIMER

FOR i = 0 TO 99
BYTEPOSITION& = startx + (starty + i) * 768
GET #1, BYTEPOSITION&, across

FOR j = 1 TO 160
s = ASC(MID$(across, j, 1))
'lin&(j) = smallpics&(1, s)
PUT ((j - 1) * 2, i * 2), smallpics&(0, s), PSET

NEXT

'PUT (0, (i * 2)), lin&(0), PSET

NEXT i
b! = TIMER
'PRINT b! - a!



END SUB

DEFINT A-Z
SUB special (xscreen!, yscreen!, direction%, currentscreen%(), xb!, yb!)
  ' with downleft at the screen above 1,1, make note of yfig!
DIM r AS SINGLE
DIM C AS SINGLE

xfig! = xscreen!
yfig! = yscreen!
IF xscreen! > (xscreenmax - 1) AND direction / 3 = direction \ 3 THEN
xfig! = (xscreen! - (xscreenmax - 1))
END IF
IF yscreen! > (yscreenmax - 1) AND direction < 4 THEN
yfig! = (yscreen! - (yscreenmax - 1))
number! = yfig!: yfig! = round(DP, number!)
END IF

row1& = no: column1& = no
'X Axis part

IF direction / 3 = direction \ 3 THEN 'has right in it
            column = 16
            cstart = 1
            C = (yscreen! - yb!) / 2
           
            IF ABS(C) > 2 THEN C = (yscreen! - (yb! + yscreenmax)) / 2
            number! = C: C = round(3, number!)
            xv! = xscreen! + .9375: IF xv! >= xscreenmax THEN xv! = xv! - xscreenmax
            column1& = (xv!) * 16 + ((yb! + C + .05) * 10) * (16 * xscreenmax)
            IF (yb! + C + .05) > (yscreenmax - .9) THEN
                        cplace = (yscreenmax - yscreen!) * 10 + 1
                        number! = cplace: cplace = round(DP, number!)
                        column2& = (xv!) * 16 + ((0) * 10) * (16 * xscreenmax)
            END IF
ELSEIF INT((direction - 1) / 3) = ((direction - 1) / 3) THEN ' has left in it
            column = 1
            cstart = 2
            C = (yscreen! - yb!) / 2
            IF ABS(C) > 2 THEN C = (yscreen! - (yb! + yscreenmax)) / 2
            
            column1& = (xfig!) * 16 + ((yb! + C + .05) * 10) * (16 * xscreenmax)
            IF (yb! + C + .05) > (yscreenmax - .9) THEN   '??????????????????
                        cplace = (yscreenmax - yscreen!) * 10 + 1
                        number! = cplace: cplace = round(DP, number!)
                        column2& = (xfig!) * 16
            END IF
END IF
'Y Axis part

IF direction < 4 THEN ' has down in it
            row = 10
            rstart = 1
            r = (xscreen! - xb!) / 2
            IF ABS(r) > 2 THEN r = (xscreen! - (xb! + xscreenmax)) / 2
            yv! = yscreen! + .9: IF yv! >= yscreenmax THEN yv! = yv! - yscreenmax
                ' very important that that value is yscreen, not yfig!
                '***************************************************
            row1& = (xb! + r + .03125) * 16 + ((yv!) * 10) * (16 * xscreenmax)
            IF (xb! + r + .03125) > (xscreenmax - .9375) THEN
                        rplace = (xscreenmax - xscreen!) * 16 + 1
                        row2& = ((yv!) * 10) * (16 * xscreenmax)
            END IF
ELSEIF direction > 6 THEN ' has up in it
            row = 1
            rstart = 2
            r = (xscreen! - xb!) / 2
            IF ABS(r) > 2 THEN r = (xscreen! - (xb! + xscreenmax)) / 2
           
            row1& = (xb! + r + .03125) * 16 + ((yscreen!) * 10) * (16 * xscreenmax)
            IF (xb! + r + .03125) > (xscreenmax - .9375) THEN
                        rplace = (xscreenmax - xscreen!) * 16 + 1
                        row2& = ((yscreen!) * 10) * (16 * xscreenmax)
            END IF
END IF

IF row = 0 THEN row = 1: rstart = 2
IF column = 0 THEN column = 1: cstart = 2

xv! = (xscreen! + (column - 1) / 16): IF xv! >= xscreenmax THEN xv! = xv! - xscreenmax
IF xv! < 0 THEN xv! = xv! + xscreenmax
yv! = (yscreen! + (row - 1) / 10): number! = yv!: yv! = round(DP, number!)
IF yv! >= yscreenmax THEN yv! = yv! - yscreenmax
IF yv! < 0 THEN yv! = yv! + yscreenmax
corner& = xv! * 16 + yv! * 10 * (16 * xscreenmax)


SELECT CASE direction
CASE downright: FOR x = 1 TO 15: FOR y = 1 TO 9: currentscreen%(x, y) = currentscreen%(x + 1, y + 1): NEXT: NEXT
CASE downleft: FOR x = 2 TO 16: FOR y = 1 TO 9: currentscreen%(18 - x, y) = currentscreen%(17 - x, y + 1): NEXT: NEXT
CASE upright: FOR x = 1 TO 15: FOR y = 2 TO 10: currentscreen%(x, 12 - y) = currentscreen%(x + 1, 11 - y): NEXT: NEXT
CASE upleft: FOR x = 2 TO 16: FOR y = 2 TO 10: currentscreen%(18 - x, 12 - y) = currentscreen%(17 - x, 11 - y): NEXT: NEXT
END SELECT

GET #1, corner& + 1, byte$
f = ASC(byte$)
PUT ((column - 1) * 20, (row - 1) * 20), picture&(0, f), PSET

IF row1& <> no THEN
xbyte& = row1&

FOR x = cstart TO cstart + 14
n = n + 1
IF x = rplace THEN
xbyte& = row2&
n = 1
END IF

GET #1, xbyte& + n, byte$
f = ASC(byte$)
PUT ((x - 1) * 20, (row - 1) * 20), picture&(0, f), PSET
currentscreen%(x, row) = f

NEXT
END IF

IF column1& <> no THEN
n = 0
ybyte& = column1&
FOR y = rstart TO rstart + 8
n = n + 1

IF y = cplace THEN

ybyte& = column2&
n = 1
END IF

GET #1, ybyte& + ((n - 1) * (16 * xscreenmax)) + 1, byte$
f = ASC(byte$)
PUT ((column - 1) * 20, (y - 1) * 20), picture&(0, f), PSET
currentscreen%(column, y) = f

NEXT
END IF


END SUB

