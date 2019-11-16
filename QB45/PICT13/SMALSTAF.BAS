DEFINT A-Z
DECLARE FUNCTION whichslur (cursong$(), staff, cursong$, measure, measurepos, row)
DECLARE SUB playsong (cursong$(), start%, ed%, curtempo)
DECLARE FUNCTION findstaff% (note%, octave%, thenote$)
DECLARE FUNCTION findnote$ (measure%, measurepos%, cursong$())
DECLARE SUB changefunc (notevalue%, boxx%, boxy%)
DECLARE FUNCTION findmeasurestart% (measurepos(), spaceonline(), lin, measure)
DECLARE SUB mousehide ()
DECLARE FUNCTION which% (notevalue%, staff)
DECLARE FUNCTION findspaces% (lin%, spaceonline%(), measurepos%(), zx%)
DECLARE SUB loadnotes ()
DECLARE SUB mousestatus (lb%, rb%, zx%, zy%)
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE SUB mouseshow ()
DECLARE FUNCTION MouseInit% ()
DECLARE SUB staffdraw (measures(), cursong$(), measurepos(), spaceonline(), measuresspaces())
CONST yes = -1, no = 1
CONST dmeasures = 50, dmeasurel = 18
CONST toolrow = 54, toolcolumn = 17
CONST showcrap = no
'$DYNAMIC
DIM cursong$(dmeasures, dmeasurel)
DIM measures(dmeasures) ' to know how long each measure is
DIM measurepos(dmeasures) AS INTEGER
DIM measuresspaces(400)
DIM SHARED pics(9, 26) AS LONG
DIM SHARED ledger(50) AS LONG
DIM SHARED mouse$
DIM spaceonline(5)
DIM SHARED Letter(7) AS STRING * 1
curtempo = 120
Letter$(0) = "C": Letter$(1) = "B": Letter$(2) = "A": Letter$(3) = "G"
Letter$(4) = "F": Letter$(5) = "E": Letter$(6) = "D": Letter$(7) = "P"
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

KEY 15, CHR$(160) + "K"                      ' Left arrow
KEY 16, CHR$(160) + "M"                      ' Right arrow
KEY 17, CHR$(160) + "H"                      ' Up arrow
KEY 18, CHR$(160) + "P"                      ' Down arrow
ON KEY(15) GOSUB leftbox                  ' Set event trapping for the
ON KEY(16) GOSUB rightbox                       ' keys
ON KEY(17) GOSUB upbox
ON KEY(18) GOSUB downbox
KEY(15) ON                                   ' Turn on the keys
KEY(16) ON
KEY(17) ON
KEY(18) ON

SCREEN 12: WIDTH 80, 60
cnumber& = 65536 * 63 + 256 * 48 + 36
PALETTE 0, cnumber&

COLOR 9
PRINT "ฤฤฤ"
GET (0, 0)-(26, 7), ledger&
PUT (0, 0), ledger&

FOR i = 1 TO 5
READ j$
LOCATE toolrow + i, toolcolumn: PRINT j$
NEXT
CALL staffdraw(measures(), cursong$(), measurepos(), spaceonline(), measuresspaces())
loadnotes
LINE (132 + 64, 427)-STEP(32, 16), 4, B
boxx = 3: boxy = 1
LOCATE 1, 1: PRINT "    The Note:"
LOCATE 2, 1: PRINT "The Position:"
LOCATE 2, 22: PRINT "The Measure:"
LOCATE 55, 51: PRINT "T"
LOCATE 55, 55: PRINT "P"
LOCATE 57, 51: PRINT "S"

DO
h = h + 1
t = t + 1
IF t = 4 THEN t = t + 1
PUT ((toolcolumn - 3) * 8 + h * 32, toolrow * 8), pics(0, t), OR
LOOP WHILE h < 6
h = 0: t = 7
DO
h = h + 1
SELECT CASE h
CASE IS < 3, IS > 4
t = t + 1
PUT ((toolcolumn - 3) * 8 + (h - p) * 32, (toolrow + 2) * 8), pics(0, t), OR
CASE 3
t = t + 1
PUT ((toolcolumn - 3) * 8 + h * 32, (toolrow + 1.5) * 8), pics(0, t), OR
CASE 4
t = t + 1
p = 1
PUT ((toolcolumn - 3) * 8 + (h - p) * 32, (toolrow + 2.5) * 8), pics(0, t), OR
END SELECT
LOOP WHILE h < 6

PUT ((toolcolumn + 25) * 8, (toolrow) * 8), pics(0, 21), OR
PUT ((toolcolumn + 25) * 8, (toolrow + 2) * 8), pics(0, 20), OR
PUT ((toolcolumn + 29) * 8, (toolrow + 2) * 8), pics(0, 19), OR
PUT ((toolcolumn + 28.5) * 8, (toolrow) * 8), pics(0, 21), OR
PUT ((toolcolumn + 29.5) * 8, (toolrow) * 8), pics(0, 12), OR
mouseshow
notevalue = 4
DO
DO
zq% = zx%: zw% = zy%
CALL mousestatus(lb%, rb%, zx%, zy%)
choice$ = INKEY$
IF UCASE$(choice$) = "P" THEN lb% = yes: zx% = 434: zy% = 434
IF choice$ = CHR$(27) THEN SYSTEM
LOOP WHILE choice$ = "" AND lb% = NOT yes AND rb% = NOT yes AND zq% = zx% AND zw% = zy%

row = zy% \ 8 + 1
column = zx% \ 8 + 1
IF showcrap = yes THEN
LOCATE 1, 1: PRINT "Row"; row
LOCATE 2, 1: PRINT "Column"; column
LOCATE 3, 1: PRINT "Notevalue"; notevalue
LOCATE 4, 1: PRINT "X:"; zx%
LOCATE 5, 1: PRINT "Y:"; zy%
END IF

IF zy% > 25 AND zy% < 426 THEN
staff = ((((zy% - 2) \ 4 - 6) / 20) - INT(((zy% - 2) \ 4 - 6) / 20)) * 20
octave = 3 - (staff + 6) \ 7 + 1
note = ((staff / 7) - (staff \ 7)) * 7
lin = (zy% - 26) \ 80 + 1
IF zx% > 8 AND zx% < 600 THEN place = findspaces(lin, spaceonline(), measurepos(), zx%)
measure = measuresspaces(place)
measurepos = place - measurepos(measuresspaces(place))
mstart = findmeasurestart(measurepos(), spaceonline(), lin, measure)

COLOR 4
LOCATE 1, 15: PRINT Letter$(note)
IF measurepos = 0 THEN
beat$ = "        "
ELSE

beat! = (measurepos - 1) / 4 + 1
frac! = beat! - INT(beat!)
fstn = frac! * 4
secn = 4
frac$ = "    "
IF fstn <> 0 THEN
     IF fstn = 2 THEN : fstn = 1: secn = 2
     frac$ = STR$(fstn) + "/" + RIGHT$(STR$(secn), 1)

END IF
beat$ = STR$(INT(beat!)) + frac$
END IF
LOCATE 2, 14: PRINT beat$
LOCATE 2, 34: PRINT measure
COLOR 9

LOCATE 3, 1: PRINT whicht
LOCATE 4, 1: PRINT "             "
LOCATE 4, 1: PRINT cursong$(measure, measurepos)

IF showcrap = yes THEN
LOCATE 1, 50: PRINT "Staff"; staff; "Octave"; octave
LOCATE 2, 50: PRINT "Note"; note; "Letter "; Letter$(note) + "   "
LOCATE 12, 1: PRINT "Lin"; lin; "Spaceonline(lin)"; spaceonline(lin)
LOCATE 13, 1: PRINT "Place"; place
LOCATE 15, 1: PRINT "Measurepos"; measurepos
LOCATE 17, 1: PRINT "Measurestart"; mstart
END IF
END IF

IF rb% = -1 THEN
    
     lb% = no
     SELECT CASE row
     CASE 4 TO 53
     thenote$ = findnote$(measure, measurepos, cursong$())
    
     IF thenote$ <> "" AND column <> lastcolumn THEN
         
          notelength = 16 / VAL(MID$(thenote$, 4, 2))
          tempvalue = VAL(MID$(thenote$, 4, 2))
          IF MID$(thenote$, 8, 1) = "P" THEN notelength = notelength * -1: tempvalue = tempvalue * -1
         
          dotlength = 0
          IF MID$(thenote$, 9, 1) = "." THEN dotlength = ABS(notelength) * 1 / 2
         
          staff = findstaff(note, octave, thenote$)
         
          column = measurepos + mstart + 2
          mousehide

          IF ABS(tempvalue) = 12 THEN
               ltp = place - 1
               leftone = VAL(MID$(cursong$(measure, measurepos - 1), 4, 2))
               IF leftone <> 12 THEN note$ = "" ELSE note$ = LCASE$(MID$(thenote$, 8, 1))
              
               u = measurepos
               DO
               
               IF cursong$(measure, u) = "" OR (ABS(VAL(MID$(cursong$(measure, u), 4, 2))) <> 12 AND LEN(cursong$(measure, u)) = 1) THEN
                    IF leftone <> 12 THEN
                    FOR i = 0 TO 3: cursong$(measure, measurepos + i) = "": NEXT i
                    triplet = no
                    whicht = 0
                    END IF
                    IF whicht <> 0 THEN whicht = whicht - 1
                    EXIT DO
               ELSE
                    whicht = 3
                    IF u > 1 THEN
                         IF MID$(cursong$(measure, u - 1), 4, 2) = "12" AND MID$(cursong$(measure, u - 2), 4, 2) <> "12" THEN
                         ' this note is in the middle of the triplet
                         whicht = 2
                              IF tempvalue > 0 THEN
                              '     PUT ((column - 1) * 8, (staff - 6 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 21), XOR
                              ELSE
                              '     PUT ((column - 1) * 8, 45 + (lin - 1) * 80), pics(0, 21), XOR
                              END IF
                         END IF
                    END IF
                    cursong$(measure, u) = note$
                    triplet = yes
                    kv = notevalue
                    notevalue = tempvalue
                    IF tempvalue > 0 THEN
                         GOSUB drawnote
                    ELSE
                         GOSUB drawrest
                    END IF
                    notevalue = kv

               END IF
               u = u + 1
               LOOP
          ELSE
          FOR i = measurepos TO measurepos + ABS(notelength) + dotlength - 1
          cursong$(measure, i) = ""
          NEXT
          
         
          tempvalue = notevalue
          notevalue = 16 / notelength
               IF notelength > 0 THEN
                    GOSUB drawnote
              
               ELSE
                    GOSUB drawrest
               END IF
         
          IF dotlength <> 0 THEN
          IF 16 / notelength = 2 OR 16 / notelength = 4 THEN column = column + 1
          IF 16 / notelength = 2 AND MID$(thenote$, 8, 1) = "P" THEN
          column = column + 3
          staff = 8
          END IF
          PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 7), XOR
          END IF
          END IF
         
          mouseshow
          notevalue = tempvalue
       lastcolumn = column
     END IF
     END SELECT

END IF

IF lb% = -1 THEN

SELECT CASE row
CASE 4 TO 53
SELECT CASE ABS(notevalue)
CASE 50, -50'sharp,flat

thenote$ = findnote$(measure, measurepos, cursong$())
b! = TIMER
     IF thenote$ <> "" AND column <> lastcolumn AND b! - a! > .25 THEN
          notelength = 16 / VAL(MID$(thenote$, 4, 2))
          staff = findstaff(note, octave, thenote$)
          column = measurepos + mstart
          mousehide
         
          last$ = MID$(thenote$, 10, 1)
         
          IF last$ = "+" THEN
               IF notevalue = -50 THEN
               MID$(cursong$(measure, measurepos), 10, 1) = " "
               PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 20), XOR
               END IF
          ELSEIF last$ = "-" THEN
               IF notevalue = 50 THEN
               MID$(cursong$(measure, measurepos), 10, 1) = " "
               PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 19), XOR
               END IF
          END IF

          IF notevalue = -50 THEN g = 19 ELSE g = 20
         
          PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, g), XOR
         
          IF MID$(cursong$(measure, measurepos), 10, 1) = "+" OR MID$(cursong$(measure, measurepos), 10, 1) = "-" THEN
          MID$(cursong$(measure, measurepos), 10, 1) = " "
          ELSE
          IF notevalue = -50 THEN kind$ = "-" ELSE kind$ = "+"
         
          MID$(cursong$(measure, measurepos), 10, 1) = kind$
          END IF
          mouseshow
          a! = TIMER
     END IF

CASE 100
     
     wontwork = no
     thenote$ = findnote$(measure, measurepos, cursong$())
     IF thenote$ <> "" THEN
     notelength = 16 / VAL(MID$(thenote$, 4, 2))
     lengthrequired! = notelength / 2
     IF notelength = 16 OR notelength = 1 THEN wontwork = yes
     IF (measurepos + notelength) + lengthrequired! - 1 > 16 THEN wontwork = yes
     FOR i = (measurepos + notelength) TO (measurepos + notelength) + lengthrequired! - 1
     IF cursong$(measure, i) <> "" THEN wontwork = yes
     IF wontwork = yes THEN EXIT FOR
     NEXT
     IF wontwork <> yes THEN
     MID$(cursong$(measure, measurepos), 9, 1) = "."
     FOR i = (measurepos + notelength) TO (measurepos + notelength) + lengthrequired! - 1
     cursong$(measure, i) = LCASE$(MID$(thenote$, 8, 1))
     NEXT
    
     column = measurepos + mstart + 2
     IF 16 / notelength = 2 OR 16 / notelength = 4 THEN column = column + 1
     IF 16 / notelength = 2 AND MID$(thenote$, 8, 1) = "P" THEN
     column = column + 3
     staff = 8
     END IF
     mousehide
     staff = findstaff(note, octave, thenote$)
     PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 7), XOR
     mouseshow
     END IF
     END IF
CASE 101
     thenote$ = findnote$(measure, measurepos, cursong$())
     IF thenote$ <> "" THEN
     staff = findstaff(note, octave, thenote$)
     c = whichslur(cursong$(), staff, cursong$, measure, measurepos, row)
     column = measurepos + mstart + 2
     PUT ((column) * 8, row * 4 + 25 + (lin - 1) * 80), pics(0, c), XOR
     IF LEN(STR$(row)) = 2 THEN row$ = " " + STR$(row) ELSE row$ = STR$(row)
     MID$(cursong$(measure, measurepos), 11, 3) = row$
    
     END IF
CASE ELSE
IF measurepos > 0 THEN
    
     'h = INT((measurepos - 1) / (16 / ABS(notevalue)))
     'h = (h) * (16 / ABS(notevalue)) + 1
     h = measurepos
     IF ABS(notevalue) = 1 THEN h = 1
     IF (triplet <> yes AND cursong$(measure, h) = "") OR (triplet = yes AND (place = ltp + 1 AND MID$(cursong$(measure, h - 1), 4, 2) = "12" AND MID$(cursong$(measure, h), 4, 2) <> "12")) THEN
          passed = yes
         
          IF triplet <> yes AND ABS(notevalue) = 12 THEN
          whicht = 1
          triplet = yes
          ELSEIF triplet = yes AND ABS(notevalue) = 12 THEN
          whicht = whicht + 1
          END IF

          tempvalue = 0
          IF whicht = 1 THEN SWAP tempvalue, notevalue: notevalue = 4
          IF whicht = 2 THEN SWAP tempvalue, notevalue: notevalue = 16
          IF whicht = 3 THEN SWAP tempvalue, notevalue: notevalue = 8
         
          IF (h - 1 + (16 / ABS(notevalue))) > 16 THEN passed = no
         
          IF passed = yes THEN
          IF (triplet = NOT yes AND passed = yes) OR (triplet = yes AND (whicht = 1 OR (whicht > 1 AND MID$(cursong$(measure, h - 1), 4, 2) = "12"))) THEN passed = yes ELSE passed = no
          FOR i = h TO (h - 1 + (16 / ABS(notevalue)))
          IF cursong$(measure, i) = "" OR (triplet = yes AND whicht > 1) THEN passed = yes ELSE passed = no
          IF passed = no THEN EXIT FOR
          NEXT i
          END IF

          IF whicht = 1 AND passed = no THEN
          triplet = no: whicht = 0
          END IF

          IF passed = yes THEN
               mousehide
               FOR i = h TO (h - 1 + (16 / ABS(notevalue)))'it shouldn't be minus 1
                    IF measure > ed THEN ed = measure
                    IF notevalue < 0 THEN note = 7
                    IF tempvalue = -12 THEN note = 7

                    IF i > h THEN
                         cursong$(measure, i) = LCASE$(Letter$(note))
                    ELSE
                         writevalue = notevalue
                         IF ABS(tempvalue) = 12 THEN writevalue = ABS(tempvalue)
                         MU$ = "MN"
                         cursong$(measure, i) = "O" + RIGHT$(STR$(octave), 1) + "L" + RIGHT$(STR$(ABS(writevalue)), 2) + MU$ + Letter$(note) + "     "
                    END IF
               NEXT i
              
              
               IF tempvalue <> 0 THEN notevalue = tempvalue
              
               IF column = lastcolumn THEN lastcolumn = 0
               IF showcrap = yes THEN LOCATE 16, 1: PRINT "da"; h
               column = h + mstart + 2
              
               IF notevalue > 0 THEN
                    tdone = no
                    GOSUB drawnote
               ELSE
                   
                    GOSUB drawrest
               END IF
               mouseshow
         
          

          IF whicht = 3 THEN triplet = no
          IF whicht = 3 THEN whicht = 0
         
          IF triplet = yes THEN ltp = place
         
          END IF
          IF ABS(tempvalue) = 12 THEN notevalue = tempvalue
     END IF
END IF
END SELECT
CASE 55
mousehide
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 0, B

SELECT CASE zx%
CASE 133 TO 163: notevalue = 1: boxx = 1
CASE 164 TO 195: notevalue = 2: boxx = 2
CASE 196 TO 227: notevalue = 4: boxx = 3
CASE 228 TO 259: notevalue = 8: boxx = 4
CASE 260 TO 291: notevalue = 16: boxx = 5
CASE 292 TO 323: notevalue = 100: boxx = 6
CASE 324 TO 355: notevalue = 12: boxx = 7
CASE 356 TO 387: notevalue = -12: boxx = 8
CASE 388 TO 419
DO
LOCATE 2, 38: INPUT "New Tempo"; curtempo
LOCATE 2, 38: PRINT "                        "
IF curtempo > 31 AND curtempo < 256 THEN EXIT DO
LOOP
CASE 420 TO 451
ts = start
LOCATE 2, 38: INPUT "Start Measure (beginning default)"; start
IF start = 0 THEN start = ts
LOCATE 2, 38: PRINT "                                        "
te = ed
LOCATE 2, 38: INPUT "      End Measure   (end default)"; ed
IF ed = 0 THEN ed = te
LOCATE 2, 38: PRINT "                                        "
CALL playsong(cursong$(), start, ed, curtempo)
END SELECT
boxy = 1
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 4, B
mouseshow

CASE 57
mousehide
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 0, B

SELECT CASE zx%
CASE 133 TO 163: notevalue = -1: boxx = 1
CASE 164 TO 195: notevalue = -2: boxx = 2
CASE 196 TO 227: notevalue = -4: boxx = 3
CASE 228 TO 259: notevalue = -8: boxx = 4
CASE 260 TO 291: notevalue = -16: boxx = 5
CASE 292 TO 323: boxx = 6
CASE 324 TO 355: notevalue = 50: boxx = 7
CASE 356 TO 387: notevalue = -50: boxx = 8
CASE 388 TO 419: notevalue = 101: boxx = 9
END SELECT
boxy = 2
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 4, B
mouseshow
END SELECT
END IF
LOOP



DATA "ษอออหอออหอออหอออหอออหอออหอออหอออหอออหอออป"
DATA "บ   บ   บ   บ   บ   บ   บ   บ   บ   บ   บ"
DATA "ฬอออฮอออฮอออฮอออฮอออฮอออฮอออฮอออฮอออฮอออน"
DATA "บ   บ   บ   บ   บ   บ   บ   บ   บ   บ   บ"
DATA "ศอออสอออสอออสอออสอออสอออสอออสอออสอออสอออผ"



drawnote:
     'IF notevalue = 4 THEN column = column + 1
     'IF notevalue = 1 THEN column = column + 2
     'IF notevalue = 2 THEN column = column + 1

IF staff < 3 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 4) * 8), ledger&
IF staff < 1 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 3) * 8), ledger&
IF staff > 13 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 10) * 8), ledger&
IF staff > 15 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 11) * 8), ledger&
IF staff > 17 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 12) * 8), ledger&
IF staff > 19 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 13) * 8), ledger&

IF notevalue = 4 OR notevalue = 8 OR notevalue = 12 OR notevalue = 16 THEN
     
     PUT ((column - 1) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 9 - 6 * SGN(staff - 8.5)), XOR
     IF notevalue = 8 OR notevalue = 12 OR notevalue = 16 THEN
          PUT ((column - 1 + (1 * SGN(staff - 8.5))) * 8, (staff - 4 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, which(notevalue, staff)), XOR
     END IF
    
     IF triplet = yes AND whicht = 2 THEN
          PUT ((column - 1) * 8, (staff - 6 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 21), XOR
     END IF

ELSEIF notevalue = 1 OR notevalue = 2 THEN
     PUT ((column - 1) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, which(notevalue, staff)), XOR
END IF

IF notevalue <> 1 THEN
PUT ((column - 1) * 8, (staff - 2 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 10 - 6 * SGN(staff - 8.5)), XOR
PUT ((column - 1) * 8, (staff - 4 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 10 - 6 * SGN(staff - 8.5)), XOR
END IF
RETURN

drawrest:
IF notevalue = -1 OR notevalue = -2 OR notevalue = -8 OR notevalue = -12 OR notevalue = -16 THEN
     IF notevalue = -1 THEN column = column + 7
     IF notevalue = -2 THEN column = column + 3
     PUT ((column - 1) * 8, 8 * 4 + 25 + (lin - 1) * 80), pics(0, which(notevalue, staff)), XOR
    
     IF triplet = yes AND whicht = 2 THEN
          PUT ((column - 1) * 8, 45 + (lin - 1) * 80), pics(0, 21), XOR
     END IF

ELSEIF notevalue = -4 THEN
     PUT ((column - 1) * 8, 7 * 4 + 25 + (lin - 1) * 80), pics(0, 10), XOR
     PUT ((column - 1) * 8, 9 * 4 + 25 + (lin - 1) * 80), pics(0, 11), XOR
END IF
RETURN

drawslur:






leftbox:

IF boxx > 1 THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 0, B
boxx = boxx - 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN
rightbox:
IF boxx < 8 OR (boxx < 9 AND boxy = 2) THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 0, B
boxx = boxx + 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN
upbox:
IF boxy > 1 AND boxx < 9 THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 0, B
boxy = boxy - 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN
downbox:
IF boxy < 2 THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 0, B
boxy = boxy + 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN

REM $STATIC
SUB changefunc (notevalue, boxx, boxy)

SELECT CASE boxy
CASE 1
SELECT CASE boxx
CASE 1: notevalue = 1
CASE 2: notevalue = 2
CASE 3: notevalue = 4
CASE 4: notevalue = 8
CASE 5: notevalue = 16
CASE 6: notevalue = 100
CASE 7: notevalue = 12
CASE 8: ntoevalue = -12
END SELECT
CASE 2
SELECT CASE boxx
CASE 1: notevalue = -1
CASE 2: notevalue = -2
CASE 3: notevalue = -4
CASE 4: notevalue = -8
CASE 5: notevalue = -16
CASE 7: notevalue = 50
CASE 8: notevalue = -50
CASE 9: notevalue = 101
END SELECT
END SELECT
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 - 5)-STEP(32, 16), 4, B
mouseshow
END SUB

FUNCTION findmeasurestart (measurepos(), spaceonline(), lin, measure)

FOR i = 1 TO lin - 1
places = places + spaceonline(i)
NEXT
findmeasurestart = measurepos(measure) - places

END FUNCTION

FUNCTION findnote$ (measure, measurepos, cursong$())
DO
IF measurepos - g < 0 THEN EXIT DO

d$ = MID$(cursong$(measure, measurepos - g), 8, 1)
IF d$ = "" THEN d$ = " "
b = ASC(d$)

IF b < 96 AND b > 64 THEN
measurepos = measurepos - g
findnote$ = cursong$(measure, measurepos)
EXIT DO
END IF
g = g + 1
LOOP
END FUNCTION

FUNCTION findspaces (lin, spaceonline(), measurepos(), zx%)
FOR i = 1 TO lin - 1
places = places + spaceonline(i)
NEXT
findspaces = places + (zx% - 16) \ 8 + 1

END FUNCTION

FUNCTION findstaff (note, octave, thenote$)

octave = VAL(MID$(thenote$, 2, 1))
d$ = MID$(thenote$, 8, 1)

FOR i = 0 TO 7
IF d$ = Letter$(i) THEN
note = i
EXIT FOR
END IF
NEXT i

IF d$ = "P" THEN
findstaff = 8
ELSE
note = note + 7: IF note > 7 THEN note = note - 7
findstaff = (3 - octave) * 7 + note
END IF

END FUNCTION

SUB loadnotes
OPEN "notepics.dat" FOR BINARY AS #1

FOR i = 1 TO 26
FOR j = 0 TO 9
GET #1, , v&
pics(j, i) = v&
NEXT j
NEXT i

'PUT (100, 100), pics(0, 3), PSET

'PUT (100, 200), pics(0, 2), PSET
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

SUB playsong (cursong$(), start, ed, curtempo)

FOR f = start TO ed
measure$ = ""
FOR t = 1 TO 16

IF LEFT$(cursong$(f, t), 1) = "O" THEN
note$ = cursong$(f, t)
IF MID$(cursong$(f, t), 8, 1) = "P" THEN note$ = "P" + MID$(cursong$(f, t), 4, 2)
measure$ = measure$ + note$
END IF
NEXT

thesong$ = thesong$ + measure$

NEXT

PLAY "T" + STR$(curtempo) + thesong$

END SUB

SUB staffdraw (measures(), cursong$(), measurepos(), spaceonline(), measuresspaces())
IF cursong$(1, 1) <> "" THEN
FOR i = 1 TO UBOUND(measures)
length = length + measures(i)
newsong = no
NEXT

ELSE
length = 350
newsong = yes
END IF


lines = length \ 80 + 1
curmeasure = 0
FOR i = 1 TO lines
linespaces = 0
curspace = 0
            newline = no
            FirstMeasureOnLine = yes
IF i > 1 THEN
totalspaces = totalspaces - 1
curmeasure = curmeasure - 1
END IF
            DO
                        totalspaces = 1 + totalspaces
                        linespaces = 1 + linespaces
                        curspace = 1 + curspace
                        
                       
                        IF curspace = measures(curmeasure) OR (newsong = yes AND (curspace - 1) / dmeasurel = (curspace - 1) \ dmeasurel) THEN ' a new measure
                        
                                    IF totalspaces > length THEN
                                    lastmeasure = yes
                                    END IF
                        newmeasure = yes                        'has been reached.
                        curmeasure = 1 + curmeasure
                       
                        IF newsong = yes THEN
                       
                        measurepos(curmeasure) = totalspaces
                        measures(curmeasure) = dmeasurel
                        curspace = 1
                        END IF
                        END IF
                       
                        IF newsong = yes THEN measuresspaces(totalspaces) = curmeasure
                        FOR j = 1 TO 5
                                    IF newmeasure = yes THEN ' draw measure lines
                                                IF FirstMeasureOnLine = yes THEN
                                                SELECT CASE j
                                                CASE 1: kind = 218
                                                CASE 2, 3, 4: kind = 195
                                                CASE 5: kind = 192
                                                END SELECT
                                                ELSE
                                                SELECT CASE j
                                                CASE 1: kind = 194
                                                CASE 2, 3, 4: kind = 197
                                                CASE 5: kind = 193
                                                END SELECT
                                                END IF
                                               
                                                IF 77 - (linespaces + (measures(curmeasure))) < 0 THEN 'this measure will not fit on the line
                                                SELECT CASE j
                                                CASE 1: kind = 191
                                                CASE 2, 3, 4: kind = 180
                                                CASE 5: kind = 217
                                                
                                                END SELECT
                                                newline = yes
                                                END IF
                                               
                                                IF lastmeasure = yes THEN
                                                            SELECT CASE j
                                                            CASE 1: kind = 183
                                                            CASE 2, 3, 4: kind = 182
                                                            CASE 5: kind = 189
                                                            END SELECT
                                                newline = yes
                                                END IF
                                    ELSE
                                                kind = 32
                                                SELECT CASE j
                                                CASE 1, 2, 3, 4, 5: kind = 196
                                                END SELECT

                                    END IF
                                               
                                                LOCATE (i - 1) * 10 + 5 + j, linespaces + 2: PRINT CHR$(kind)
                        NEXT j
                       
                        newmeasure = no
                        FirstMeasureOnLine = no
            LOOP WHILE newline <> yes
spaceonline(i) = linespaces - 1
IF lastmeasure = yes THEN EXIT FOR
NEXT

'draw lines
END SUB

FUNCTION which (notevalue, staff)
SELECT CASE notevalue
CASE 1: which = 1
CASE 2: IF staff > 8 THEN which = 2 ELSE which = 14
CASE 4: IF staff > 8 THEN which = 3 ELSE which = 15
CASE 8: IF staff > 8 THEN which = 5 ELSE which = 17
CASE 12: IF staff > 8 THEN which = 5 ELSE which = 17
CASE 16: IF staff > 8 THEN which = 6 ELSE which = 18
CASE -1: which = 8
CASE -2: which = 9
CASE -8: which = 12
CASE -12: which = 12
CASE -16: which = 13
END SELECT
END FUNCTION

FUNCTION whichslur (cursong$(), staff, cursong$, measure, measurepos, row)
dm = measure
dp = measurepos - 1
IF dp < 1 THEN dm = dm - 1: dp = 16

IF dm > 0 THEN
row = VAL(MID$(cursong$(dm, dp), 11, 3))
END IF

IF row = 0 THEN
IF (staff - 8.5) > 0 THEN  ' the note is below a B
whichslur = 25'4
row = staff + SGN(staff - 8.5) * 5
row = row * -1
ELSE                       ' the note is above an A
whichslur = 23'2
row = staff + SGN(staff - 8.5) * 5
END IF

ELSEIF row > 0 THEN
whichslur = 24'3
ELSEIF row < 0 THEN
whichslur = 26'5
END IF

END FUNCTION

