DEFINT A-Z
           DECLARE SUB displaykeys (t%)
              DECLARE SUB checkkey (curkey%, keys$(), note%, lin%, mstart%, measure%, measurepos%, cursong$())
             DECLARE SUB fillboard ()
           DECLARE FUNCTION round! (dap%, num!)
              DECLARE SUB drawline (lin%, curpage!, cursong$())
              DECLARE SUB drawnote (staff%, column%, lin%, notevalue%, ledger&(), triplet%, whicht%, cursong$(), measure%, measurepos%)
              DECLARE SUB drawrest (notevalue%, column%, lin%, triplet%, whicht%, cursong$(), measure%, measurepos%)
              DECLARE SUB loadsong (cursong$(), whicht, triplet, curkey, curtempo, ts, ed)
              DECLARE SUB savesong (newname, cursong$(), whicht, triplet, curkey, curtempo, ts, ed)
        DECLARE SUB ToggleStaccato (measure, measurepos, cursong$(), mstart, lin)
             DECLARE SUB ToggleDot (measure%, measurepos%, cursong$(), lin%, mstart%)
       DECLARE SUB ToggleSharpFlat (lin%, mstart%, measure%, measurepos%, cursong$(), notevalue%)
            DECLARE SUB ToggleSlur (measure%, measurepos%, cursong$(), mstart%, lin%)
        DECLARE FUNCTION whichslur (cursong$(), staff, cursong$, measure, measurepos, row)
              DECLARE SUB playsong (cursong$(), start%, ed%, curtempo)
       DECLARE FUNCTION findstaff% (note%, octave%, thenote$)
        DECLARE FUNCTION findnote$ (measure%, measurepos%, cursong$())
            DECLARE SUB changefunc (notevalue%, boxx%, boxy%)
DECLARE FUNCTION findmeasurestart% (lin, measure, curpage!)
             DECLARE SUB mousehide ()
           DECLARE FUNCTION which% (notevalue%, staff)
      DECLARE FUNCTION findspaces% (curpage!, lin%, zx%)
             DECLARE SUB loadnotes ()
           DECLARE SUB mousestatus (lb%, rb%, zx%, zy%)
           DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
             DECLARE SUB mouseshow ()
       DECLARE FUNCTION MouseInit% ()
             DECLARE SUB staffdraw ()
CONST yes = -1, no = 1
CONST dmeasures = 200, dmeasurel = 18
CONST toolrow = 53, toolcolumn = 13
CONST showcrap = no, boxcolor = 12
CONST pagelimit = 10' for a 200 measure song
CONST ext$ = ".SNG" 'file extension name for saved song files.
CONST dap = 2'rounding for screw up
CONST fc = 9
CONST lscolumn = 43
'$DYNAMIC
DIM cursong$(dmeasures, dmeasurel)
DIM curpage AS SINGLE
DIM SHARED pics(9, 26) AS LONG
DIM SHARED ledger(50) AS LONG
DIM SHARED mouse$
DIM SHARED letter(7) AS STRING * 1
DIM SHARED filenotexist
DIM SHARED staffpiece(17508) AS LONG
DIM SHARED drawonly

DIM SHARED filename$(9)
DIM SHARED curfile

DIM keys$(11)
DIM keyname$(11)

keys$(1) = "G": keys$(2) = "D": keys$(3) = "A": keys$(4) = "E"
keys$(5) = "B": keys$(6) = "": keys$(7) = "F": keys$(8) = "C"
keys$(9) = "G": keys$(10) = "D": keys$(11) = "A"

keyname$(1) = "D-": keyname$(2) = "A-": keyname$(3) = "E-": keyname$(4) = "B-"
keyname$(5) = "F": keyname$(6) = "C": keyname$(7) = "G": keyname$(8) = "D"
keyname$(9) = "A": keyname$(10) = "E": keyname$(11) = "B"

letter$(0) = "C": letter$(1) = "B": letter$(2) = "A": letter$(3) = "G"
letter$(4) = "F": letter$(5) = "E": letter$(6) = "D": letter$(7) = "P"
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

ON ERROR GOTO errorhandler

   ' turn numlock on
   DEF SEG = 0
   POKE (1047), 32
   DEF SEG

SCREEN 12: WIDTH 80, 60
'cnumber& = 65536 * 63 + 256 * 48 + 36
'PALETTE 0, cnumber&

COLOR 9
PRINT "ÄÄÄ"
GET (0, 0)-(26, 7), ledger&(0)
PUT (0, 0), ledger&(0)


loadnotes
fillboard
boxx = 3: boxy = 1
staffdraw

mouseshow
notevalue = 4
curpage! = 0
ts = 100
curtempo = 120
curkey = 6      ' key of C
curfile = 1
filename$(1) = "UNTITLED"

DO
DO
     zq% = zx%: zw% = zy%
     CALL mousestatus(lb%, rb%, zx%, zy%)
     choice$ = INKEY$
     
     IF choice$ <> "" THEN
          SELECT CASE choice$
          CASE "P": lb% = yes: zx% = 434: zy% = 434
          CASE CHR$(27): SYSTEM
          CASE "2"
              
               IF curpage! < pagelimit THEN
               curpage! = curpage! + .2
               num! = curpage!: curpage! = round!(dap, num!)
               mousehide
               FOR i = 1 TO 4
               GET (18, 24 + (80 * i))-(565, 24 + (80 * (i + 1)) - 1), staffpiece&(0)
               PUT (18, 24 + (80 * (i - 1))), staffpiece&(0), PSET
               NEXT
               lin = 5
               CALL drawline(lin, curpage!, cursong$())
               mouseshow
               END IF
               
          CASE "8"
               IF curpage! > 0 THEN
               curpage! = curpage! - .2
               num! = curpage!: curpage! = round!(dap, num!)
               mousehide
               FOR i = 1 TO 4
               GET (18, 344 - (80 * i))-(565, 424 - (80 * i) - 1), staffpiece&(0)
               PUT (18, 424 - (80 * i)), staffpiece&(0), PSET
               NEXT
               lin = 1
               CALL drawline(lin, curpage!, cursong$())
               mouseshow
               END IF
          END SELECT
     END IF
LOOP WHILE choice$ = "" AND lb% = NOT yes AND rb% = NOT yes AND zq% = zx% AND zw% = zy%

row = zy% \ 8 + 1
column = zx% \ 8 + 1

IF zy% > 25 AND zy% < 426 AND zx% < 560 THEN
staff = ((((zy% - 2) \ 4 - 6) / 20) - INT(((zy% - 2) \ 4 - 6) / 20)) * 20
octave = 3 - (staff + 6) \ 7 + 1
note = ((staff / 7) - (staff \ 7)) * 7
lin = (zy% - 26) \ 80 + 1

IF zx% > 8 AND zx% < 600 THEN place = findspaces(curpage!, lin, zx%)

measure = (place + 16) \ 17
measurepos = place - ((measure - 1) * 17 + 1)
mstart = findmeasurestart(lin, measure, curpage!)

COLOR 4
LOCATE 1, 15: PRINT letter$(note)
IF measurepos = 0 THEN
beat$ = "       "
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
LOCATE 1, 30: PRINT measure
COLOR 9

IF showcrap = yes THEN
LOCATE 1, 1: PRINT "Row"; row
LOCATE 2, 1: PRINT "Column"; column
LOCATE 3, 1: PRINT "Notevalue"; notevalue
LOCATE 4, 1: PRINT "X:"; zx%
LOCATE 5, 1: PRINT "Y:"; zy%
LOCATE 6, 1: PRINT "Curpage:"; curpage!
LOCATE 7, 1: PRINT "               "
LOCATE 7, 1: PRINT cursong$(measure, measurepos)
LOCATE 8, 1: PRINT whicht
LOCATE 9, 1: PRINT "Staff"; staff; "Octave"; octave
LOCATE 10, 1: PRINT "Note"; note; "Letter "; letter$(note) + "   "
LOCATE 11, 1: PRINT "Place"; place
LOCATE 12, 1: PRINT "Measurepos"; measurepos
LOCATE 13, 1: PRINT "Measurestart"; mstart
END IF
END IF

IF rb% = -1 THEN
    
     lb% = no
     SELECT CASE row
     CASE 4 TO 53
    
     oldm = measurepos
     thenote$ = findnote$(measure, measurepos, cursong$())
    
     notelength = 16 / VAL(MID$(thenote$, 4, 2))
     tempvalue = VAL(MID$(thenote$, 4, 2))

     IF thenote$ <> "" AND (oldm - notelength < measurepos) THEN
         
          IF MID$(thenote$, 9, 1) <> " " THEN
          tn = notevalue
          IF MID$(thenote$, 9, 1) = "+" THEN notevalue = 50 ELSE notevalue = -50
          CALL ToggleSharpFlat(lin, mstart, measure, measurepos, cursong$(), notevalue)
          notevalue = tn
          END IF

          IF MID$(thenote$, 7, 1) <> "N" THEN
          IF MID$(thenote$, 7, 1) = "L" THEN
          CALL ToggleSlur(measure, measurepos, cursong$(), mstart, lin)
          ELSE
          CALL ToggleStaccato(measure, measurepos, cursong$(), mstart, lin)
          END IF
          END IF



          IF MID$(thenote$, 8, 1) = "P" THEN notelength = notelength * -1: tempvalue = tempvalue * -1
         
          dotlength = 0
          IF MID$(thenote$, 10, 1) = "." THEN dotlength = ABS(notelength) * 1 / 2
         
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
                         CALL drawnote(staff, column, lin, notevalue, ledger&(), triplet, whicht, cursong$(), measure, measurepos)
                    ELSE
                         CALL drawrest(notevalue, column, lin, triplet, whicht, cursong$(), measure, measurepos)
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
                    CALL drawnote(staff, column, lin, notevalue, ledger&(), triplet, whicht, cursong$(), measure, measurepos)
              
               ELSE
                    CALL drawrest(notevalue, column, lin, triplet, whicht, cursong$(), measure, measurepos)
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
       
     END IF
     END SELECT

END IF

IF lb% = -1 THEN

SELECT CASE row
CASE 4 TO 53
SELECT CASE ABS(notevalue)
CASE 50, -50'sharp,flat
B! = TIMER
     IF B! - A! > .25 THEN
          CALL ToggleSharpFlat(lin, mstart, measure, measurepos, cursong$(), notevalue)
          A! = TIMER
     END IF

CASE 100
     B! = TIMER
     IF B! - A! > .25 THEN
          CALL ToggleDot(measure, measurepos, cursong$(), lin, mstart)
          A! = TIMER
     END IF

CASE 101
     B! = TIMER
     IF B! - A! > .25 THEN
          CALL ToggleSlur(measure, measurepos, cursong$(), mstart, lin)
          A! = TIMER
     END IF

CASE 102
     B! = TIMER
     IF B! - A! > .25 THEN
          CALL ToggleStaccato(measure, measurepos, cursong$(), mstart, lin)
          A! = TIMER
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
                    IF measure < ts THEN ts = measure
                    IF measure > ed THEN ed = measure
                    IF notevalue < 0 THEN note = 7
                    IF tempvalue = -12 THEN note = 7

                    IF i > h THEN
                         cursong$(measure, i) = LCASE$(letter$(note))
                    ELSE
                         writevalue = notevalue
                         r$ = "  "
                         IF ABS(tempvalue) = 12 THEN writevalue = ABS(tempvalue): r$ = "t" + RIGHT$(STR$(whicht), 1)
                         MU$ = "MN"
                         cursong$(measure, i) = "O" + RIGHT$(STR$(octave), 1) + "L" + RIGHT$(STR$(ABS(writevalue)), 2) + MU$ + letter$(note) + "     " + r$
                    END IF
               NEXT i
              
              
               IF tempvalue <> 0 THEN notevalue = tempvalue
              
               column = h + mstart + 2
              
               IF notevalue > 0 THEN
                    tdone = no
                    CALL drawnote(staff, column, lin, notevalue, ledger&(), triplet, whicht, cursong$(), measure, measurepos)
               ELSE
                   
                    CALL drawrest(notevalue, column, lin, triplet, whicht, cursong$(), measure, measurepos)
               END IF
              
               IF curkey <> 6 THEN
               CALL checkkey(curkey, keys$(), note, lin, mstart, measure, measurepos, cursong$())
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
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), fc, B

SELECT CASE zx%
CASE (toolcolumn * 8 - 3) TO (toolcolumn * 8 + 27): notevalue = 1: boxx = 1
CASE (toolcolumn * 8 + 28) TO (toolcolumn * 8 + 59): notevalue = 2: boxx = 2
CASE (toolcolumn * 8 + 60) TO (toolcolumn * 8 + 91): notevalue = 4: boxx = 3
CASE (toolcolumn * 8 + 92) TO (toolcolumn * 8 + 123): notevalue = 8: boxx = 4
CASE (toolcolumn * 8 + 124) TO (toolcolumn * 8 + 155): notevalue = 16: boxx = 5
CASE (toolcolumn * 8 + 156) TO (toolcolumn * 8 + 187): notevalue = 100: boxx = 6
CASE (toolcolumn * 8 + 188) TO (toolcolumn * 8 + 219): notevalue = 12: boxx = 7
CASE (toolcolumn * 8 + 220) TO (toolcolumn * 8 + 251): notevalue = -12: boxx = 8
CASE (toolcolumn * 8 + 252) TO (toolcolumn * 8 + 283)           ' new tempo
DO
LOCATE 2, lscolumn: PRINT "          "; curtempo
LOCATE 2, lscolumn: INPUT "New Tempo"; curtempo
LOCATE 2, lscolumn: PRINT SPACE$(81 - lscolumn)
IF curtempo > 31 AND curtempo < 256 THEN EXIT DO
LOOP

CASE (toolcolumn * 8 + 284) TO (toolcolumn * 8 + 315)           'play song
ts = start
LOCATE 2, lscolumn: INPUT "Start Measure (beginning def.)"; start
IF start = 0 THEN start = ts

LOCATE 2, lscolumn: PRINT SPACE$(81 - lscolumn)

TE = ed
LOCATE 2, lscolumn: INPUT "   End Measure   (end default)"; ed
IF ed = 0 THEN ed = TE

LOCATE 2, lscolumn: PRINT SPACE$(81 - lscolumn)
CALL playsong(cursong$(), start, ed, curtempo)

CASE (toolcolumn * 8 + 316) TO (toolcolumn * 8 + 347)           ' key change

     t = yes
     CALL displaykeys(t)
     IF curkey < 7 THEN x = 589 ELSE x = 589 + 24
     y = ABS(6 - curkey) * 24 + 141
     LINE (x, y)-STEP(21, 21), boxcolor, B

     mouseshow
     DO
     DO
     CALL mousestatus(lb%, rb%, zx%, zy%)
     LOOP WHILE lb% <> yes

     IF (zx% > 588 AND zx% < 635) AND (zy% > 140 AND zy% < 282) THEN
     row = (zy% - 140) \ 24
     IF zx% < 611 THEN B = -1 ELSE B = 1
     curkey = 6 + row * B
     EXIT DO
     ELSE
     EXIT DO
     END IF
     LOOP
     mousehide
     t = no
     CALL displaykeys(t)

CASE (toolcolumn * 8 + 348) TO (toolcolumn * 8 + 379)           ' ?????????

END SELECT
boxy = 1
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), boxcolor, B
mouseshow

CASE 57
mousehide
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), fc, B

SELECT CASE zx%
CASE (toolcolumn * 8 - 3) TO (toolcolumn * 8 + 27): notevalue = -1: boxx = 1
CASE (toolcolumn * 8 + 28) TO (toolcolumn * 8 + 59): notevalue = -2: boxx = 2
CASE (toolcolumn * 8 + 60) TO (toolcolumn * 8 + 91): notevalue = -4: boxx = 3
CASE (toolcolumn * 8 + 92) TO (toolcolumn * 8 + 123): notevalue = -8: boxx = 4
CASE (toolcolumn * 8 + 124) TO (toolcolumn * 8 + 155): notevalue = -16: boxx = 5
CASE (toolcolumn * 8 + 156) TO (toolcolumn * 8 + 187): notevalue = 102: boxx = 6
CASE (toolcolumn * 8 + 188) TO (toolcolumn * 8 + 219): notevalue = 50: boxx = 7
CASE (toolcolumn * 8 + 220) TO (toolcolumn * 8 + 251): notevalue = -50: boxx = 8
CASE (toolcolumn * 8 + 252) TO (toolcolumn * 8 + 283): notevalue = 101: boxx = 9
CASE (toolcolumn * 8 + 284) TO (toolcolumn * 8 + 315)
     'load or save

     COLOR 4
     LOCATE 2, lscolumn: PRINT "ÚÄÄÄÄ¿    ÚÄÄÄÄ¿"
     LOCATE 3, lscolumn: PRINT "³LOAD³ or ³SAVE³"
     LOCATE 4, lscolumn: PRINT "ÀÄÄÄÄÙ    ÀÄÄÄÄÙ"
     mouseshow
     DO
     DO
     CALL mousestatus(lb%, rb%, zx%, zy%)
     LOOP WHILE lb% <> yes

     IF zy% > 11 AND zy% < 29 THEN
     SELECT CASE zx%
     CASE (lscolumn * 8 - 5) TO (lscolumn * 8 + 36)'load
          CALL loadsong(cursong$(), whicht, triplet, curkey, curtempo, ts, ed)
          LOCATE 2, lscolumn: PRINT "                "
          LOCATE 3, lscolumn: PRINT "                "
          LOCATE 4, lscolumn: PRINT "                "
          COLOR 4
          fill$ = filename$(curfile) + SPACE$(8 - LEN(filename$(curfile)))
          LOCATE 2, 31: PRINT fill$
          mouseshow
          EXIT DO
     CASE (lscolumn * 8 + 75) TO (lscolumn * 8 + 116) 'save
          newname = yes
          CALL savesong(newname, cursong$(), whicht, triplet, curkey, curtempo, ts, ed)
          LOCATE 2, lscolumn: PRINT "                "
          LOCATE 3, lscolumn: PRINT "                "
          LOCATE 4, lscolumn: PRINT "                "
          COLOR 4
          fill$ = filename$(curfile) + SPACE$(8 - LEN(filename$(curfile)))
          LOCATE 2, 31: PRINT fill$
          mouseshow
          EXIT DO
     END SELECT
     END IF
     LOOP
CASE (toolcolumn * 8 + 316) TO (toolcolumn * 8 + 347)           ' save
    
     IF filename$(curfile) = "UNTITLED" THEN newname = yes ELSE newname = no
     CALL savesong(newname, cursong$(), whicht, triplet, curkey, curtempo, ts, ed)
     mouseshow
CASE (toolcolumn * 8 + 348) TO (toolcolumn * 8 + 379)           ' close

END SELECT
boxy = 2
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), boxcolor, B
mouseshow
END SELECT
END IF
LOOP



DATA "ÉÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍËÍÍÍ»"
DATA "º   º   º   º   º   º   º   º   º   º   º   º   º"
DATA "ÌÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍÎÍÍÍ¹"
DATA "º   º   º   º   º   º   º   º   º   º   º   º   º"
DATA "ÈÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍÊÍÍÍ¼"

keys:
DATA "ÉÍÑÍÍÑÍÍ»"
DATA "º#³- ³+ º"
DATA "ÇÄÅÄÄÅÄÄ¶"
DATA "º0³C ³C º"
DATA "º ³ -³ -º"
DATA "ÇÄÅÄÄÅÄÄ¶"
DATA "º1³F ³G º"
DATA "º ³ B³ Fº"
DATA "ÇÄÅÄÄÅÄÄ¶"
DATA "º2³B-³D º"
DATA "º ³ E³ Cº"
DATA "ÇÄÅÄÄÅÄÄ¶"
DATA "º3³E-³A º"
DATA "º ³ A³ Gº"
DATA "ÇÄÅÄÄÅÄÄ¶"
DATA "º4³A-³E º"
DATA "º ³ D³ Dº"
DATA "ÇÄÅÄÄÅÄÄ¶"
DATA "º5³D-³B º"
DATA "º ³ G³ Aº"
DATA "ÈÍÏÍÍÏÍÍ¼"


staff:
DATA "                                                                       "
DATA "                                                                       "
DATA "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
DATA "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
DATA "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
DATA "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
DATA "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
DATA "                                                                       "
DATA "                                                                       "
DATA "                                                                       "



leftbox:

IF boxx > 1 THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), fc, B
boxx = boxx - 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN
rightbox:
IF boxx < 8 OR (boxx < 9 AND boxy = 2) THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), fc, B
boxx = boxx + 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN
upbox:
IF boxy > 1 AND boxx < 9 THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), fc, B
boxy = boxy - 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN
downbox:
IF boxy < 2 THEN
CALL mousehide: LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), fc, B
boxy = boxy + 1
CALL changefunc(notevalue, boxx, boxy)
END IF
RETURN

errorhandler:
e = ERR
IF e = 53 THEN filenotexist = yes
RESUME NEXT

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
CASE 6: notevalue = 102
CASE 7: notevalue = 50
CASE 8: notevalue = -50
CASE 9: notevalue = 101

END SELECT
END SELECT
LINE (toolcolumn * 8 + (boxx - 1) * 32 - 4, toolrow * 8 + (boxy - 1) * 16 + 3)-STEP(32, 16), boxcolor, B
mouseshow
END SUB

SUB checkkey (curkey, keys$(), note, lin, mstart, measure, measurepos, cursong$())

FOR i = curkey TO 6 STEP (1 * SGN(6 - curkey))
IF letter$(note) = keys$(i) THEN change = yes
NEXT

IF change = yes THEN
IF curkey > 6 THEN notevalue = 50 ELSE notevalue = -50
CALL ToggleSharpFlat(lin, mstart, measure, measurepos, cursong$(), notevalue)
END IF

END SUB

SUB displaykeys (t)
RESTORE keys
FOR i = 1 TO 21
READ j$

FOR r = 1 TO 9
r$ = MID$(j$, r, 1)
IF (i - 1) / 3 = (i - 1) \ 3 AND ASC(r$) < 128 THEN
COLOR 4
ELSE
COLOR 9
END IF
IF t = no THEN r$ = " "
LOCATE 15 + i, 71 + r: PRINT r$
NEXT r
NEXT

END SUB

SUB drawline (lin, curpage!, cursong$())
'figure out which measures to draw, and where.
mousehide

COLOR 9
RESTORE staff
FOR i = 1 TO 10
READ j$
LOCATE (lin - 1) * 10 + 3 + i, 1: PRINT j$
NEXT i

FOR measure = (curpage! * 20 + (lin - 1) * 4) + 1 TO (curpage! * 20 + (lin - 1) * 4) + 4
     FOR measurepos = 1 TO 16
          thenote$ = cursong$(measure, measurepos)
          IF LEN(thenote$) > 3 THEN
               notevalue = VAL(MID$(thenote$, 4, 2))
               IF MID$(thenote$, 8, 1) = "P" THEN notevalue = notevalue * -1
               IF triplet = no AND ABS(notevalue) = 12 THEN
                    whicht = 1
                    triplet = yes
               ELSEIF triplet = yes AND ABS(notevalue) = 12 THEN
                    whicht = whicht + 1
               END IF
              
               staff = findstaff(note, octave, thenote$)
               mstart = findmeasurestart(lin, measure, curpage!)
               column = measurepos + mstart + 2
              
               IF notevalue > 0 THEN
                    tdone = no
                    CALL drawnote(staff, column, lin, notevalue, ledger&(), triplet, whicht, cursong$(), measure, measurepos)
               ELSE
                    CALL drawrest(notevalue, column, lin, triplet, whicht, cursong$(), measure, measurepos)
               END IF
              
               drawonly = yes
               IF MID$(cursong$(measure, measurepos), 7, 1) <> "N" THEN
                   
                    IF MID$(cursong$(measure, measurepos), 7, 1) = "L" THEN
                         CALL ToggleSlur(measure, measurepos, cursong$(), mstart, lin)
                   
                    ELSEIF MID$(cursong$(measure, measurepos), 7, 1) = "S" THEN
                         CALL ToggleStaccato(measure, measurepos, cursong$(), mstart, lin)
                    END IF
               END IF
               IF MID$(cursong$(measure, measurepos), 10, 1) = "." THEN
                    CALL ToggleDot(measure, measurepos, cursong$(), lin, mstart)
               END IF
               IF MID$(cursong$(measure, measurepos), 9, 1) <> " " THEN
               tn = notevalue
               IF MID$(thenote$, 9, 1) = "+" THEN notevalue = 50 ELSE notevalue = -50
               
               CALL ToggleSharpFlat(lin, mstart, measure, measurepos, cursong$(), notevalue)
               notevalue = tn
               END IF

               IF whicht = 3 THEN triplet = no
               IF whicht = 3 THEN whicht = 0
               IF triplet = yes THEN ltp = place
          END IF
     NEXT
NEXT
drawonly = no
mouseshow
END SUB

SUB drawnote (staff, column, lin, notevalue, ledger&(), triplet, whicht, cursong$(), measure, measurepos)

     'IF notevalue = 4 THEN column = column + 1
     'IF notevalue = 1 THEN column = column + 2
     'IF notevalue = 2 THEN column = column + 1
IF staff < 3 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 4) * 8), ledger&(0)
IF staff < 1 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 3) * 8), ledger&(0)
IF staff > 13 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 10) * 8), ledger&(0)
IF staff > 15 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 11) * 8), ledger&(0)
IF staff > 17 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 12) * 8), ledger&(0)
IF staff > 19 THEN PUT ((column - 2) * 8, ((lin - 1) * 10 + 13) * 8), ledger&(0)

IF notevalue = 4 OR notevalue = 8 OR notevalue = 12 OR notevalue = 16 THEN
    
     PUT ((column - 1) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 9 - 6 * SGN(staff - 8.5)), XOR
     IF notevalue = 8 OR notevalue = 12 OR notevalue = 16 THEN
          PUT ((column - 1 + (1 * SGN(staff - 8.5))) * 8, (staff - 4 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, which(notevalue, staff)), XOR
     END IF
   
     IF (triplet = yes AND whicht = 2) OR MID$(cursong$(measure, measurepos), 15, 1) = "2" THEN
          PUT ((column - 1) * 8, (staff - 6 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 21), XOR
     END IF

ELSEIF notevalue = 1 OR notevalue = 2 THEN
     PUT ((column - 1) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, which(notevalue, staff)), XOR
END IF

IF notevalue <> 1 THEN
PUT ((column - 1) * 8, (staff - 2 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 10 - 6 * SGN(staff - 8.5)), XOR
PUT ((column - 1) * 8, (staff - 4 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 10 - 6 * SGN(staff - 8.5)), XOR
END IF

END SUB

SUB drawrest (notevalue, column, lin, triplet, whicht, cursong$(), measure, measurepos)

IF notevalue = -1 OR notevalue = -2 OR notevalue = -8 OR notevalue = -12 OR notevalue = -16 THEN
     IF notevalue = -1 THEN column = column + 7
     IF notevalue = -2 THEN column = column + 3
     PUT ((column - 1) * 8, 8 * 4 + 25 + (lin - 1) * 80), pics(0, which(notevalue, staff)), XOR
   
     IF (triplet = yes AND whicht = 2) OR MID$(cursong$(measure, measurepos), 15, 1) = "2" THEN
          PUT ((column - 1) * 8, 45 + (lin - 1) * 80), pics(0, 21), XOR
     END IF

ELSEIF notevalue = -4 THEN
     PUT ((column - 1) * 8, 7 * 4 + 25 + (lin - 1) * 80), pics(0, 10), XOR
     PUT ((column - 1) * 8, 9 * 4 + 25 + (lin - 1) * 80), pics(0, 11), XOR
END IF
END SUB

SUB fillboard

KEY OFF
COLOR 1
FOR i = 1 TO 5
READ j$
LOCATE toolrow + i, toolcolumn: PRINT j$
NEXT

PAINT (298, 427), fc, 1
LINE (toolcolumn * 8 + 60, toolrow * 8 + 3)-STEP(32, 16), boxcolor, B

COLOR 9

LOCATE 1, 1: PRINT "    The Note:"
LOCATE 2, 1: PRINT "The Position:"
LOCATE 1, 18: PRINT "The Measure:"
LOCATE 2, 18: PRINT "   The Song:          ( )"
COLOR 4
LOCATE 2, 31: PRINT "UNTITLED"
LOCATE 2, 41: PRINT "1"
COLOR 9
LOCATE toolrow + 2, toolcolumn + 34: PRINT "T"
LOCATE toolrow + 2, toolcolumn + 38: PRINT "P"
LOCATE toolrow + 4, toolcolumn + 34: PRINT "S"
LOCATE toolrow + 4, toolcolumn + 37: PRINT "L/S"

LOCATE toolrow + 2, toolcolumn + 42: PRINT "K"
LOCATE toolrow + 4, toolcolumn + 42: PRINT "S"
LOCATE toolrow + 4, toolcolumn + 46: PRINT "C"




DO
h = h + 1
t = t + 1
IF t = 4 THEN t = t + 1
PUT ((toolcolumn - 3) * 8 + h * 32, (toolrow + 1) * 8), pics(0, t), OR
LOOP WHILE h < 6
h = 0: t = 7
DO
h = h + 1
SELECT CASE h
CASE IS < 3, IS > 4
t = t + 1
PUT ((toolcolumn - 3) * 8 + (h - p) * 32, (toolrow + 3) * 8), pics(0, t), OR
CASE 3
t = t + 1
PUT ((toolcolumn - 3) * 8 + h * 32, (toolrow + 2.5) * 8), pics(0, t), OR
CASE 4
t = t + 1
p = 1
PUT ((toolcolumn - 3) * 8 + (h - p) * 32, (toolrow + 3.5) * 8), pics(0, t), OR
END SELECT
LOOP WHILE h < 6

PUT ((toolcolumn + 25) * 8, (toolrow + 1) * 8), pics(0, 21), OR
PUT ((toolcolumn + 25) * 8, (toolrow + 3) * 8), pics(0, 20), OR
PUT ((toolcolumn + 29) * 8, (toolrow + 3) * 8), pics(0, 19), OR
PUT ((toolcolumn + 28.5) * 8, (toolrow + 1) * 8), pics(0, 21), OR
PUT ((toolcolumn + 29.5) * 8, (toolrow + 1) * 8), pics(0, 12), OR
PUT ((toolcolumn + 21) * 8, (toolrow + 3) * 8), pics(0, 7), OR

END SUB

FUNCTION findmeasurestart (lin, measure, curpage!)

FOR i = 1 TO (lin + curpage! * 5) - 1
places = places + 68 '68 spaces on every line
NEXT
findmeasurestart = ((measure - 1) * 17 + 1) - places

END FUNCTION

FUNCTION findnote$ (measure, measurepos, cursong$())
DO
IF measurepos - G < 0 THEN EXIT DO

d$ = MID$(cursong$(measure, measurepos - G), 8, 1)
IF d$ = "" THEN d$ = " "
B = ASC(d$)

IF B < 96 AND B > 64 THEN
measurepos = measurepos - G
findnote$ = cursong$(measure, measurepos)
EXIT DO
END IF
G = G + 1
LOOP
END FUNCTION

FUNCTION findspaces (curpage!, lin, zx%)
FOR i = 1 TO (lin + curpage! * 5) - 1
places = places + 68
NEXT
findspaces = places + (zx% - 16) \ 8 + 1

END FUNCTION

FUNCTION findstaff (note, octave, thenote$)

octave = VAL(MID$(thenote$, 2, 1))
d$ = MID$(thenote$, 8, 1)

FOR i = 0 TO 7
IF d$ = letter$(i) THEN
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


CLOSE #1
END SUB

SUB loadsong (cursong$(), whicht, triplet, curkey, curtempo, ts, ed)
mousehide


DO
COLOR 4
LOCATE 2, lscolumn: PRINT " Type the name  "
LOCATE 3, lscolumn: PRINT " of the song to "
LOCATE 4, lscolumn: PRINT " load:          "
name$ = ""
length = 0
COLOR 13
DO
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""
choice$ = UCASE$(choice$)


IF choice$ = CHR$(8) THEN
IF length > 0 THEN
LOCATE 4, lscolumn + 6 + length: PRINT " "
length = length - 1
name$ = LEFT$(name$, length)
END IF
ELSE
IF length < 8 AND ((ASC(choice$) > 47 AND ASC(choice$) < 58) OR (ASC(choice$) > 64 AND ASC(choice$) < 91)) THEN
name$ = name$ + choice$
length = length + 1
LOCATE 4, lscolumn + 6 + length: PRINT choice$
END IF

IF length > 0 AND choice$ = CHR$(13) THEN
EXIT DO
END IF

END IF

LOOP
filename$(curfile) = name$
thename$ = name$ + ext$

filenotexist = no
OPEN thename$ FOR INPUT AS #1

IF filenotexist = no THEN
     EXIT DO
ELSE
     CLOSE #1
     KILL name$ + ext$
     COLOR 4
     LOCATE 2, lscolumn: PRINT " File did not   "
     LOCATE 3, lscolumn: PRINT " exist.  Try    "
     LOCATE 4, lscolumn: PRINT " another name   "
END IF
DO: LOOP WHILE INKEY$ = ""
LOOP

INPUT #1, curkey
INPUT #1, whicht
INPUT #1, triplet
INPUT #1, curtempo
INPUT #1, ts, ed
FOR measures = ts TO ed
FOR i = 1 TO 16
INPUT #1, cursong$(measures, i)
NEXT i
NEXT measures

CLOSE #1
curpage! = 0
FOR lin = 1 TO 5
CALL drawline(lin, curpage!, cursong$())
NEXT

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
note$ = MID$(cursong$(f, t), 1, 10)
IF MID$(cursong$(f, t), 8, 1) = "P" THEN note$ = "P" + MID$(cursong$(f, t), 4, 2)
f$ = ""

FOR h = 1 TO LEN(note$)
G$ = MID$(note$, h, 1)
IF G$ <> " " THEN
f$ = f$ + G$
END IF

NEXT h
note$ = f$
measure$ = measure$ + note$
END IF
NEXT

thesong$ = thesong$ + measure$

NEXT

PLAY "T" + STR$(curtempo) + thesong$

END SUB

FUNCTION round! (dap, num!)
IF INT(num! * 10 ^ dap) >= INT(num! * 10 ^ (dap - 1)) * 10 + 5 THEN
round = (INT(num! * 10 ^ (dap - 1) + 1)) / (10 ^ (dap - 1))
ELSE
round = (INT(num! * 10 ^ (dap - 1))) / (10 ^ (dap - 1))
END IF
END FUNCTION

SUB savesong (newname, cursong$(), whicht, triplet, curkey, curtempo, ts, ed)
mousehide

IF newname = yes THEN
     LOCATE 2, lscolumn: PRINT " Type the name  "
     LOCATE 3, lscolumn: PRINT " of the song to "
     LOCATE 4, lscolumn: PRINT " save:          "

     COLOR 13
     DO
     DO
     choice$ = INKEY$
     LOOP WHILE choice$ = ""
     choice$ = UCASE$(choice$)


     IF choice$ = CHR$(8) THEN
     IF length > 0 THEN
     LOCATE 4, lscolumn + 6 + length: PRINT " "
     length = length - 1
     name$ = LEFT$(name$, length)
     END IF
     ELSE
     IF length < 8 AND ((ASC(choice$) > 47 AND ASC(choice$) < 58) OR (ASC(choice$) > 64 AND ASC(choice$) < 91)) THEN
     name$ = name$ + choice$
     length = length + 1
     LOCATE 4, lscolumn + 6 + length: PRINT choice$
     END IF

     IF length > 0 AND choice$ = CHR$(13) THEN
     EXIT DO
     END IF

     END IF

     LOOP

     filename$(curfile) = name$
     'cursong$(50,18)
ELSE
     name$ = filename$(curfile)
END IF

thename$ = name$ + ext$
OPEN thename$ FOR OUTPUT AS #1



WRITE #1, curkey
WRITE #1, whicht
WRITE #1, triplet
WRITE #1, curtempo
WRITE #1, ts, ed
FOR measures = 1 TO ed
FOR i = 1 TO 16
WRITE #1, cursong$(measures, i)
NEXT i
NEXT measures

CLOSE #1


END SUB

SUB staffdraw

COLOR 9
FOR i = 1 TO 5
RESTORE staff
FOR h = 1 TO 10
READ j$
LOCATE (i - 1) * 10 + 3 + h, 1: PRINT j$
NEXT h
NEXT i

END SUB

SUB ToggleDot (measure, measurepos, cursong$(), lin, mstart)
     thenote$ = findnote$(measure, measurepos, cursong$())
    
     wontwork = no
     dot$ = "."
     fill$ = LCASE$(MID$(thenote$, 8, 1))
    
     IF thenote$ <> "" THEN
     notelength = 16 / VAL(MID$(thenote$, 4, 2))
     lengthrequired! = notelength / 2
     IF notelength = 16 OR notelength = 1 THEN wontwork = yes
     IF (measurepos + notelength) + lengthrequired! - 1 > 16 THEN wontwork = yes
     FOR i = (measurepos + notelength) TO (measurepos + notelength) + lengthrequired! - 1
     IF cursong$(measure, i) <> "" THEN wontwork = yes
     IF wontwork = yes THEN EXIT FOR
     NEXT
    
     IF drawonly <> yes THEN
     IF MID$(cursong$(measure, measurepos), 10, 1) = "." THEN
     dot$ = " "
     wontwork = no
     fill$ = ""
     END IF

     IF wontwork <> yes THEN
     MID$(cursong$(measure, measurepos), 10, 1) = dot$
     FOR i = (measurepos + notelength) TO (measurepos + notelength) + lengthrequired! - 1
     cursong$(measure, i) = fill$
     NEXT
     END IF

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

END SUB

SUB ToggleSharpFlat (lin, mstart, measure, measurepos, cursong$(), notevalue)
     thenote$ = findnote$(measure, measurepos, cursong$())
     IF thenote$ <> "" THEN
          notelength = 16 / VAL(MID$(thenote$, 4, 2))
          staff = findstaff(note, octave, thenote$)
          column = measurepos + mstart
          mousehide
        
          last$ = MID$(thenote$, 9, 1)
        
          IF drawonly <> yes THEN
          IF last$ = "+" THEN
               IF notevalue = -50 THEN
               MID$(cursong$(measure, measurepos), 9, 1) = " "
               PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 20), XOR
               END IF
          ELSEIF last$ = "-" THEN
               IF notevalue = 50 THEN
               MID$(cursong$(measure, measurepos), 9, 1) = " "
               PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, 19), XOR
               END IF
          END IF
          IF MID$(cursong$(measure, measurepos), 9, 1) = "+" OR MID$(cursong$(measure, measurepos), 9, 1) = "-" THEN
          MID$(cursong$(measure, measurepos), 9, 1) = " "
          ELSE
          IF notevalue = -50 THEN kind$ = "-" ELSE kind$ = "+"
       
          MID$(cursong$(measure, measurepos), 9, 1) = kind$
          END IF
          END IF

          IF notevalue = -50 THEN G = 19 ELSE G = 20
        
          PUT ((column) * 8, staff * 4 + 25 + (lin - 1) * 80), pics(0, G), XOR
        
          mouseshow
         
     END IF


END SUB

SUB ToggleSlur (measure, measurepos, cursong$(), mstart, lin)
     thenote$ = findnote$(measure, measurepos, cursong$())
   
     IF thenote$ <> "" AND MID$(thenote$, 8, 1) <> "P" THEN
     IF MID$(thenote$, 7, 1) = "S" THEN CALL ToggleStaccato(measure, measurepos, cursong$(), mstart, lin)
    
     nv = VAL(MID$(thenote$, 4, 2))
     counts = 16 / nv
   
     IF nv = 12 THEN
     SELECT CASE MID$(thenote$, 15, 1)
     CASE "1": counts = 1
     CASE "2": counts = 1
     CASE "3": counts = 2
     END SELECT
     END IF
   
     dm = measure
     dp = measurepos + counts
     IF dp > 16 THEN dm = dm + 1: dp = dp - 16
     IF LEN(cursong$(dm, dp)) > 3 THEN

     staff = findstaff(note, octave, thenote$)
     c = whichslur(cursong$(), staff, cursong$, measure, measurepos, row)
    
     mousehide
     column = measurepos + mstart + 2
     PUT ((column - 1) * 8, ABS(row) * 4 + 21 + (lin - 1) * 80), pics(0, c), XOR
   
     FOR i = 1 TO counts
          IF i = counts THEN
               IF row > 0 THEN
               wh = 24
               ELSEIF row < 0 THEN
               wh = 26
               END IF
          ELSE
               wh = 22
          END IF

          dm = measure
          dp = measurepos + i
          IF dp > 16 THEN
               dm = dm + 1
               dp = dp - 16
               PUT ((column) * 8, ABS(row) * 4 + 21 + (tl - 1) * 80), pics(0, 22), XOR
          END IF
         
          tm = measure: tp = measurepos
          measure = dm: measurepos = dp
          mstart = findmeasurestart(lin, measure, curpage!)

          tl = lin
          IF mstart > 68 THEN
              
               mstart = mstart - 68
               tl = lin + 1
          END IF
        
          column = measurepos + mstart + 2
          PUT ((column - 1) * 8, ABS(row) * 4 + 21 + (tl - 1) * 80), pics(0, wh), XOR
          measure = tm: measurepos = tp
        
     NEXT
   
     IF drawonly <> yes THEN
     IF LEN(STR$(row)) = 2 THEN row$ = " " + STR$(row) ELSE row$ = STR$(row)
     MID$(cursong$(measure, measurepos), 11, 3) = row$
    
     IF MID$(cursong$(measure, measurepos), 6, 2) = "MN" THEN
          MID$(cursong$(measure, measurepos), 6, 2) = "ML"
     ELSE
          MID$(cursong$(measure, measurepos), 11, 3) = "   "
          MID$(cursong$(measure, measurepos), 6, 2) = "MN"
     END IF
     END IF


     END IF
     END IF

     mouseshow

END SUB

SUB ToggleStaccato (measure, measurepos, cursong$(), mstart, lin)
    
     thenote$ = findnote$(measure, measurepos, cursong$())
     IF thenote$ <> "" AND MID$(thenote$, 8, 1) <> "P" THEN
     IF MID$(thenote$, 7, 1) = "L" THEN CALL ToggleSlur(measure, measurepos, cursong$(), mstart, lin)
     staff = findstaff(note, octave, thenote$)
     mousehide
     column = measurepos + mstart + 2
     PUT ((column - 1) * 8, (staff + 2 * SGN(staff - 8.5)) * 4 + 25 + (lin - 1) * 80), pics(0, 7), XOR
  
     IF drawonly <> yes THEN
     IF MID$(cursong$(measure, measurepos), 6, 2) = "MN" THEN
          MID$(cursong$(measure, measurepos), 6, 2) = "MS"
     ELSE
          MID$(cursong$(measure, measurepos), 11, 3) = "   "
          MID$(cursong$(measure, measurepos), 6, 2) = "MN"
     END IF
     END IF

     END IF

     mouseshow

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

IF (staff - 8.5) > 0 THEN  ' the note is below a B
whichslur = 25'4
row = staff + SGN(staff - 8.5) * 5
row = row * -1
ELSE                       ' the note is above an A
whichslur = 23'2
row = staff + SGN(staff - 8.5) * 5
END IF

'IF row > 0 THEN
'whichslur = 24'3
'ELSEIF row < 0 THEN
'whichslur = 26'5
'END IF

END FUNCTION

