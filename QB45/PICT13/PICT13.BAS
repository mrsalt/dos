DECLARE SUB merge (currentpalette, wholescreen&(), pal&(), picture&(), colorsfrom!(), numbers%())
DECLARE SUB MATH (picture&(), numbers%(), t!)
DECLARE SUB savepalette (pcolors(), currentpalette)
DECLARE SUB SaveAs (filename$, palfilename$)
DECLARE SUB loadfile (currentname$)
DECLARE SUB RETRIEVE (size!, picture&(), wholescreen&(), currentpalette, pal&(), filename$)
DECLARE SUB SAVE (px1, py1, px2, py2, picture&(), size, wholescreen&(), filename$)
DECLARE SUB reproduce (px1, py1, px2, py2, picture&())
DECLARE SUB openpalette (filename$, maxpals, pcolors(), pal&())
DECLARE SUB editcolor (curcolor, pcolors(), pal&(), currentpalette)
DECLARE SUB mousestatus (lb%, rb%, zx%, zy%)
DECLARE SUB MouseRange (x1%, y1%, x2%, y2%)
DECLARE SUB MousePut (x%, y%)
DECLARE SUB mousehide ()
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE SUB mouseshow ()
DECLARE FUNCTION MouseInit% ()

INPUT "Where are the data files"; where$
IF where$ <> "" THEN
CHDIR where$
ELSE
CHDIR "c:\qb45\pict13\plds"
END IF

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
RANDOMIZE TIMER                              ' Seed RND() with the timer value
KEY 15, CHR$(160) + "K"                      ' Left arrow
KEY 16, CHR$(160) + "M"                      ' Right arrow
KEY 17, CHR$(160) + "H"                      ' Up arrow
KEY 18, CHR$(160) + "P"                      ' Down arrow
ON KEY(15) GOSUB Downcolor                     ' Set event trapping for the
ON KEY(16) GOSUB Upcolor                       ' keys
ON KEY(17) GOSUB UpPalette
ON KEY(18) GOSUB DownPalette
KEY(15) ON                                   ' Turn on the keys
KEY(16) ON
KEY(17) ON
KEY(18) ON

'$DYNAMIC
box:
DATA " ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
DATA " ³                 %   ³"
DATA " ³ COLOR:                ³"
DATA " ³              ÚÄÄÄ¿  ³"
DATA " ³ ÚÄÄÄÄ¿  RED    ³   ³  ³"
DATA " ³ ³    ³         ÃÄÄÄ´  ³"
DATA " ³ ³    ³  GREEN  ³   ³  ³"
DATA " ³ ³    ³         ÃÄÄÄ´  ³"
DATA " ³ ³    ³  BLUE   ³   ³  ³"
DATA " ³ ³    ³         ÀÄÄÄÙ  ³"
DATA " ³ ³    ³ ÚÄÄÄÄÄÄ¿ÚÄÄÄÄÄ¿³"
DATA " ³ ³    ³ ³ACCEPT³³RESET³³"
DATA " ³ ÀÄÄÄÄÙ ÀÄÄÄÄÄÄÙÀÄÄÄÄÄÙ³"
DATA " ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

bottomright:
DATA "ÚÄÄÄÄÄ¿ÚÄÄÄÄ¿ÚÄÄÄÄ¿"
DATA "³S PAL³³S AS³³MERG³"
DATA "ÀÄÄÄÄÄÙÀÄÄÄÄÙÀÄÄÄÄÙ"
DATA "ÚÄÄÄÄÄ¿ÚÄÄÄÄ¿ÚÄÄÄÄ¿"
DATA "³CHECK³³OPEN³³SAVE³"
DATA "ÀÄÄÄÄÄÙÀÄÄÄÄÙÀÄÄÄÄÙ"

CONST yes = 1, no = -1, xsize = 20, ysize = 20
CONST squaresize = 5
CONST top = 49, bottom = top + xsize * squaresize + 1
CONST left = 49, right = left + ysize * squaresize + 1
CONST xrepeats = 5, yrepeats = 5     ' how many times the smaller grid repeats
CONST leftrepeat = right + 10, rightrepeat = leftrepeat + xrepeats * xsize + 1
CONST toprepeat = 29, bottomrepeat = toprepeat + yrepeats * ysize + 1
CONST ext$ = ".PLD" ' Pattern Layout Display
CONST defaultppalette = 0
CONST defaultname$ = "SUMMER.PAL"
DIM SHARED errnum AS INTEGER
DIM byte AS STRING * 1
CLS

SCREEN 12
WIDTH 80, 60
  
  SHELL "dir *.pal "
g = 5
DO
g = g + 1
ps = SCREEN(g, 9)
IF CHR$(ps) <> " " THEN EXIT DO
LOOP

v = SCREEN(g, 8)

maxpals = VAL(CHR$(v)) * 10 + VAL(CHR$(ps))
DIM SHARED filen$(maxpals - 1)
DIM pcolors(255, 3, maxpals - 1)
DIM pal(255, maxpals - 1) AS LONG

DIM numbers(4) AS INTEGER
DIM colorsfrom(4)

DIM tfilen$(maxpals - 1)
DIM tpcolors(255, 3, maxpals - 1)
DIM tppal(255, maxpals - 1) AS LONG

ERASE tfilen$, tpcolors, tppal
px1 = leftrepeat + 1
px2 = px1 + xsize - 1
py1 = toprepeat + 1
py2 = py1 + ysize - 1
size = CINT(((px2 - px1 + 1) / 2) * ((py2 - py1 + 1) / 2) + 1)
DIM picture(size) AS LONG
DIM wholescreen(16001) AS LONG

'ON ERROR GOTO errorhandler

'  My goal right now is to make is so that with each file there is
'  a corresponding palette file that ties in.  The best way to do this
'  is to make it so that all possible palettes are loaded and then you
'  can change to any one of them simply by pressing up or down.  And
'  when a pattern is loaded it automatically changes to that palette.
'  Palettes will be savable, but I think I will just take that open palette
'  function off, since all will be loaded.

ax = 0: ay = 0: ax2 = 0: ay2 = 0  ' mouse position data

CALL openpalette(filename$, maxpals, pcolors(), pal&())
    PALETTE USING pal&(0, 0)                      ' Change the palette to the first one
                 'starting with first color, the first palette
    currentpalette = 0
   
    FOR Clr = 0 TO 255                           ' Draw the palette bar
        LINE (Clr, 1)-(Clr, 8), Clr
    NEXT
 
    LINE (260, 0)-(319, 9), 1, BF                ' Draw the current color Box
    LINE (260, 0)-(319, 9), 255, B
    PRESET (1, 0), 255
    PRESET (1, 9), 255

LINE (left, top)-(right, bottom), 255, B
LINE (leftrepeat, toprepeat)-(rightrepeat, bottomrepeat), 255, B

COLOR 255
RESTORE bottomright
FOR i = 1 TO 6
READ j$
LOCATE 17 + i, 22: PRINT j$
NEXT i
curcolor = 1

CALL mouseshow
mousehidden = no
mode = 1
selectnewcolor = no
DO
mode1:
        DO
        DO
                q = zx%: w = zy%: leftcheck = lb%: rightcheck = rb%
                
                CALL mousestatus(lb%, rb%, zx%, zy%)
               
                choice$ = INKEY$
                zx% = zx% \ 2
       
                IF choice$ = CHR$(27) THEN SYSTEM
        LOOP WHILE zx% = q AND zy% = w AND leftcheck = lb% AND rightcheck = rb%
       
        

        IF lb% = -1 THEN
               
                IF check = 0 THEN     'if check = 1 then the mouse is being dragged
                        ox% = zx%             ' with the left button held down
                        oy% = zy%
                        check = 1
                END IF
                'LOCATE 7, 20: PRINT " "
                'LOCATE 8, 20: PRINT "Û"
              
        ELSE
               
                'LOCATE 7, 20: PRINT "Û"
                'LOCATE 8, 20: PRINT " "
                check = 0
        END IF

               
                xsquare! = (zx% - left) / squaresize
                ysquare! = (zy% - top) / squaresize
                IF (xsquare! <> INT(xsquare!)) THEN xsquare = INT(xsquare! + 1)
                IF (ysquare! <> INT(ysquare!)) THEN ysquare = INT(ysquare! + 1)
               
                'oxsquare! = (ox% - left) / squaresize
                'oysquare! = (oy% - top) / squaresize
                'IF (oxsquare! <> INT(oxsquare!)) THEN oxsquare = INT(oxsquare! + 1)
                'IF (oysquare! <> INT(oysquare!)) THEN oysquare = INT(oysquare! + 1)
                'COLOR 255
                LOCATE 3, 1: PRINT "Palette:"; filen$(currentpalette) + "       "
                LOCATE 4, 1: PRINT "File:"; filename$
                'LOCATE 3, 1: PRINT "X:"; zx%
                'LOCATE 4, 1: PRINT "Y:"; zy%
                'LOCATE 5, 1: PRINT "Oxsquare:"; oxsquare
                'LOCATE 6, 1: PRINT "Oysquare:"; oysquare
                'LOCATE 5, 15: PRINT "xsquare:"; xsquare
                'LOCATE 6, 15: PRINT "ysquare:"; ysquare

                IF lb% <> -1 AND selectnewcolor = yes AND zy% < 9 AND zx% < 260 THEN
                       
                        selectnewcolor = no
                        curcolor = zx%
                        LOCATE 22, 3: PRINT "Current Color"; curcolor; " "
                END IF
       
                IF check <> 1 AND (zx% <> q OR zy% <> w) THEN
                        CALL mousehide
                       
                        COLOR 255
                        LOCATE 21, 3: PRINT "Position"; xsquare; ","; ysquare; "  "
                        LOCATE 22, 3: PRINT "Current Color"; curcolor; " "
                        LOCATE 23, 3: PRINT "Color"; POINT(zx%, zy%); "  "
                        CALL mouseshow
                END IF
       
        LOOP WHILE lb% <> -1 AND rb% <> -1 AND choice$ = ""
       
        IF rb% = -1 AND lb% <> -1 THEN
        now! = TIMER
       
        IF now! - thisclick! > .5 THEN
        mousehide
        C = POINT(zx%, zy%)
        PRESET (curcolor, 0), 0
        PRESET (curcolor, 9), 0
        PRESET (C, 0), 255
        PRESET (C, 9), 255
        curcolor = C
        COLOR 255
        LOCATE 22, 3: PRINT "Current Color"; curcolor; "  "
        LINE (261, 1)-(318, 8), curcolor, BF
        COLOR curcolor
        mouseshow
        END IF
        END IF
       
       
        IF zy% < 9 AND lb% = -1 AND zx% < 256 THEN
                
                IF selectnewcolor = no THEN
               
                CALL mousehide
                PRESET (curcolor, 0), 0
                PRESET (curcolor, 9), 0
                PRESET (zx%, 0), 255
                PRESET (zx%, 9), 255
                CALL mouseshow
                ELSEIF q <> zx% THEN
               
                CALL mousehide
                PRESET (zx%, 0), 255
                PRESET (zx%, 9), 255
                PRESET (q, 0), 0
                PRESET (q, 9), 0
                CALL mouseshow
                END IF
               
                selectnewcolor = yes
                LINE (261, 1)-(318, 8), zx%, BF
                LOCATE 23, 3: PRINT "Color"; zx%; "  "
              
        END IF
       
        IF selectnewcolor = yes AND zy% > 8 AND check = 1 THEN
               
                selectnewcolor = no
                PRESET (zx%, 0), 0
                PRESET (zx%, 9), 0
                PRESET (curcolor, 0), 255
                PRESET (curcolor, 9), 255
                LINE (261, 1)-(318, 8), curcolor, BF
        END IF
       
       
        doubleclick = no
        IF (lb% = -1) THEN GOSUB leftbutton
        IF lb% = -1 THEN act = 1 ELSE act = 2
       
        IF zx% > 260 AND zx% < 319 THEN
        IF zy% > 0 AND zy% < 9 THEN
        GOSUB changecolor
        END IF
        END IF
        
               
                SELECT CASE zx%

                CASE left + 1 TO right - 1
                IF zy% > top AND zy% < bottom THEN
                
                xsquare! = (zx% - left) / squaresize
                ysquare! = (zy% - top) / squaresize
                IF (xsquare! <> INT(xsquare!)) THEN xsquare = INT(xsquare! + 1)
                IF (ysquare! <> INT(ysquare!)) THEN ysquare = INT(ysquare! + 1)
                CALL mousehide
               
                x1 = xsquare * squaresize + left - (squaresize - 1)
                y1 = ysquare * squaresize + top - (squaresize - 1)
                x2 = xsquare * squaresize + left
                y2 = ysquare * squaresize + top
                LINE (x1, y1)-(x2, y2), curcolor, BF
              
               
                IF lb% = -1 AND rb% = -1 AND check = 1 THEN 'mouse dragged, + right click
                        oxsquare! = (ox% - left) / squaresize
                        oysquare! = (oy% - top) / squaresize
                        IF (oxsquare! <> INT(oxsquare!)) THEN oxsquare = INT(oxsquare! + 1)
                        IF (oysquare! <> INT(oysquare!)) THEN oysquare = INT(oysquare! + 1)
                        IF xsquare > oxsquare THEN
                               
                                IF ysquare > oysquare THEN
                                        x1 = xsquare * squaresize + left
                                        y1 = ysquare * squaresize + top
                                        x2 = oxsquare * squaresize + left - (squaresize - 1)
                                        y2 = oysquare * squaresize + top - (squaresize - 1)
                                        LINE (x1, y1)-(x2, y2), curcolor, BF
                                ELSE
                                        x1 = xsquare * squaresize + left
                                        y1 = ysquare * squaresize + top - (squaresize - 1)
                                        x2 = oxsquare * squaresize + left - (squaresize - 1)
                                        y2 = oysquare * squaresize + top
                                        LINE (x1, y1)-(x2, y2), curcolor, BF
                                END IF
                        ELSE
                               
                                IF ysquare > oysquare THEN
                                        x1 = xsquare * squaresize + left - (squaresize - 1)
                                        y1 = ysquare * squaresize + top
                                        x2 = oxsquare * squaresize + left
                                        y2 = oysquare * squaresize + top - (squaresize - 1)
                                        LINE (x1, y1)-(x2, y2), curcolor, BF
                                ELSE
                                        x1 = xsquare * squaresize + left - (squaresize - 1)
                                        y1 = ysquare * squaresize + top - (squaresize - 1)
                                        x2 = oxsquare * squaresize + left
                                        y2 = oysquare * squaresize + top
                                        LINE (x1, y1)-(x2, y2), curcolor, BF
                                END IF
                        END IF
                END IF
                CALL mouseshow
                END IF
                CASE 171 TO 316
                       
                        SELECT CASE zy%
                        CASE 140 TO 156
                                SELECT CASE zx%
                                CASE 171 TO 220 ' SAVE PALETTE
                               
                                IF filen$(currentpalette) <> "" THEN
                                CALL savepalette(pcolors(), currentpalette)
                                END IF

                                CASE 227 TO 268 ' SAVE AS
                                        mousehide
                                        GET (0, 0)-(319, 199), wholescreen&(0)
                                       
                                        CALL SaveAs(filename$, palfilename$)
                                       
                                        SCREEN 13
                                        PUT (0, 0), wholescreen&(0), PSET
                                        PALETTE USING pal&(0, currentpalette)
                                       
                                        IF RIGHT$(palfilename$, 3) = "PAL" THEN
                                              
                                                ' A new palette is being created, from an old palette,
                                                ' so some variables need to be redimensioned to accomadate the
                                                ' new palette.
                                                ' make it so you can reset
                                                LOCATE 5, 1: PRINT "New PAL being made.."
                                                REDIM tfilen$(maxpals - 1)
                                                REDIM tpcolors(255, 3, maxpals - 1)
                                                REDIM tppal(255, maxpals - 1) AS LONG
                                                                                               
                                                FOR i = 0 TO maxpals - 1: tfilen$(i) = filen$(i): NEXT
                                                FOR q = 0 TO maxpals - 1
                                                FOR w = 0 TO 255
                                                FOR i = 1 TO 3
                                                tpcolors(w, i, q) = pcolors(w, i, q)
                                                NEXT
                                                NEXT
                                                NEXT
                                                FOR i = 0 TO 255
                                                FOR q = 0 TO maxpals - 1
                                                tppal(i, q) = pal(i, q)
                                                NEXT
                                                NEXT

                                                maxpals = maxpals + 1
                                               
                                                REDIM filen$(maxpals - 1)
                                                REDIM pcolors(255, 3, maxpals - 1)
                                                REDIM pal(255, maxpals - 1) AS LONG
                                                
                                                FOR i = 0 TO maxpals - 2: filen$(i) = tfilen$(i): NEXT
                                               
                                                FOR q = 0 TO maxpals - 2
                                                FOR w = 0 TO 255
                                                FOR i = 1 TO 3
                                                pcolors(w, i, q) = tpcolors(w, i, q)
                                                NEXT
                                                NEXT
                                                NEXT
                                                FOR i = 0 TO 255
                                                FOR q = 0 TO maxpals - 2
                                                pal(i, q) = tppal(i, q)
                                                NEXT
                                                NEXT

                                                ERASE tfilen$, tpcolors, tppal
                                               
                                                FOR i = 0 TO 255
                                                pcolors(i, 1, maxpals - 1) = pcolors(i, 1, currentpalette)
                                                pcolors(i, 2, maxpals - 1) = pcolors(i, 2, currentpalette)
                                                pcolors(i, 3, maxpals - 1) = pcolors(i, 3, currentpalette)
                                                pal&(i, maxpals - 1) = pal&(i, currentpalette)
                                                NEXT i
                                               
                                                n = FREEFILE
                                                OPEN filen$(currentpalette) FOR BINARY AS n
                                                
                                                FOR i = 0 TO 255
                                                GET #n, , byte: red = ASC(byte)
                                                GET #n, , byte: green = ASC(byte)
                                                GET #n, , byte: blue = ASC(byte)
                                                pcolors(i, 1, currentpalette) = red
                                                pcolors(i, 2, currentpalette) = green
                                                pcolors(i, 3, currentpalette) = blue
                                                pal&(i, currentpalette) = 65536 * blue + 256 * green + red
                                                NEXT
                                                
                                                currentpalette = maxpals - 1
                                                filen$(currentpalette) = palfilename$
                                               
                                                CALL savepalette(pcolors(), currentpalette)
                                                LOCATE 5, 1: PRINT "                    "
                                                CALL mouseshow
                                                palfilename$ = ""
                                        ELSE
                                                CALL SAVE(px1, py1, px2, py2, picture&(), size, wholescreen&(), filename$)
                                        END IF
                                       
                                      
                                CASE 275 TO 316     ' MERGE

                                CALL merge(currentpalette, wholescreen&(), pal&(), picture&(), colorsfrom(), numbers%())
                                END SELECT
                        CASE 164 TO 180
                                SELECT CASE zx%
                                CASE 171 TO 220 'check
                                CALL reproduce(px1, py1, px2, py2, picture&())
                               
                                CASE 227 TO 268 'open
                                mousehide
                                CALL RETRIEVE(size, picture&(), wholescreen&(), currentpalette, pal&(), filename$)
                                mouseshow
                                CASE 275 TO 316 'save
                               
                                IF filename$ <> "" THEN
                                CALL SAVE(px1, py1, px2, py2, picture&(), size, wholescreen&(), filename$)
                                END IF

                                END SELECT
                        END SELECT
                END SELECT
            
LOOP

mode2:


changecolor:

IF doubleclick = yes THEN act = 3

        IF zy% > 0 AND zy% < 9 THEN
                CALL mousehide
                CALL editcolor(curcolor, pcolors(), pal&(), currentpalette)
                CALL mouseshow
        END IF

RETURN

leftbutton:
thisclick! = TIMER
IF ((thisclick! - lastclick!) > .1 AND (thisclick! - lastclick!) < .155) THEN
doubleclick = yes
END IF
lastclick! = thisclick!
RETURN

quit:
SYSTEM

Downcolor:

IF curcolor > 0 THEN
PRESET (curcolor, 0), 0
PRESET (curcolor, 9), 0
curcolor = curcolor - 1
COLOR 255
LOCATE 22, 3: PRINT "Current Color"; curcolor; "  "
LINE (261, 1)-(318, 8), curcolor, BF
COLOR curcolor
PRESET (curcolor, 0), 255
PRESET (curcolor, 9), 255
END IF
RETURN

Upcolor:

IF curcolor < 255 THEN
PRESET (curcolor, 0), 0
PRESET (curcolor, 9), 0
curcolor = curcolor + 1
COLOR 255
LOCATE 22, 3: PRINT "Current Color"; curcolor; "  "
LINE (261, 1)-(318, 8), curcolor, BF
COLOR curcolor
PRESET (curcolor, 0), 255
PRESET (curcolor, 9), 255
END IF
RETURN

UpPalette:

IF currentpalette < maxpals - 1 THEN
currentpalette = currentpalette + 1
ELSE
currentpalette = 0
END IF

COLOR 255
LOCATE 3, 1: PRINT "Palette:"; filen$(currentpalette) + "       "
PALETTE USING pal&(0, currentpalette)                      ' Change the palette to the first one
                 'starting with first color, the first palette

RETURN
DownPalette:
IF currentpalette > 0 THEN
currentpalette = currentpalette - 1
ELSE
currentpalette = maxpals - 1
END IF

COLOR 255
LOCATE 3, 1: PRINT "Palette:"; filen$(currentpalette) + "       "
PALETTE USING pal&(0, currentpalette)                      ' Change the palette to the first one
                 'starting with first color, the first palette

RETURN
errorhandler:

errnum = ERR
SELECT CASE errnum
CASE 52 'Bad file name or number
errortimes = errortimes + 1
CASE 53 'File not found

CASE 61 'Disk full

CASE 64 'Bad file name
errortimes = errortimes + 1
RESUME NEXT
CASE 71 'Disk not ready

CASE 76 'Path not found
LOCATE 6, 10: PRINT "Path not found.  Try a different path"
DO: LOOP WHILE INKEY$ = ""
LOCATE 6, 10: PRINT "                                     "
errnum = 76
RESUME NEXT

CASE ELSE
PRINT "Error "; errnum; " occured."
PRINT "Program will terminate."
DO: LOOP WHILE INKEY$ = ""
SYSTEM
END SELECT


' 1       NEXT without FOR           º  37      Argument-count mismatch
' 2       Syntax error               º  38      Array not defined
' 3       RETURN without GOSUB       º  40      Variable required
' 4       Out of DATA                º  50      FIELD overflow
' 5       Illegal function call      º  51      Internal error
' 6       Overflow                   º  52      Bad file name or number
' 7       Out of memory              º  53      File not found
' 8       Label not defined          º  54      Bad file mode
' 9       Subscript out of range     º  55      File already open
' 10      Duplicate definition       º  56      FIELD statement active
' 11      Division by zero           º  57      Device I/O error
' 12      Illegal in direct mode     º  58      File already exists
' 13      Type mismatch              º  59      Bad record length
' 14      Out of string space        º  61      Disk full
' 16      String formula too complex º  62      Input past end of file
' 17      Cannot continue            º  63      Bad record number
' 18      Function not defined       º  64      Bad file name
' 19      No RESUME                  º  67      Too many files
' 20      RESUME without error       º  68      Device unavailable
' 24      Device timeout             º  69      Communication-buffer overflow
' 25      Device fault               º  70      Permission denied
' 26      FOR without NEXT           º  71      Disk not ready
' 27      Out of paper               º  72      Disk-media error
' 29      WHILE without WEND         º  73      Feature unavailable
' 30      WEND without WHILE         º  74      Rename across disks
' 33      Duplicate label            º  75      Path/File access error
' 35      Subprogram not defined     º  76      Path not found


'"chroma.pal" is a file I did not create.

'
'
'
'cls: for i = 0 to 255:r = pcolors(i,1,0):g = pcolors(i,2,0):b = pcolors(i, 3,0):line (i,r)-step(1,1),160,b:line (i,g+63)-step(1,1),100,b:line (i,b+130)-step(1,1),50,b:next i
'
'
'
'
'
'
'
'

REM $STATIC
SUB editcolor (curcolor, pcolors(), pal&(), currentpalette)
x2 = 248: x1 = 40: y2 = 129: y1 = 20
planes = 8: bits = 1
size = 4 + INT(((x2 - x1 + 1) * (bits) + 7) / 8) * planes * (y2 - y1 + 1)
DIM editbox(size)
GET (40, 20)-(248, 129), editbox(0)
LINE (40, 20)-(248, 129), 0, BF
RESTORE box
FOR i = 1 TO 14
READ j$
LOCATE 2 + i, 6: PRINT j$
NEXT i

f = curcolor
restart:
LINE (69, 53)-(106, 115), f, BF'curcolor(3)
LINE (261, 1)-(318, 8), f, BF
COLOR 255
FOR i = 1 TO 3
LOCATE 5 + i * 2, 24: PRINT CINT((pcolors(f, i, currentpalette) / 63 * 100))
LOCATE 5 + i * 2, 24: PRINT "³"
LOCATE 5 + i * 2, 28: PRINT "³"
NEXT i

COLOR 15
LOCATE 7, 17: PRINT "RED"
changecolor = 1 'red is being changed

CALL mouseshow

COLOR 255
LOCATE 5, 14: PRINT f; "  "

DO
        DO
                q = zx%: w = zy%: leftcheck = lb%: rightcheck = rb%
              
                CALL mousestatus(lb%, rb%, zx%, zy%)
              
                choice$ = INKEY$
                zx% = zx% \ 2
        LOOP WHILE zx% = q AND zy% = w AND lb% = NOT -1 AND rightcheck = NOT -1

        IF zx% <> q OR zy% <> w THEN
        CALL mousehide
        COLOR 255
        LOCATE 22, 3: PRINT "Current Color"; curcolor; " "
        LOCATE 23, 3: PRINT "Color"; POINT(zx%, zy%); "  "
        CALL mouseshow
        END IF

IF lb% = -1 AND first <> yes THEN
first = yes
a& = TIMER
END IF

IF lb% <> -1 THEN
first = no
ELSE
B& = TIMER
END IF

h = 500 - ((B& - a&) * 5 ^ 3)

IF h < 0 THEN h = 0

FOR k = 1 TO h: NEXT k



IF lb% = -1 THEN
COLOR 255
SELECT CASE zx%
CASE 70 TO 80
        IF zy% > 39 AND zy% < 47 THEN
        IF f > 0 THEN f = f - 1
        CALL mousehide
        GOTO restart
        END IF
CASE 94 TO 104
        IF zy% > 39 AND zy% < 47 THEN
        IF f < 255 THEN f = f + 1
        CALL mousehide
        GOTO restart
        END IF
CASE 129 TO 177
        SELECT CASE zy%
        CASE 44 TO 59   'RED
                CALL mousehide
                SELECT CASE changecolor
                CASE 1: COLOR 255: LOCATE 7, 17: PRINT "RED"
                CASE 2: COLOR 255: LOCATE 9, 17: PRINT "GREEN"
                CASE 3: COLOR 255: LOCATE 11, 17: PRINT "BLUE"
                END SELECT
                COLOR 15: LOCATE 7, 17: PRINT "RED"
                changecolor = 1
                CALL mouseshow
        CASE 60 TO 75  'GREEN
                CALL mousehide
                SELECT CASE changecolor
                CASE 1: COLOR 255: LOCATE 7, 17: PRINT "RED"
                CASE 2: COLOR 255: LOCATE 9, 17: PRINT "GREEN"
                CASE 3: COLOR 255: LOCATE 11, 17: PRINT "BLUE"
                END SELECT
                COLOR 15: LOCATE 9, 17: PRINT "GREEN"
                changecolor = 2
                CALL mouseshow
        CASE 76 TO 92  'BLUE
                CALL mousehide
                SELECT CASE changecolor
                CASE 1: COLOR 255: LOCATE 7, 17: PRINT "RED"
                CASE 2: COLOR 255: LOCATE 9, 17: PRINT "GREEN"
                CASE 3: COLOR 255: LOCATE 11, 17: PRINT "BLUE"
                END SELECT
                COLOR 15: LOCATE 11, 17: PRINT "BLUE"
                changecolor = 3
                CALL mouseshow
        CASE 100 TO 116  'ACCEPT
         CALL mousehide
         PUT (40, 20), editbox(0), PSET
         ERASE editbox
         LINE (261, 1)-(318, 8), f, BF
         PRESET (curcolor, 0), 0
         PRESET (curcolor, 9), 0
         PRESET (f, 0), 255
         PRESET (f, 9), 255
         curcolor = f
         EXIT SUB
   
   
        END SELECT
CASE 185 TO 193
        IF zy% > 23 AND zy% < 34 THEN 'decrease
               
                IF pcolors(f, changecolor, currentpalette) > 0 THEN
                        pcolors(f, changecolor, currentpalette) = pcolors(f, changecolor, currentpalette) - 1
                        COLOR 255
                        LOCATE 5 + changecolor * 2, 24: PRINT CINT((pcolors(f, changecolor, currentpalette) / 63) * 100)
                        LOCATE 5 + changecolor * 2, 24: PRINT "³"
                        LOCATE 5 + changecolor * 2, 28: PRINT "³"
                        colornumber# = 65536 * pcolors(f, 3, currentpalette) + 256 * pcolors(f, 2, currentpalette) + pcolors(f, 1, currentpalette)
                        PALETTE f, colornumber#
                        LINE (69, 105)-(106, 115), f, BF
                END IF
        END IF
CASE 194 TO 216
        SELECT CASE zy%
        CASE 88 TO 119   'RED
       
        CASE 120 TO 151  'GREEN
       
        CASE 152 TO 183  'BLUE
       
        END SELECT

CASE 217 TO 225
        IF zy% > 23 AND zy% < 34 THEN 'increase
               
                IF pcolors(f, changecolor, currentpalette) < 63 THEN
                        pcolors(f, changecolor, currentpalette) = pcolors(f, changecolor, currentpalette) + 1
                        COLOR 255
                        LOCATE 5 + changecolor * 2, 24: PRINT CINT((pcolors(f, changecolor, currentpalette) / 63) * 100)
                        LOCATE 5 + changecolor * 2, 24: PRINT "³"
                        LOCATE 5 + changecolor * 2, 28: PRINT "³"
                        colornumber# = 65536 * pcolors(f, 3, currentpalette) + 256 * pcolors(f, 2, currentpalette) + pcolors(f, 1, currentpalette)
                        pal&(f, currentpalette) = colornumber#
                        PALETTE f, colornumber#
                        LINE (69, 105)-(106, 115), f, BF
                END IF

        END IF
END SELECT

IF zx% > 188 AND zx% < 234 THEN
IF zy% > 100 AND zy% < 116 THEN
'reset the color
FOR i = 1 TO 3

pcolors(f, i, currentpalette) = pcolors(f, i, defaultppalette)
NEXT i
pal&(f, currentpalette) = pal&(f, defaultppalette)
PALETTE f, pal&(f, currentpalette)

FOR i = 1 TO 3
IF pcolors(f, i, currentpalette) = 0 THEN
pcolors(f, i, currentpalette) = 32
LOCATE 5 + i * 2, 25: PRINT " ? "
ELSE
LOCATE 5 + i * 2, 24: PRINT CINT((pcolors(f, i, currentpalette) / 63 * 100))
LOCATE 5 + i * 2, 24: PRINT "³"
LOCATE 5 + i * 2, 28: PRINT "³"
END IF
NEXT i

END IF
END IF

END IF
LOOP

'DATA "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"  '4
'DATA "³                  %   ³"
'DATA "³  COLOR          ÚÄÄÄ¿  ³"
'DATA "³  ÚÄÄÄÄ¿  RED    ³   ³  ³"
'DATA "³  ³    ³         ÃÄÄÄ´  ³"
'DATA "³  ³    ³  GREEN  ³   ³  ³"
'DATA "³  ³    ³         ÃÄÄÄ´  ³"
'DATA "³  ³    ³  BLUE   ³   ³  ³"
'DATA "³  ³    ³         ÀÄÄÄÙ  ³"
'DATA "³  ³    ³ ÚÄÄÄÄÄÄ¿       ³"
'DATA "³  ³    ³ ³ACCEPT³       ³"
'DATA "³  ÀÄÄÄÄÙ ÀÄÄÄÄÄÄÙ       ³"
'DATA "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"


END SUB

SUB loadfile (currentname$)

SCREEN 12
CLS

WIDTH 80, 60

'VIEW PRINT 1 TO 26


DO
CLS
errortimes = 0' set these values to 0.  They check to see if
totaltimes = 0' a good file name is found.
PRINT "Type the name of the drive directory where the pattern"
PRINT "("; ext$; ") file is found:(type CURRENT for current directory)"
INPUT drivedir$
IF drivedir$ = "esc" THEN EXIT SUB
IF UCASE$(drivedir$) = "CURRENT" THEN drivedir$ = ""
totaltimes = totaltimes + 1
FILES drivedir$ + "*" + ext$
'INPUT "Do you want to search again"; yn$
yn$ = "N" 'the line above is not really very useful.
IF UCASE$(yn$) = "N" OR UCASE$(yn$) = "NO" OR yn$ = "" THEN EXIT DO
LOOP

IF totaltimes > errortimes THEN      ' a good file was found
PRINT "Click on the name of the file to retrieve/merge:"
VIEW PRINT
ax = 0: ay = 0: ax2 = 640: ay2 = 350
SCREEN 12
CALL mouseshow
mousehidden = no
ELSE
EXIT SUB
END IF


DO

DO
        CALL mousestatus(lb%, rb%, zx%, zy%)
        choice$ = INKEY$
       
        IF choice$ <> CHR$(32) AND choice$ <> "" AND choice$ <> CHR$(13) AND choice$ <> CHR$(27) THEN
        IF LEN(name$) > 0 THEN
        IF ASC(LEFT$(name$, 1)) > 64 AND ASC(LEFT$(name$, 1)) < 91 THEN
        name$ = ""
        END IF
        END IF

        name$ = name$ + LCASE$(choice$)
        END IF
LOOP UNTIL lb% = -1 OR (choice$ = CHR$(13) OR choice$ = CHR$(27))

IF choice$ = CHR$(27) THEN
currentname$ = "ESC"
EXIT SUB
END IF

currentname$ = drivedir$ + name$ + ext$

IF lb% = -1 THEN
        name$ = ""
        row = zy% \ 8: column = zx% \ 8
        subcolumn = (column + 3) \ 18 + 1
        CALL mousehide
        checksee = SCREEN(row + 1, (subcolumn - 1) * 18 + 8 + 1)
        CALL mouseshow
        IF CHR$(checksee) = "." THEN
                name$ = ""
                CALL mousehide
                FOR i = 1 TO 8
                        letter = SCREEN(row + 1, (subcolumn - 1) * 18 + i)
                        IF CHR$(letter) <> CHR$(32) THEN
                                name$ = name$ + CHR$(letter)
                        END IF
                NEXT i
                CALL mouseshow
                LOCATE 55, 5: PRINT "If "; drivedir$ + name$ + ext$; " is the file you want to use then press enter.        "
                currentname$ = drivedir$ + name$ + ext$
        END IF
END IF
IF choice$ = CHR$(13) THEN
IF currentname$ <> "" THEN EXIT DO
END IF

LOOP
END SUB

SUB MATH (picture&(), numbers%(), t)



numbers%(4) = INT(picture&(t) / 16 ^ 6)
num& = picture&(t) - numbers%(4) * 16 ^ 6

numbers%(3) = INT(num& / 16 ^ 4)
num& = num& - numbers%(3) * 16 ^ 4

numbers%(2) = INT(num& / 16 ^ 2)
num& = num& - numbers%(2) * 16 ^ 2

numbers%(1) = INT(num&)
num& = num& - numbers%(1)

IF numbers%(4) < 0 THEN
numbers%(4) = 128 + INT((picture&(t) + 2147483647) / 16 ^ 6)
END IF


END SUB

SUB merge (currentpalette, wholescreen&(), pal&(), picture&(), colorsfrom(), numbers%())
mousehide

GET (0, 0)-(319, 199), wholescreen&(0)
COLOR 255
LOCATE 10, 10: PRINT "  Choose the name of the file to Merge  "
CALL loadfile(currentname$)
SCREEN 13
PUT (0, 0), wholescreen&(0), PSET
PALETTE USING pal&(0, currentpalette)

IF currentname$ = "ESC" THEN
mouseshow
EXIT SUB
END IF

e$ = currentname$
n = FREEFILE

OPEN e$ FOR BINARY AS n

'DIM tid(1) AS LONG
'GET (leftrepeat + 1, toprepeat + 1)-STEP(1, 1), tid&


FOR i = 0 TO 101
GET #n, , q&
picture&(i) = q&
NEXT i
CLOSE #n

PUT (leftrepeat + 1 + xsize, toprepeat + 1), picture&(0), PSET

FOR j = 0 TO 9
FOR i = 0 TO 9

colorsfrom(1) = POINT(left + i * 10 + 1, top + j * 10 + 1)
colorsfrom(2) = POINT(left + i * 10 + 6, top + j * 10 + 1)
colorsfrom(3) = POINT(left + i * 10 + 1, top + j * 10 + 6)
colorsfrom(4) = POINT(left + i * 10 + 6, top + j * 10 + 6)
'CALL MATH(picture&(), numbers%(), t)
nx = leftrepeat + xsize + (i * 2)
ny = toprepeat + (j * 2)

numbers%(1) = POINT(nx + 1, ny + 1)
numbers%(2) = POINT(nx + 2, ny + 1)
numbers%(3) = POINT(nx + 1, ny + 2)
numbers%(4) = POINT(nx + 2, ny + 2)
IF colorsfrom(1) = 0 THEN
LINE (left + i * 10 + 1, top + j * 10 + 1)-STEP(squaresize - 1, squaresize - 1), numbers%(1), BF
END IF
IF colorsfrom(2) = 0 THEN
LINE (left + i * 10 + 6, top + j * 10 + 1)-STEP(squaresize - 1, squaresize - 1), numbers%(2), BF
END IF
IF colorsfrom(3) = 0 THEN
LINE (left + i * 10 + 1, top + j * 10 + 6)-STEP(squaresize - 1, squaresize - 1), numbers%(3), BF
END IF
IF colorsfrom(4) = 0 THEN
LINE (left + i * 10 + 6, top + j * 10 + 6)-STEP(squaresize - 1, squaresize - 1), numbers%(4), BF
END IF

t = t + 1


NEXT
NEXT

GET (leftrepeat + 1, toprepeat + 1)-STEP(xsize - 1, ysize - 1), picture&(0)
PUT (leftrepeat + 1 + xsize, toprepeat + 1), picture&(0), PSET
CALL mouseshow

END SUB

REM $DYNAMIC
DEFINT A-Z
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

END SUB

REM $STATIC
DEFSNG A-Z
SUB openpalette (filename$, maxpals, pcolors(), pal&())
  
   DIM byte AS STRING * 1
  
   FOR i = 1 TO maxpals
   g = 0
   v$ = ""
   DO
   g = g + 1
   C = SCREEN(i + 5, g)
  
   IF CHR$(C) <> " " THEN
        v$ = v$ + CHR$(C)
   ELSE
          
           filen$(i - 1) = v$ + ".pal"
           EXIT DO
   END IF
   LOOP
  
   NEXT i


SCREEN 13
   
       
        FOR palnumber = 0 TO maxpals - 1
       
        num = FREEFILE
        OPEN filen$(palnumber) FOR BINARY AS num ' Open the file
       
        SELECT CASE LOF(num)                     ' Determine what to so based on the length of file
            CASE 768                             ' If the file is 768 bytes, its probably the right file
                PRINT ".";
                FOR index = 0 TO 255             ' Load each RGB value ( write me for tech info )
                   
                    GET #num, , byte: red = ASC(byte)
                    GET #num, , byte: green = ASC(byte)
                    GET #num, , byte: blue = ASC(byte)
                   
                    pcolors(index, 1, palnumber) = red
                    pcolors(index, 2, palnumber) = green
                    pcolors(index, 3, palnumber) = blue
                    pal&(index, palnumber) = red + green * &H100 + blue * &H10000
                   
                NEXT
                
                pal&(255, palnumber) = &H3F3F3F   ' Set color 255 to white for text & stuff
                CLOSE #num
                
            CASE 0                               ' File has no length, didn't exist
                CLOSE #num
               
                KILL filen$(palnumber)
                ERROR 53
            CASE ELSE                            ' File wasn't the right length
                CLOSE #num
                ERROR 100
        END SELECT
    NEXT
  
    


END SUB

SUB reproduce (px1, py1, px2, py2, picture&())
CALL mousehide

FOR i = 1 TO xsize
FOR j = 1 TO ysize
C = POINT(i * squaresize + left, j * squaresize + top)
x = i + leftrepeat
y = j + toprepeat
PRESET (x, y), C
NEXT j
NEXT i


GET (px1, py1)-(px2, py2), picture&(0)

FOR i = 1 TO xrepeats
FOR j = 1 TO yrepeats
PUT (leftrepeat + 1 + (i - 1) * xsize, toprepeat + 1 + (j - 1) * ysize), picture&(0), PSET
NEXT j
NEXT i



CALL mouseshow
END SUB

SUB RETRIEVE (size, picture&(), wholescreen&(), currentpalette, pal&(), filename$)
GET (0, 0)-(319, 199), wholescreen&(0)
CALL loadfile(currentname$)

SCREEN 13
PUT (0, 0), wholescreen&(0), PSET
PALETTE USING pal&(0, currentpalette)

IF currentname$ = "ESC" THEN
LOCATE 3, 2: PRINT "                              "
mouseshow
EXIT SUB
END IF


LOCATE 3, 2: PRINT " Opening                      "
filename$ = currentname$
n = FREEFILE


OPEN filename$ FOR BINARY AS n

FOR i = 0 TO size
GET #n, , picture&(i)
NEXT i
CLOSE #n

FOR i = 1 TO xrepeats
FOR j = 1 TO yrepeats
PUT (leftrepeat + 1 + (i - 1) * xsize, toprepeat + 1 + (j - 1) * ysize), picture&(0), PSET
NEXT j
NEXT i

FOR t = 1 TO xsize
FOR i = 1 TO ysize
C = POINT(leftrepeat + t, toprepeat + i)
LINE (left + (t - 1) * squaresize + 1, top + (i - 1) * squaresize + 1)-STEP(squaresize - 1, squaresize - 1), C, BF
                               
NEXT i
NEXT t

LOCATE 3, 2: PRINT "                              "
END SUB

SUB SAVE (px1, py1, px2, py2, picture&(), size, wholescreen&(), filename$)

CALL reproduce(px1, py1, px2, py2, picture&())
n = FREEFILE

LOCATE 3, 2: PRINT " Saving                       "

OPEN filename$ FOR BINARY AS n
                              
GET (px1, py1)-(px2, py2), picture&(0)
                              
FOR i = 0 TO size
PUT #n, , picture&(i)
NEXT i
                              
CLOSE #n
LOCATE 3, 2: PRINT "                              "
mouseshow
END SUB

SUB SaveAs (filename$, palfilename$)
'  (******** THIS SUBROUTINE IS FOR THE SAVE AS FUNCTION ***************
SCREEN 12
colornumber = 65536 * 50 + 256 * 40 + 40'30,35,45
PALETTE 0, colornumber
colornumber = 65536 * 1 + 256 * 1 + 1'30,35,45
PALETTE 15, colornumber
CLS
COLOR 15
mouseshow
LOCATE 14, 16: PRINT "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿         ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
LOCATE 15, 16: PRINT "³ SAVE PALETTE ³         ³ SAVE PATTERN ³"
LOCATE 16, 16: PRINT "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

DO
CALL mousestatus(lb%, rb%, zx%, zy%)
IF lb% = -1 THEN                          '48 - 57 and 65 to 90
IF zy% > 214 AND zy% < 247 THEN
SELECT CASE zx%
CASE 124 TO 243
end$ = ".PAL"
CASE 323 TO 442
end$ = ext$
END SELECT
END IF
END IF
LOOP WHILE end$ = ""
mousehide

DO
CLS
LOCATE 2, 10: PRINT "What is the name of the drive directory to find the file?"
LOCATE 3, 10: PRINT "example: C:\  or  B:\ or C:\SAVES or CURRENT for the current"
LOCATE 4, 10: INPUT "directory:"; drivedir$

IF drivedir$ = "" OR UCASE$(drivedir$) = "CURRENT" THEN EXIT DO
MKDIR drivedir$ + "\temp"
IF errnum <> 76 THEN
RMDIR drivedir$ + "\temp"
EXIT DO
END IF
LOOP


LOCATE 5, 10: PRINT "Enter the name of the new file:(no extension) "


DO
DO
C$ = INKEY$
LOOP WHILE C$ = ""

IF ASC(C$) = 8 THEN
IF LEN(name$) > 0 THEN
name$ = LEFT$(name$, LEN(name$) - 1)
LOCATE 8, 10 + LEN(name$): PRINT " "
END IF
END IF

IF (ASC(UCASE$(C$)) > 47 AND ASC(UCASE$(C$)) < 58) OR (ASC(UCASE$(C$)) > 64 AND ASC(UCASE$(C$)) < 91) THEN
IF LEN(name$) < 8 THEN
name$ = name$ + C$
LOCATE 8, 10: PRINT name$
END IF
END IF

IF C$ = CHR$(13) THEN

IF LEN(name$) > 0 THEN
EXIT DO
END IF
END IF

LOOP

IF UCASE$(drivedir$) = "CURRENT" THEN drivedir$ = ""

IF end$ = ".PAL" THEN
palfilename$ = UCASE$(name$ + end$)
palfilename$ = drivedir$ + palfilename$
ELSE
filename$ = UCASE$(name$ + end$)
filename$ = drivedir$ + filename$
END IF

END SUB

SUB savepalette (pcolors(), currentpalette)
n = FREEFILE
OPEN filen$(currentpalette) FOR BINARY AS n

FOR i = 0 TO 255
red$ = CHR$(pcolors(i, 1, currentpalette))
green$ = CHR$(pcolors(i, 2, currentpalette))
blue$ = CHR$(pcolors(i, 3, currentpalette))
PUT #n, , red$
PUT #n, , green$
PUT #n, , blue$
NEXT

CLOSE #n

END SUB

