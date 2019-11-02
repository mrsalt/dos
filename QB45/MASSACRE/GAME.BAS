DECLARE SUB joyinit ()
DECLARE SUB joystatus (x%, y%, choice$)
DECLARE SUB eraseplain (zx%, zy%, byteposition&, currentscreen%())
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
CONST plds = 121' number of pld files
CONST downleft = 1, downright = 3, upright = 9, upleft = 7
CONST up = 8, down = 2, left = 4, right = 6
CONST yes = -1, no = 1
CONST DP% = 2 ' for decimal place, used in the rounding function
CONST mapfound$ = "worldmap.dat"
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
mouse$ = SPACE$(57)
FOR i% = 1 TO 57
  READ A$
  h$ = CHR$(VAL("&H" + A$))
  MID$(mouse$, i%, 1) = h$

NEXT i%
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
    PALETTE USING pal&(0, 1)                      ' Change the palette to the first one
                 'starting with first color, the first palette
    currentpalette = 1
LOCATE 1, 1: PRINT "Opening pictures...";
RESTORE NAMES
FOR i = 1 TO plds
READ k$
filename$(i) = k$
NEXT i
CALL loadpics(filename$())
OPEN mapfound$ FOR BINARY ACCESS READ WRITE AS #1
CLS
CALL DrawScreen(xscreen, yscreen, currentscreen%(), direction, xb!, yb!)
   ' turn numlock off
   DEF SEG = 0
   POKE (1047), 32
   DEF SEG


A! = TIMER

mouseshow
DIM box(3000) AS LONG
squaretype = 56
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
           
            LOOP WHILE choice$ = "" AND zx% = q AND zy% = w AND (leftcheck = lb% AND (squaretype = 26 OR squaretype = 27) AND squaretype = os) AND rb% = NOT yes
       
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
                   
                    IF ((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%) AND squaretype > 43 AND squaretype < 56 AND check <> 0 AND (pieces(3, 1) <> (zx% \ 20 + 1) OR pieces(3, 2) <> (zy% \ 20 + 1)) THEN  'SHOREpiece
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
                               
                                IF (squaretype = 68) THEN
                                           
                                            mousehide
                                            CALL caves(zx%, zy%, currentscreen%(), xscreen!, yscreen!)
                                            CALL mountainfix(xscreen, yscreen, currentscreen%())
                                            ox% = (zx% \ 20): oy% = (zy% \ 20)
                                            mouseshow
                                END IF
                               
                                IF (((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%) OR os <> 59) AND (squaretype = 59) THEN
                                            mousehide
                                            CALL forestdraw(zx%, zy%, currentscreen%(), xscreen!, yscreen!)
                                            ox% = (zx% \ 20): oy% = (zy% \ 20)
                                            os = 59
                                            mouseshow
                                END IF
                               
                                IF (squaretype = 115 OR squaretype = 116) AND (((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%) OR lastaction = 0) THEN
                                'reassign the four pieces around, then change the one in the middle
                                mousehide
                                CALL DrawRivAndRoads(squaretype, xscreen!, yscreen!, zx%, zy%, currentscreen%())
                                ox% = (zx% \ 20): oy% = (zy% \ 20)
                                mouseshow
                                lastaction = 1
                                ELSEIF ((((zx% \ 20) <> ox% OR (zy% \ 20) <> oy%)) OR (squaretype <> os OR rb% = -1)) AND (squaretype <> 115 AND squaretype <> 116) THEN
                                           
                                            mousehide
                                            
                                            yfig! = yscreen + (zy% \ 20) / 10
                                            xfig! = xscreen + (zx% \ 20) / 16
                                            IF xscreen + (zx% \ 20) / 16 >= xscreenmax THEN xfig! = xscreen + (zx% \ 20) / 16 - xscreenmax
                                            IF yscreen + (zy% \ 20) / 10 >= yscreenmax THEN yfig! = yscreen + (zy% \ 20) / 10 - yscreenmax
                                            byteposition& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax)
                                            currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = squaretype
                                            byte$ = CHR$(squaretype)
                                            PUT #1, byteposition& + 1, byte$
                                            PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, squaretype), PSET
                                            ox% = (zx% \ 20): oy% = (zy% \ 20)
                                            os = squaretype
                                            IF erse = yes THEN CALL eraseplain(zx%, zy%, byteposition&, currentscreen())

                                            IF (squaretype = 26 OR (squaretype > 116 AND squaretype < 121) OR squaretype = 118 OR squaretype = 27) AND rb% = yes AND holddown = yes THEN
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
                                                                    byteposition& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax)
                                                                    byte$ = CHR$(squaretype)
                                                                    PUT #1, byteposition& + 1, byte$
                                                                    PUT ((i - 1) * 20, (j - 1) * 20), picture&(0, squaretype), PSET
                                                        NEXT
                                                        NEXT
                                            
                                            END IF
                                            mouseshow
                                lastaction = 0
                                END IF
                    END IF
       
                    IF check = 0 AND squaretype > 43 AND squaretype < 56 AND (pieces(f, 1) <> zx% \ 20 + 1 OR pieces(f, 2) <> zy% \ 20 + 1) THEN 'if check = 1 then the mouse is being dragged
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
                        CASE "s"
                             currentpalette = currentpalette + 1
                             IF currentpalette > pals THEN currentpalette = 1
                             PALETTE USING pal&(0, currentpalette)
                        CASE "c": squaretype = 68: erse = no
                        CASE "h": squaretype = 21: erse = no
                        CASE "r": squaretype = 115: erse = no
                        CASE "R": squaretype = 116: erse = no
                        CASE "f": squaretype = 59: erse = no
                        CASE "p": squaretype = 27: erse = no
                        CASE "o": squaretype = 26: erse = no
                        CASE "e": squaretype = 27: erse = yes
                        CASE "t": squaretype = 57: erse = no
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
DATA "BRIDGE2.PLD"
DATA "FOREST1.PLD"
DATA "FOREST2.PLD"
DATA "FOREST3.PLD"
DATA "MOUNTAN1.PLD"
DATA "MOUNTAN2.PLD"
DATA "MOUNTAN3.PLD"
DATA "MOUNTAN4.PLD"
DATA "MOUNTAN5.PLD"
DATA "MOUNTAN6.PLD"
DATA "MOUNTAN7.PLD"
DATA "MOUNTAN8.PLD"
DATA "MOUNTAN9.PLD"
DATA "MOUNTA10.PLD"
DATA "MOUNTA11.PLD"
DATA "MOUNTA12.PLD"
DATA "MOUNTA13.PLD"
DATA "MOUNTA14.PLD"
DATA "MOUNTA15.PLD"
DATA "MOUNTA16.PLD"
DATA "MOUTH1.PLD"
DATA "MOUTH2.PLD"
DATA "MOUTH3.PLD"
DATA "MOUTH4.PLD"
DATA "OCEAN1.PLD"
DATA "PLAINS1.PLD"
DATA "RIVER1.PLD"
DATA "RIVER2.PLD"
DATA "RIVER3.PLD"
DATA "RIVER4.PLD"
DATA "RIVER5.PLD"
DATA "RIVER6.PLD"
DATA "RIVJOIN1.PLD"
DATA "RIVJOIN2.PLD"
DATA "RIVJOIN3.PLD"
DATA "RIVJOIN4.PLD"
DATA "ROAD1.PLD"
DATA "ROAD2.PLD"
DATA "ROAD3.PLD"
DATA "ROAD4.PLD"
DATA "ROAD5.PLD"
DATA "ROAD6.PLD"
DATA "SHORE1.PLD"
DATA "SHORE2.PLD"
DATA "SHORE3.PLD"
DATA "SHORE4.PLD"
DATA "SHORE5.PLD"
DATA "SHORE6.PLD"
DATA "SHORE7.PLD"
DATA "SHORE8.PLD"
DATA "SHORE9.PLD"
DATA "SHORE10.PLD"
DATA "SHORE11.PLD"
DATA "SHORE12.PLD"
DATA "TREES1.PLD"
DATA "TREES2.PLD"
DATA "HUT1.PLD"
DATA "FOREST4.PLD"
DATA "RIVBEGN1.PLD"
DATA "RIVBEGN2.PLD"
DATA "RIVBEGN3.PLD"
DATA "RIVBEGN4.PLD"
DATA "RODJOIN1.PLD"
DATA "RODJOIN2.PLD"
DATA "RODJOIN3.PLD"
DATA "RODJOIN4.PLD"
DATA "CAVE1.PLD"
DATA "CAVE2.PLD"
DATA "CAVE3.PLD"
DATA "HARBOR1.PLD"
DATA "HARBOR2.PLD"
DATA "HARBOR3.PLD"
DATA "DESERT1.PLD"
DATA "DESERT2.PLD"
DATA "DESERT3.PLD"
DATA "DESERT4.PLD"
DATA "DESERT5.PLD"
DATA "DESERT6.PLD"
DATA "DESERT7.PLD"
DATA "DESERT8.PLD"
DATA "DESERT9.PLD"
DATA "WALL1.PLD"
DATA "WALL2.PLD"
DATA "WALL3.PLD"
DATA "WALL4.PLD"
DATA "WALL5.PLD"
DATA "WALL6.PLD"
DATA "WALL7.PLD"
DATA "WALL8.PLD"
DATA "WALL9.PLD"
DATA "WALL10.PLD"
DATA "WALL11.PLD"
DATA "WALL12.PLD"
DATA "WALL13.PLD"
DATA "WALL14.PLD"
DATA "WALL15.PLD"
DATA "WALL16.PLD"
'98
DATA "TOWN1.PLD"
DATA "TOWN2.PLD"
DATA "TOWN3.PLD"
DATA "TOWN4.PLD"
'102
DATA "BRIDGE3.PLD"
DATA "BRIDGE4.PLD"
DATA "BRIDGE5.PLD"
DATA "BRIDGE6.PLD"
DATA "BRIDGE7.PLD"
DATA "BRIDGE8.PLD"
'108
DATA "RODJOIN5.PLD"
DATA "RIVJOIN5.PLD"
DATA "CASTLE1.PLD"
DATA "CASTLE2.PLD"
DATA "CASTLE3.PLD"
DATA "CASTLE4.PLD"
'114
DATA "ROAD7.PLD"
DATA "RIVER7.PLD"
'116
DATA "PLAINS2.PLD"
DATA "PLAINS3.PLD"
DATA "OCEAN2.PLD"
DATA "OCEAN3.PLD"
DATA "BOULDER.PLD"

REM $STATIC
SUB caves (zx%, zy%, currentscreen%(), xscreen!, yscreen!)

newp = 68
piece = currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1)
IF piece = 18 THEN newp = 70
IF piece = 70 THEN newp = 18
IF piece = 16 THEN newp = 69
IF piece = 69 THEN newp = 16
IF piece = 68 THEN newp = 21
yfig! = yscreen! + (zy% \ 20) / 10
xfig! = xscreen! + (zx% \ 20) / 16
IF xscreen! + (zx% \ 20) / 16 >= xscreenmax THEN xfig! = xscreen! + (zx% \ 20) / 16 - xscreenmax
IF yscreen! + (zy% \ 20) / 10 >= yscreenmax THEN yfig! = yscreen! + (zy% \ 20) / 10 - yscreenmax
byte$ = CHR$(newp)
byteposition& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax) + 1
PUT #1, byteposition&, byte$
PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = newp
END SUB

SUB DrawRivAndRoads (squaretype, xscreen!, yscreen!, zx%, zy%, currentscreen%())

centerpiece = currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1)

yfig! = yscreen! + (zy% \ 20) / 10
xfig! = xscreen! + (zx% \ 20) / 16
IF xscreen! + (zx% \ 20) / 16 >= xscreenmax THEN xfig! = xscreen! + (zx% \ 20) / 16 - xscreenmax
IF yscreen! + (zy% \ 20) / 10 >= yscreenmax THEN yfig! = yscreen! + (zy% \ 20) / 10 - yscreenmax

byteposition& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax) + 1

IF squaretype = 115 THEN ror = 1 ELSE ror = 2
j1 = no: j2 = no: j3 = no: j4 = no

GET #1, byteposition& - (16 * xscreenmax), byte$
piece = ASC(byte$)
IF (ror = 1 AND piece = 1 OR piece = 107 OR piece = 108 OR piece = 106) OR (ror = 2 AND piece = 2 OR piece = 24) THEN j1 = yes
IF (ror = 2 AND piece > 27 AND piece < 38) OR (ror = 1 AND piece > 37 AND piece < 44) OR (ror = 2 AND piece > 59 AND piece < 64) OR (ror = 1 AND piece > 63 AND piece < 68) OR (ror = 1 AND piece = 115 OR ror = 2 AND piece = 116) OR (ror = 1 AND piece _
 = 109 OR ror = 2 AND piece = 110) THEN
j1 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF y2 <> yes THEN
y2 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, byteposition& - (16 * xscreenmax), byte$
n = ((zy% \ 20) - 1)
IF n >= 0 THEN
PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, n + 1) = newp
END IF
END IF
END IF

GET #1, byteposition& + (16 * xscreenmax), byte$
piece = ASC(byte$)
IF (ror = 1 AND piece = 1 OR piece = 106 OR piece = 108 OR piece = 107) OR (ror = 2 AND piece = 2 OR piece = 25) THEN j2 = yes
IF (ror = 2 AND piece > 27 AND piece < 38) OR (ror = 1 AND piece > 37 AND piece < 44) OR (ror = 2 AND piece > 59 AND piece < 64) OR (ror = 1 AND piece > 63 AND piece < 68) OR (ror = 1 AND piece = 115 OR ror = 2 AND piece = 116) OR (ror = 1 AND piece _
 = 109 OR ror = 2 AND piece = 110) THEN
j2 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF y1 <> yes THEN
y1 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, byteposition& + (16 * xscreenmax), byte$
n = ((zy% \ 20) + 1)
IF n < 10 THEN
PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, n + 1) = newp
END IF
END IF
END IF

GET #1, byteposition& - 1, byte$
piece = ASC(byte$)
IF (ror = 2 AND piece = 1) OR (ror = 1 AND (piece = 2 OR piece = 23 OR piece = 104 OR ((piece = 103 OR piece = 105) AND centerpiece = 26))) THEN j3 = yes
IF (ror = 2 AND piece > 27 AND piece < 38) OR (ror = 1 AND piece > 37 AND piece < 44) OR (ror = 2 AND piece > 59 AND piece < 64) OR (ror = 1 AND piece > 63 AND piece < 68) OR (ror = 1 AND piece = 115 OR ror = 2 AND piece = 116) OR (ror = 1 AND piece _
 = 109 OR ror = 2 AND piece = 110) THEN
j3 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF x2 <> yes THEN
x2 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, byteposition& - 1, byte$
n = ((zx% \ 20) - 1)
IF n >= 0 THEN
PUT (n * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(n + 1, zy% \ 20 + 1) = newp
END IF
END IF
END IF

GET #1, byteposition& + 1, byte$
piece = ASC(byte$)
IF (ror = 2 AND piece = 1) OR (ror = 1 AND (piece = 2 OR piece = 22 OR piece = 103 OR ((piece = 105 OR piece = 104) AND centerpiece = 26))) THEN j4 = yes
IF (ror = 2 AND piece > 27 AND piece < 38) OR (ror = 1 AND piece > 37 AND piece < 44) OR (ror = 2 AND piece > 59 AND piece < 64) OR (ror = 1 AND piece > 63 AND piece < 68) OR (ror = 1 AND piece = 115 OR ror = 2 AND piece = 116) OR (ror = 1 AND piece _
 = 109 OR ror = 2 AND piece = 110) THEN
j4 = yes
CALL getattributes(piece, x1, x2, y1, y2)
IF x1 <> yes THEN
x1 = yes
CALL selectroadriver(x1, x2, y1, y2, ror, newp)
byte$ = CHR$(newp)
PUT #1, byteposition& + 1, byte$
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
CASE 26
IF ror = 1 THEN
IF j1 = yes OR j2 = yes THEN newp = 108
IF j3 = yes OR j4 = yes THEN newp = 105
END IF
CASE 28: IF ror = 1 THEN newp = 1
CASE 33: IF ror = 1 THEN newp = 2
CASE 38: IF ror = 2 THEN newp = 1
CASE 39: IF ror = 2 THEN newp = 2
CASE 44: IF ror = 1 THEN newp = 106 ELSE newp = 25
CASE 45: IF ror = 1 THEN newp = 107 ELSE newp = 24
CASE 46: IF ror = 1 THEN newp = 103 ELSE newp = 22
CASE 47: IF ror = 1 THEN newp = 104 ELSE newp = 23
END SELECT

byte$ = CHR$(newp)
PUT #1, byteposition&, byte$
PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = newp

END SUB

SUB DrawScreen (xscreen!, yscreen!, currentscreen%(), direction, xb!, yb!)
'
'  each squares byte position goes as follows:
'  xscreen! * 16 + yscreen! * 10

'bytepositon right now is defining the upper left corner of a screen

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
byteposition& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax)


SELECT CASE direction
CASE downright
        FOR x = 1 TO 15
        FOR y = 1 TO 9
        currentscreen%(x, y) = currentscreen%(x + 1, y + 1)
        NEXT
        NEXT
       
        FOR x = 1 TO 16
        GET #1, byteposition& + (x - 1) + (9) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 180), picture&(0, f), PSET
        currentscreen%(x, 10) = f
        NEXT
        FOR y = 1 TO 9
        GET #1, byteposition& + (15) + (y - 1) * (16 * xscreenmax) + 1, byte$
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
        GET #1, byteposition& + (x - 1) + (9) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 180), picture&(0, f), PSET
        currentscreen%(x, 10) = f
        NEXT
       
        FOR y = 1 TO 10
        GET #1, byteposition& + (0) + (y - 1) * (16 * xscreenmax) + 1, byte$
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
        GET #1, byteposition& + (x - 1) + (0) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 0), picture&(0, f), PSET
        currentscreen%(x, 1) = f
        NEXT
        FOR y = 2 TO 10
        GET #1, byteposition& + (15) + (y - 1) * (16 * xscreenmax) + 1, byte$
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
        GET #1, byteposition& + (x - 1) + (0) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        PUT ((x - 1) * 20, 0), picture&(0, f), PSET
        currentscreen%(x, 1) = f
        NEXT
        FOR y = 1 TO 10
        GET #1, byteposition& + (0) + (y - 1) * (16 * xscreenmax) + 1, byte$
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
       
        FOR x = 1 TO 16
        GET #1, byteposition& + (x - 1) + (0) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
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
        GET #1, byteposition& + (x - 1) + (9) * (16 * xscreenmax) + 1, byte$
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
        GET #1, byteposition& + (0) + (y - 1) * (16 * xscreenmax) + 1, byte$
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
        GET #1, byteposition& + (15) + (y - 1) * (16 * xscreenmax) + 1, byte$
        f = ASC(byte$)
        
        PUT (300, (y - 1) * 20), picture&(0, f), PSET
        currentscreen%(16, y) = f
        NEXT

CASE ELSE


FOR n = 1 TO 10
FOR m = 1 TO 16
GET #1, byteposition& + (m - 1) + (n - 1) * (16 * xscreenmax) + 1, byte$
f = ASC(byte$)
IF f <> 0 THEN
PUT ((m - 1) * 20, (n - 1) * 20), picture&(0, f), PSET
END IF
currentscreen%(m, n) = f
NEXT m
NEXT n
END SELECT

END SUB

SUB eraseplain (zx%, zy%, byteposition&, currentscreen())


GET #1, byteposition& - (16 * xscreenmax) + 1, byte$: top$ = byte$
GET #1, byteposition& + (16 * xscreenmax) + 1, byte$: bottom$ = byte$
GET #1, byteposition&, byte$: lft$ = byte$
GET #1, byteposition& + 2, byte$: rgt$ = byte$
top = ASC(top$)
bottom = ASC(bottom$)
lft = ASC(lft$)
rgt = ASC(rgt$)

ror = 0
IF (top > 27 AND top < 38) OR (top > 59 AND top < 64) OR (top = 110) THEN ror = 2
IF (top > 37 AND top < 44) OR (top > 63 AND top < 68) OR (top = 109) THEN ror = 1
IF top = 24 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = top: CALL getattributes(piece, x1, x2, y1, y2)
     y2 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 45
     END IF
     IF newp <> top THEN
          byte$ = CHR$(newp)
          PUT #1, byteposition& - (16 * xscreenmax) + 1, byte$
          n = ((zy% \ 20) - 1)
       
          IF n >= 0 THEN
               PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
               currentscreen%(zx% \ 20 + 1, n + 1) = newp
          END IF
     END IF
END IF

ror = 0
IF (bottom > 27 AND bottom < 38) OR (bottom > 59 AND bottom < 64) OR (bottom = 110) THEN ror = 2
IF (bottom > 37 AND bottom < 44) OR (bottom > 63 AND bottom < 68) OR (bottom = 109) THEN ror = 1
IF bottom = 25 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = bottom: CALL getattributes(piece, x1, x2, y1, y2)
     y1 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 44
     END IF
     IF newp <> bottom THEN
          byte$ = CHR$(newp)
          PUT #1, byteposition& + (16 * xscreenmax) + 1, byte$
          n = ((zy% \ 20) + 1)
        
          IF n < 10 THEN
               PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
               currentscreen%(zx% \ 20 + 1, n + 1) = newp
          END IF
     END IF
END IF

ror = 0
IF (lft > 27 AND lft < 38) OR (lft > 59 AND lft < 64) OR (lft = 110) THEN ror = 2
IF (lft > 37 AND lft < 44) OR (lft > 63 AND lft < 68) OR (lft = 109) THEN ror = 1
IF lft = 23 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = lft: CALL getattributes(piece, x1, x2, y1, y2)
     x2 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 47
     END IF
     IF newp <> lft THEN
          byte$ = CHR$(newp)
          PUT #1, byteposition&, byte$

          n = ((zx% \ 20) - 1)
          IF n >= 0 THEN
               PUT (n * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
               currentscreen%(n + 1, zy% \ 20 + 1) = newp
          END IF
     END IF
END IF

ror = 0
IF (rgt > 27 AND rgt < 38) OR (rgt > 59 AND rgt < 64) OR (rgt = 110) THEN ror = 2
IF (rgt > 37 AND rgt < 44) OR (rgt > 63 AND rgt < 68) OR (rgt = 109) THEN ror = 1
IF rgt = 22 THEN ror = 3
IF ror <> 0 THEN
     IF ror <> 3 THEN
     piece = rgt: CALL getattributes(piece, x1, x2, y1, y2)
     x1 = no
     CALL selectroadriver(x1, x2, y1, y2, ror, newp)
     ELSE
     newp = 46
     END IF
     IF newp <> rgt THEN
          byte$ = CHR$(newp)
          PUT #1, byteposition& + 2, byte$

          n = ((zx% \ 20) + 1)
          IF n < 16 THEN
               PUT (n * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
               currentscreen%(n + 1, zy% \ 20 + 1) = newp
          END IF
     END IF
END IF

IF top = 3 OR top = 4 THEN
IF top = 3 THEN newp = 5
IF top = 4 THEN newp = 59
          byte$ = CHR$(newp)
          PUT #1, byteposition& - (16 * xscreenmax) + 1, byte$
          n = ((zy% \ 20) - 1)
      
          IF n >= 0 THEN
               PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
               currentscreen%(zx% \ 20 + 1, n + 1) = newp
          END IF
END IF
IF bottom = 3 OR bottom = 5 THEN
IF bottom = 3 THEN newp = 4
IF bottom = 5 THEN newp = 59
          byte$ = CHR$(newp)
          PUT #1, byteposition& + (16 * xscreenmax) + 1, byte$
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
byteposition& = xfig! * 16 + (yfig! * 10) * (16 * xscreenmax) + 1

GET #1, byteposition& - 768, byte$
piece = ASC(byte$)
IF (piece > 2 AND piece < 6) OR piece = 59 THEN
            j1 = yes
            newp = 0
            IF piece = 5 THEN newp = 3
            IF piece = 59 THEN newp = 4
                                                          
            IF newp <> 0 THEN
                        byte$ = CHR$(newp)
                        PUT #1, byteposition& - 768, byte$
                                                          
                        n = ((zy% \ 20) - 1)
                        IF n >= 0 THEN
                        PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
                        currentscreen%(zx% \ 20 + 1, n + 1) = newp
                        END IF
                                              
            END IF
END IF
                                  
GET #1, byteposition& + 768, byte$
piece = ASC(byte$)
IF (piece > 2 AND piece < 6) OR piece = 59 THEN
            j2 = yes
            newp = 0
            IF piece = 4 THEN newp = 3
            IF piece = 59 THEN newp = 5
                                                         
            IF newp <> 0 THEN
                        byte$ = CHR$(newp)
                        PUT #1, byteposition& + 768, byte$
                                                         
                        n = ((zy% \ 20) + 1)
                        IF n < 10 THEN
                        PUT ((zx% \ 20) * 20, n * 20), picture&(0, newp), PSET
                        currentscreen%(zx% \ 20 + 1, n + 1) = newp
                        END IF
                                             
            END IF
END IF

newp = 0
IF j1 = yes AND j2 = yes THEN newp = 3
IF j1 = yes AND j2 = no THEN newp = 5
IF j1 = no AND j2 = yes THEN newp = 4
IF j1 = no AND j2 = no THEN newp = 59
byte$ = CHR$(newp)
PUT #1, byteposition&, byte$

PUT ((zx% \ 20) * 20, (zy% \ 20) * 20), picture&(0, newp), PSET
currentscreen%(zx% \ 20 + 1, zy% \ 20 + 1) = newp


END SUB

SUB getattributes (piece, x1, x2, y1, y2)

SELECT CASE piece
CASE 109, 110, 1, 2: v = 1
CASE 65, 35: v = 2
CASE 67, 34: v = 3
CASE 39, 28: v = 4
CASE 64, 36: v = 5
CASE 41, 29: v = 6
CASE 40, 30: v = 7
CASE 62: v = 8
CASE 66, 37: v = 9
CASE 43, 31: v = 10
CASE 42, 32: v = 11
CASE 60: v = 12
CASE 38, 33: v = 13
CASE 61: v = 14
CASE 63: v = 15
CASE 115, 116: v = 16
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

END SUB

DEFSNG A-Z
SUB loadpics (filename$())

num = 1
FOR f = 1 TO plds
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

SUB makedata (currentscreen())
'
'  each squares byte position goes as follows:
'  xscreen * 16 + yscreen * 10
'
byteposition& = (xscreen - 1) * 160 + (yscreen - 1) * (160 * xscreenmax)
'bytepositon right now is defining the upper left corner of a screen
n = 1
m = 1

DO

PUT #1, byteposition& + (m - 1) + (n - 1) * 16, currentscreen(m, n)




LOOP

END SUB

SUB mountainfix (xscreen, yscreen, currentscreen%())
mousehide

FOR i = 1 TO 16

FOR j = 1 TO 10
IF (currentscreen%(i, j) > 5 AND currentscreen%(i, j) < 22) THEN
       
        t = no: B = no: l = no: r = no
       
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
                    GET #1, bytepos&, byte$: B = ASC(byte$)
        ELSE
        B = currentscreen%(i, j + 1)
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
       
        IF (t > 5 AND t < 22) THEN
        t = yes
        ELSE
        t = no
        END IF
        IF (B > 5 AND B < 22) OR (B > 68 AND B < 71) THEN
        B = yes
        ELSE
        B = no
        END IF
        IF (l > 5 AND l < 22) OR (l = 70) THEN
        l = yes
        ELSE
        l = no
        END IF
        IF (r > 5 AND r < 22) OR (r = 70) THEN
        r = yes
        ELSE
        r = no
        END IF

        IF t = yes AND B = no THEN
                IF l = yes AND r = no THEN kind = 7
                IF r = yes AND l = no THEN kind = 8
                IF l = no AND r = no THEN kind = 16
                IF l = yes AND r = yes THEN kind = 18
        END IF

        IF B = yes AND t = no THEN
                IF l = no AND r = yes THEN kind = 9
                IF r = no AND l = yes THEN kind = 10
                IF l = no AND r = no THEN kind = 14
                IF l = yes AND r = yes THEN kind = 20
        END IF

        IF B = yes AND t = yes THEN
                IF l = yes AND r = yes THEN kind = 6
                IF r = no AND l = no THEN kind = 11
                IF l = yes AND r = no THEN kind = 17
                IF r = yes AND l = no THEN kind = 19
        END IF

        IF B = no AND t = no THEN
                IF l = yes AND r = yes THEN kind = 12
                IF l = yes AND r = no THEN kind = 13
                IF l = no AND r = yes THEN kind = 15
                IF l = no AND r = no THEN kind = 21
        END IF

        byte$ = CHR$(kind)
        byteposition& = xscreen * 16 + (yscreen * 10) * (16 * xscreenmax)
        PUT #1, byteposition& + (i - 1) + (j - 1) * (16 * xscreenmax) + 1, byte$

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
SUB putscreen (currentscreen%())

FOR j = 1 TO 16
FOR i = 1 TO 10
f = currentscreen%(j, i)
PUT ((x - 1) * 20, (y - 1) * 20), picture&(0, f), PSET
NEXT i
NEXT j

END SUB

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
CASE 1: newp = 109
CASE 2: newp = 65
CASE 3: newp = 67
CASE 4: newp = 39
CASE 5: newp = 64
CASE 6: newp = 41
CASE 7: newp = 40
CASE 8: newp = 39
CASE 9: newp = 66
CASE 10: newp = 43
CASE 11: newp = 42
CASE 12: newp = 39
CASE 13: newp = 38
CASE 14: newp = 38
CASE 15: newp = 38
CASE 16: newp = 115
END SELECT
CASE 2
SELECT CASE v
CASE 1: newp = 110
CASE 2: newp = 35
CASE 3: newp = 34
CASE 4: newp = 28
CASE 5: newp = 36
CASE 6: newp = 29
CASE 7: newp = 30
CASE 8: newp = 62
CASE 9: newp = 37
CASE 10: newp = 31
CASE 11: newp = 32
CASE 12: newp = 60
CASE 13: newp = 33
CASE 14: newp = 63
CASE 15: newp = 61
CASE 16: newp = 116
END SELECT
END SELECT
END SUB

SUB setpieces (kind, xattrib, yattrib)
xattrib = 0: yattrib = 0
SELECT CASE kind
CASE 44: yattrib = 1
CASE 45: yattrib = 2
CASE 46: xattrib = 1
CASE 47: xattrib = 2
CASE 48: xattrib = 2: yattrib = 2
CASE 49: xattrib = 1: yattrib = 2
CASE 50: xattrib = 1: yattrib = 1
CASE 51: xattrib = 2: yattrib = 1
CASE 52: xattrib = 1: yattrib = 1
CASE 53: xattrib = 1: yattrib = 2
CASE 54: xattrib = 2: yattrib = 2
CASE 55: xattrib = 2: yattrib = 1
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
            CASE 1: kind = 46
            CASE 2: kind = 47
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
                                    kind = 48
                                    ELSE
                                    kind = 52
                                    END IF
                        CASE 1
                                   
                                    IF (ydir1 = 1 AND xattrib = 2 AND (yattrib <> 2 OR dir = 0)) OR (xdir2 = -1 AND yattrib = 1 AND (xattrib <> 1 OR dir = 2)) THEN
                                    kind = 51
                                    ELSE
                                    kind = 53
                                    END IF
                        END SELECT
            CASE 1
                        IF ydir1 = 0 THEN
                        SWAP ydir1, ydir2
                        END IF
                        SELECT CASE ydir1
                        CASE -1
                                   
                                    IF (ydir1 = -1 AND xattrib = 1 AND (yattrib <> 1 OR dir = 0)) OR (xdir2 = 1 AND (yattrib = 2) AND (xattrib <> 2 OR dir = 2)) THEN
                                    kind = 49
                                    ELSE
                                    kind = 55
                                    END IF
                        CASE 1
                                   
                                    IF (ydir1 = 1 AND xattrib = 1 AND (yattrib <> 2 OR dir = 0)) OR (xdir2 = 1 AND yattrib = 1 AND (xattrib <> 2 OR dir = 2)) THEN
                                    kind = 50
                                    ELSE
                                    kind = 54
                                    END IF
                        END SELECT
            END SELECT
                                   
CASE 2'goes straight across
            SELECT CASE yattrib
            CASE 1: kind = 44
            CASE 2: kind = 45
            END SELECT
END SELECT
IF kind <> 0 THEN
CALL setpieces(kind, xattrib, yattrib)
currentscreen(pieces(2, 1), pieces(2, 2)) = kind
PUT ((pieces(2, 1) - 1) * 20, (pieces(2, 2) - 1) * 20), picture&(0, kind), PSET
byteposition& = xscreen! * 16 + yscreen! * 10 * 16 * xscreenmax
B$ = CHR$(kind)
PUT #1, byteposition& + pieces(2, 1) - 1 + (pieces(2, 2) - 1) * 16 * xscreenmax + 1, B$
END IF
END SUB

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

