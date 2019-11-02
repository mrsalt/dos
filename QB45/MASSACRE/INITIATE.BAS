DECLARE SUB castle (x!, y!, q!)
DECLARE SUB shootstar ()
DECLARE SUB MarkLand (x!, y!, c!, players!, comland())
DECLARE SUB KimLand (c!, comland())
DECLARE SUB AwesomeLand (c!, comland())
DECLARE SUB startpicture ()
DECLARE SUB NumberOfPlayers (goagain, currentplayer, players, computers, scenario, skillevel(), movement(), names$(), soldiers(), knights(), catapults(), gold(), xposarmy(), yposarmy(), land(), playerscastles(), numofcastles(), homearmy(),  _
xposcastle(), yposcastle(), landposition())
DECLARE SUB SelectCastle (players!, computers!, playerscastles(), scenario!)
DECLARE SUB AskNames (computers!, playerscastles(), players!, names$())
DECLARE SUB LoadGame (comland(), scenario, skillevel(), movement(), names$(), players, soldiers(), knights(), catapults(), gold(), xposarmy(), yposarmy(), land(), playerscastles(), numofcastles(), homearmy(), xposcastle(), yposcastle(),  _
currentplayer, landposition())
CONST pi = 3.14592, yes = 1, no = 0
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22
' $INCLUDE: 'c:\qb45\massacre\types.bas'

SUB AskNames (computers, playerscastles(), players, names$())
CONST pi = 3.14592, yes = 1, no = 0
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22

CLS
SCREEN 9 '640 x 340
COLOR 8, 7
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT , "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
PRINT , "º                                            º"
PRINT , "º                                            º"
PRINT , "º                                            º"
PRINT , "º                                            º"
PRINT , "º                                            º"
PRINT , "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
row = 10: column = 17
DIM letter$(23)
        DO WHILE x <= players - 1
        x = 1 + x
        j = 0
        LOCATE 13, 27: PRINT "                                "
                DO
                'PRINT players
                    LOCATE row, column: PRINT "Player"; x; ", a brave and courageous knight"
                LOCATE row + 1, column: PRINT "such as thou must have more worth than a"
                LOCATE row + 2, column: PRINT "number.  Will you please give the name you"
                LOCATE row + 3, column: PRINT "wish to be known by?"
                      
                       
                        j = j + 1
                        IF j > 21 THEN j = 20
                        l$ = ""
                                DO
                                DO
                                l$ = INKEY$
                                LOOP WHILE l$ = ""
                                LOOP WHILE ASC(l$) = 0
                      
                        IF l$ <> CHR$(8) THEN
                        letter$(j) = l$
                        ELSE
                      
                        END IF

                        IF j >= 20 THEN
                        BEEP
                        ELSE
                        LOCATE 13, 37 + j: PRINT letter$(j)
                        END IF
                  '******| Checks for backspace  
                  IF l$ = CHR$(8) AND j = 0 THEN
                  LOCATE 13, 37: PRINT " "
                  END IF
                
                  IF l$ = CHR$(8) AND j > 1 THEN
                  LOCATE 13, (37 + j) - 1: PRINT "  "
                  letter$(j) = " "
                  j = j - 2
                 
                  LOCATE 13, 60: PRINT "º"
                  END IF
                
                  IF l$ = CHR$(13) THEN
                
             
                  IF j = 1 THEN
                  x = x - 1
                  EXIT DO
                  END IF

                  SELECT CASE x
                  CASE 1
                  FOR v = 1 TO j
                  names$(1) = names$(1) + letter$(v)
                  NEXT v
                  names$(x) = RTRIM$(names$(x))
                  names$(x) = LTRIM$(names$(x))
                  IF players = 1 THEN EXIT DO
                 
                  CASE 2
                  FOR v = 1 TO j
                  names$(2) = names$(2) + letter$(v)
                  NEXT v
                  names$(x) = RTRIM$(names$(x))
                  names$(x) = LTRIM$(names$(x))
                  IF players = 2 THEN EXIT DO
                
                  CASE 3
                  FOR v = 1 TO j
                  names$(3) = names$(3) + letter$(v)
                  NEXT v
                  names$(x) = RTRIM$(names$(x))
                  names$(x) = LTRIM$(names$(x))
                  IF players = 3 THEN EXIT DO
                
                  CASE 4
                  FOR v = 1 TO j
                  names$(4) = names$(4) + letter$(v)
                  NEXT v
                  names$(x) = RTRIM$(names$(x))
                  names$(x) = LTRIM$(names$(x))
                  IF players = 4 THEN EXIT DO
                
                  CASE 5
                  FOR v = 1 TO j
                  names$(5) = names$(5) + letter$(v)
                  NEXT v
                  names$(x) = RTRIM$(names$(x))
                  names$(x) = LTRIM$(names$(x))
                  IF players = 5 THEN EXIT DO
               
                  END SELECT
                  EXIT DO
                  END IF
                  LOOP
          LOOP

          FOR i = players + 1 TO computers + players
          IF computers = 0 THEN EXIT FOR
          RANDOMIZE TIMER
          title = CINT(RND * 30)
          SELECT CASE title
          CASE 1:  names$(i) = "Henri VIII"
          CASE 2:  names$(i) = "Louis XVI"
          CASE 3:  names$(i) = "Frederick 1"
          CASE 4:  names$(i) = "Frederick 2"
          CASE 5:  names$(i) = "Frederick 3"
          CASE 6:  names$(i) = "Peter the Great"
          CASE 7:  names$(i) = "Catherine the Great"
          CASE 8:  names$(i) = "Pope John Paul 2nd"
          CASE 9:  names$(i) = "Bob the Awesome ?"
          CASE 10: names$(i) = "Queen Elizabeth 1st"
          CASE 11: names$(i) = "Abraham Lincoln"
          CASE 12: names$(i) = "George Washington"
          CASE 13: names$(i) = "Mohamad Ali"
          CASE 14: names$(i) = "Benjamin Franklin"
          CASE 15: names$(i) = "Alexander the Great"
          CASE 16: names$(i) = "Rammese the 2nd"
          CASE 17: names$(i) = "Napolean Bonaparte"
          CASE 18: names$(i) = "Amadeus Mozart"
          CASE 19: names$(i) = "Attila the Hun"
          CASE 20: names$(i) = "Solomon the Wise"
          CASE 21: names$(i) = "Malcom X"
          CASE 22: names$(i) = "Herod"
          CASE 23: names$(i) = "Caesar Augustus"
          CASE 24: names$(i) = "Julius Caesar"
          CASE 25: names$(i) = "Cleopatra"
          CASE 26: names$(i) = "Commander Perry"
          CASE 27: names$(i) = "Dwight Eisenhower"
          CASE 28: names$(i) = "Franklin Roosevelt"
          CASE 29: names$(i) = "Montezuma"
          CASE 30: names$(i) = "Stalin"
          END SELECT
          NEXT i

END SUB

SUB LoadGame (comland(), scenario, skillevel(), movement(), names$(), players, soldiers(), knights(), catapults(), gold(), xposarmy(), yposarmy(), land(), playerscastles(), numofcastles(), homearmy(), xposcastle(), yposcastle(), currentplayer,  _
landposition())

CONST pi = 3.14592, yes = 1, no = 0
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22


DIM games$(9)
PALETTE
CLS
colornumber = 65536 * 1 + 256 * 1 + 1'30,35,45
PALETTE 15, colornumber
FOR i = 1 TO 9
   diskfile$ = "game" + CHR$(48 + i) + ".sve"
   OPEN diskfile$ FOR RANDOM AS #1
   CLOSE #1
NEXT i

CLS
COLOR 15
VIEW PRINT 7 TO 17
FILES "c:\qb45\massacre\game*.SVE"

'LOCATE 10, 1: PRINT "12345678901234567890123456789012345678901234567890123456789"
'LOCATE 11, 1: PRINT "         1         2         3         4         5"

FOR i = 1 TO 3
FOR h = 1 TO 72 STEP 18

        m = m + 1
        FOR j = 1 TO 12
            
                check = SCREEN(CSRLIN - 5 + i, h + j - 1)
                IF check <> 32 THEN
                games$(m) = games$(m) + CHR$(check)
                END IF
        NEXT j
      
NEXT h
NEXT i

CLS
SCREEN 13
column = 4
colornumber = 65536 * 63 + 256 * 63 + 63'30,35,45
PALETTE 0, colornumber
colornumber = 65536 * 1 + 256 * 1 + 1'30,35,45
PALETTE 15, colornumber
COLOR 8
LINE (0, 0)-(320, 200), , BF
COLOR 0
LINE (4 * 8, 5.5 * 8)-(35.5 * 8, 19.5 * 5), , BF
COLOR 15
COLOR 15
             '   |         5    1    5    2    5    3    5    |
LOCATE 5, column:  PRINT "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"'  5
LOCATE 6, column:  PRINT "º ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄ¿         º"'
LOCATE 7, column:  PRINT "º ³                 ³ ³         º"'
LOCATE 8, column:  PRINT "º ³                 ÃÄ´ÚÄÄÄÄÄÄ¿ º"'
LOCATE 9, column:  PRINT "º ³                 ³ ³³ LOAD ³ º"'
LOCATE 10, column: PRINT "º ³                 ³ ³ÀÄÄÄÄÄÄÙ º"' 1
LOCATE 11, column: PRINT "º ³                 ³ ³         º"'
LOCATE 12, column: PRINT "º ³                 ³ ³ÚÄÄÄÄÄÄ¿ º"'
LOCATE 13, column: PRINT "º ³                 ³ ³³DELETE³ º"'
LOCATE 14, column: PRINT "º ³                 ³ ³ÀÄÄÄÄÄÄÙ º"'
LOCATE 15, column: PRINT "º ³                 ³ ³         º"'  5
LOCATE 16, column: PRINT "º ³                 ÃÄ´ÚÄÄÄÄÄÄ¿ º"'
LOCATE 17, column: PRINT "º ³                 ³ ³³CANCEL³ º"'
LOCATE 18, column: PRINT "º ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÙÀÄÄÄÄÄÄÙ º"'
LOCATE 19, column: PRINT "º                               º"'
LOCATE 20, column: PRINT "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"' 2
COLOR 8
LINE (23, 32)-(26, 170), , BF
LINE (27, 25)-(300, 33), , BF        ' 
LINE (286, 25)-(310, 180), , BF      ' 
LINE (25, 157)-(300, 160), , BF
COLOR 4
LINE (45, 47)-(23 * 8, 55), , B
DIM title$(9)
FOR i = 1 TO 9
        diskfile$ = "game" + CHR$(48 + i) + ".sve"
        OPEN diskfile$ FOR INPUT AS #i
        IF LOF(i) > 100 THEN
                q = q + 1
                INPUT #i, title$
                LOCATE 6 + i, 7: PRINT title$
                title$(i) = title$
        END IF
        CLOSE #i
        LENGTH = 12
NEXT i
row = 1: column = 7: side = 1: fun = 1
DO
diskfile$ = "game" + CHR$(48 + row) + ".sve"
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""
choice$ = RIGHT$(choice$, 1)


SELECT CASE choice$
CASE CHR$(left)
        IF side = 2 AND editname = 0 THEN
        side = 1
        COLOR 15
        SELECT CASE fun
        CASE 1
                LOCATE 8, column + 20:  PRINT "ÚÄÄÄÄÄÄ¿"
                LOCATE 9, column + 20:  PRINT "³ LOAD ³"
                LOCATE 10, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"
        CASE 2
                LOCATE 12, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 13, column + 20: PRINT "³DELETE³"'
                LOCATE 14, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
    
        CASE 3
                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 17, column + 20: PRINT "³CANCEL³"'
                LOCATE 18, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
    
        END SELECT
        END IF
CASE CHR$(right)
        IF side = 1 AND editname = 0 THEN
        side = 2
        COLOR 4
        SELECT CASE fun
        CASE 1
                LOCATE 8, column + 20:  PRINT "ÚÄÄÄÄÄÄ¿"
                LOCATE 9, column + 20:  PRINT "³ LOAD ³"
                LOCATE 10, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"
        CASE 2
                LOCATE 12, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 13, column + 20: PRINT "³DELETE³"'
                LOCATE 14, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
     
        CASE 3
                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 17, column + 20: PRINT "³CANCEL³"'
                LOCATE 18, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
        END SELECT
        END IF
CASE CHR$(up)
        IF side = 1 THEN
                IF row = 1 THEN
                        BEEP
                ELSE
                   COLOR 0
                   LINE (45, row * 8 + 39)-(23 * 8, row * 8 + 47), , B
                   row = row - 1
                   COLOR 4
                   LINE (45, row * 8 + 39)-(23 * 8, row * 8 + 47), , B
                   END IF
        ELSE
                IF fun > 1 THEN
                        fun = fun - 1
                      
                        FOR i = 1 TO 2
                                IF i = 1 THEN
                                COLOR 4
                                ELSE
                                COLOR 15
                                END IF
                                SELECT CASE fun + i - 1
                                        CASE 1
                                                LOCATE 8, column + 20:  PRINT "ÚÄÄÄÄÄÄ¿"
                                                LOCATE 9, column + 20:  PRINT "³ LOAD ³"
                                                LOCATE 10, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"
                                        CASE 2
                                                LOCATE 12, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 13, column + 20: PRINT "³DELETE³"'
                                                LOCATE 14, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                    
                                        CASE 3
                                                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 17, column + 20: PRINT "³CANCEL³"'
                                                LOCATE 18, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                END SELECT
                        NEXT i
                ELSE
                        BEEP
                END IF
        END IF
CASE CHR$(down)
        IF side = 1 THEN
                IF row = 9 THEN
                        BEEP
                ELSE
                   COLOR 0
                   LINE (45, row * 8 + 39)-(23 * 8, row * 8 + 47), , B
                   row = row + 1
                   COLOR 4
                   LINE (45, row * 8 + 39)-(23 * 8, row * 8 + 47), , B
                   END IF
                 
        ELSE
                IF fun < 3 THEN
                        fun = fun + 1
                     
                        FOR i = 1 TO 2
                                IF i = 1 THEN
                                COLOR 15
                                ELSE
                                COLOR 4
                                END IF
                                SELECT CASE fun + i - 2
                                        CASE 1
                                                LOCATE 8, column + 20:  PRINT "ÚÄÄÄÄÄÄ¿"
                                                LOCATE 9, column + 20:  PRINT "³ LOAD ³"
                                                LOCATE 10, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"
                                        CASE 2
                                                LOCATE 12, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 13, column + 20: PRINT "³DELETE³"'
                                                LOCATE 14, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                   
                                        CASE 3
                                                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 17, column + 20: PRINT "³CANCEL³"'
                                                LOCATE 18, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                END SELECT
                        NEXT i
                ELSE
                        BEEP
                END IF
        END IF


CASE CHR$(enter)
        SELECT CASE side
        CASE 2
                SELECT CASE fun
                CASE 1 'load
                        IF title$(row) <> "" THEN
                        LOCATE 19, 6: PRINT " Loading .... "
                        diskfile$ = "game" + CHR$(48 + row) + ".sve"
                        OPEN diskfile$ FOR INPUT AS #1
                     
                        INPUT #1, title$(row), players, currentplayer, scenario
                     
                        FOR i = 1 TO 32
                        FOR j = 1 TO 24
                        INPUT #1, landposition(i, j)
                        INPUT #1, comland(i, j)
                        NEXT j
                        NEXT i
                     
                        FOR i = 1 TO players
                        INPUT #1, names$(i), soldiers(i), knights(i), catapults(i), gold(i), xposarmy(i), yposarmy(i), land(i), playerscastles(i), numofcastles(i), skillevel(i), movement(i)
                      
                     
                        FOR j = 1 TO 4
                        INPUT #1, xposcastle(j, i), yposcastle(j, i)
                        INPUT #1, homearmy(j, i)
                        NEXT j
                        NEXT i
                     
                     
                        CLOSE #1
                        LOCATE 19, 6: PRINT "               "
                        EXIT SUB
                        END IF
                CASE 2 'delete
                        diskfile$ = "game" + CHR$(48 + row) + ".sve"
                        title$(row) = ""
                        COLOR 0
                        LINE (48, row * 8 + 40)-(56 + 126, row * 8 + 49), , BF
                        COLOR 4
                        LINE (45, row * 8 + 39)-(23 * 8, row * 8 + 47), , B
                        KILL diskfile$
                        OPEN diskfile$ FOR RANDOM AS #2
                        CLOSE #2
                CASE 3 'cancel
                        COLOR 4
                        LOCATE 19, 6: PRINT "Are you sure?(Y/N)"
                        DO
                        DO
                        choice$ = INKEY$
                        LOOP WHILE choice$ = ""
                        choice$ = UCASE$(choice$)
                        SELECT CASE choice$
                        CASE "Y"
                                CLS
                                EXIT SUB
                        CASE "N"
                                LOCATE 19, 6: PRINT "                  "
                                EXIT DO
                        CASE ELSE
                                BEEP
                        END SELECT
                        LOOP
             
                END SELECT
        END SELECT
END SELECT


LOOP

END SUB

SUB NumberOfPlayers (goagain, currentplayer, players, computers, scenario, skillevel(), movement(), names$(), soldiers(), knights(), catapults(), gold(), xposarmy(), yposarmy(), land(), playerscastles(), numofcastles(), homearmy(), xposcastle(),  _
yposcastle(), landposition())
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22
SCREEN 12
CLS
COLOR 1
LINE (0, 210)-(650, 210)
PAINT (320, 320)
 colornumber = 65536 * 20 + 256 * 25 + 20
PALETTE 2, colornumber
COLOR 2
CIRCLE (640, 440), 200
PAINT (560, 420)
CIRCLE (640, 210), 100
PAINT (590, 220)
COLOR 0
LINE (680, 209)-(480, 100), , BF
COLOR 2
LINE (540, 210)-(640, 150)
PAINT (600, 200)
x = 620: y = 163: q = 4
CALL castle(x, y, q)
goagain = 0
        DO
        DO
        RANDOMIZE TIMER
        x = RND * 640
        y = RND * 208
        size = RND * 100
        LOOP WHILE x > 540 AND y > 150
        stars = stars + 1
        COLOR 15
        IF size < 35 THEN
        LINE (x, y)-(x, y)
        ELSE
        CIRCLE (x, y), 1
        END IF
        LOOP WHILE stars < 100
               
                LOCATE 1, 1: PRINT "How many valorous knights wish to play? (Press Enter to confirm)"
                LOCATE 3, 1: PRINT "  1    2    3    4    5"
                LOCATE 5, 3: PRINT "Load a saved game"
                LOCATE 7, 3: PRINT "Load a new scenario"
                COLOR 4
                LINE (41, 25)-(81, 49), , B
                x = 41: y = 25: ysave = 60: yscen = 92
                COLOR 15
DO
                DO
                        a& = TIMER
                        k = 0
                                DO
                                B& = TIMER
                                IF B& - a& > 2 THEN
                                CALL shootstar
                                a& = TIMER
                                END IF
                                choice$ = INKEY$
                                IF choice$ <> "" THEN EXIT DO
                                LOOP
                 choice$ = RIGHT$(choice$, 1)
                IF players = 0 THEN
                rightlimit = 161
                END IF
                IF selectscenario = 1 THEN rightlimit = 201
               

                IF choice$ <> "" THEN
                SELECT CASE choice$
                      
                        CASE CHR$(left)
                        IF x = 1 OR y = ysave OR y = yscen THEN
                        BEEP
                        ELSE
                        COLOR 0
                        LINE (x, y)-(x + 40, y + 24), , B
                        COLOR 4
                        x = x - 40
                        LINE (x, y)-(x + 40, y + 24), , B
                        END IF
                      
                        CASE CHR$(right)
                        IF x >= rightlimit OR y = ysave OR y = yscen THEN
                        BEEP
                        ELSE
                        COLOR 0
                        LINE (x, y)-(x + 40, y + 24), , B
                        COLOR 4
                        x = x + 40
                        LINE (x, y)-(x + 40, y + 24), , B
                        END IF
              
                        CASE CHR$(up)
                        IF y = 25 THEN
                        BEEP
                        ELSE
                        SELECT CASE y
                        CASE 60
                                COLOR 0
                                LINE (x, y)-(x + 153, y + 24), , B
                                x = 41: y = 25
                                COLOR 4
                                LINE (x, y)-(x + 40, y + 24), , B
                        CASE 92
                                COLOR 0
                                LINE (x, y)-(x + 167, y + 24), , B
                                x = 8: y = ysave
                                COLOR 4
                                LINE (x, y)-(x + 153, y + 24), , B
                      
                      
                        END SELECT
                        END IF

                        CASE CHR$(down)

                       
                        SELECT CASE y
                        CASE 25
                                COLOR 0
                                LINE (x, y)-(x + 40, y + 24), , B
                                x = 8: y = ysave
                                COLOR 4
                                LINE (x, y)-(x + 153, y + 24), , B
                        CASE 60
                                COLOR 0
                                LINE (x, y)-(x + 153, y + 24), , B
                                x = 8: y = yscen
                                COLOR 4
                                LINE (x, y)-(x + 167, y + 24), , B
                        CASE ELSE
                                BEEP
                        END SELECT
                      
                        CASE CHR$(enter)
                        SELECT CASE y
                        CASE 60 'loading a saved game
                               
                                CALL LoadGame(comland(), scenario, skillevel(), movement(), names$(), players, soldiers(), knights(), catapults(), gold(), xposarmy(), yposarmy(), land(), playerscastles(), numofcastles(), homearmy(), xposcastle(),  _
yposcastle(), currentplayer, landposition())
                                IF movement(1) > 0 THEN EXIT SUB
                                goagain = 10
                                EXIT SUB
                        CASE 92 'loading a new scenario
                            
                                        COLOR 15
                                        LOCATE 1, 1: PRINT "Which scenario do you wish to play on? "
                                        LOCATE 3, 1: PRINT "  1    2    3    4    5    6"
                                        selectscenario = 1
                                        players = 0

                                        IF y = 25 THEN
                                        scenario = (x + 39) / 40
                                        players = 0
                                        END IF
                           
                        CASE 25
                              
                                IF selectscenario = 1 THEN
                                        COLOR 15
                                        scenario = (x + 39) / 40
                                        LOCATE 1, 1: PRINT "How many valorous knights wish to play? (Press Enter to confirm)                "
                                        LOCATE 3, 1: PRINT "  1    2    3    4    5     "
                                        selectscenario = 0
                                        COLOR 4
                                        LINE (x, y)-(x + 40, y + 24), , B
                                ELSE
                                        IF players = 0 THEN
                                                IF x < 201 THEN
                                                players = (x + 39) / 40
                                                EXIT DO
                                                END IF
                                        ELSE
                                                IF x < 201 THEN
                                                SELECT CASE players
                                                CASE IS > 1
                                                computers = (x + 39) / 40 - 1
                                                CASE 1
                                                computers = (x + 39) / 40
                                                END SELECT
                                                EXIT SUB
                                                END IF

                                        END IF
                                END IF
                        END SELECT
                END SELECT
                END IF
              
                B& = TIMER
                IF B& - a& > 1 THEN
                       
                        CALL shootstar
                END IF
                LOOP
IF players = 5 THEN EXIT SUB
COLOR 15

LOCATE 1, 1: PRINT "How many artificial knights wish to become thine adversaries? (Computer Players)"
SELECT CASE players

CASE 4
upperlimit = 1
LOCATE 3, 1: PRINT "  0    1                    "
rightlimit = 41

CASE 3
upperlimit = 2
LOCATE 3, 1: PRINT "  0    1    2               "
rightlimit = 81

CASE 2
upperlimit = 3
LOCATE 3, 1: PRINT "  0    1    2    3          "
rightlimit = 121

CASE 1
upperlimit = 3
LOCATE 3, 1: PRINT "  1    2    3    4          "
rightlimit = 121
END SELECT

COLOR 0
LINE (x, y)-(x + 40, y + 24), , B
COLOR 4
LINE (rightlimit, y)-(rightlimit + 40, y + 24), , B
x = rightlimit
LOOP

END SUB

SUB SelectCastle (players, computers, playerscastles(), scenario)
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22
COLOR 0
LINE (160, 120)-(380, 300), , BF
COLOR 15
            
                DO
                z = z + 1
                LOCATE 11 + (z + 1), 23: PRINT "Player"; z; "'s Castle:"
                LOOP UNTIL z >= players

        firsttime = 1: m = 0: movement = 1
        COLOR 15
        FOR p = 1 TO players
       
        COLOR 15
        LOCATE 10, 23: PRINT "Player"; p; ", select a"
        LOCATE 11, 23: PRINT "Castle."
DO
DO
        DO
        IF firsttime = 1 THEN m = m + 1
       
      
        SELECT CASE scenario
        CASE 1
                SELECT CASE m
                CASE 1: x = 180: y = 340
                CASE 2: x = 520: y = 380
                CASE 3: x = 400: y = 220
                CASE 4: x = 340: y = 100
                CASE 5: x = 120: y = 120
                END SELECT
        CASE 2
                SELECT CASE m
                CASE 1: x = 120: y = 80
                CASE 2: x = 80:  y = 460
                CASE 3: x = 360: y = 360
                CASE 4: x = 560: y = 400
                CASE 5: x = 460: y = 100
                END SELECT
        CASE 3
        CASE 4
        CASE 5
                SELECT CASE m
                CASE 1: x = 580: y = 80
                CASE 2: x = 580: y = 440
                CASE 3: x = 240: y = 440
                CASE 4: x = 40: y = 340
                CASE 5: x = 140: y = 80
                END SELECT
        CASE 6
                SELECT CASE m
                CASE 1: x = 140: y = 160
                CASE 2: x = 140: y = 420
                CASE 3: x = 340: y = 400
                CASE 4: x = 540: y = 300
                CASE 5: x = 420: y = 100
                END SELECT
      
        END SELECT
      
        IF firsttime = 1 THEN
                row = CINT(y / 16) - 2
                column = CINT(x / 8)
               
                IF row < 1 THEN row = 2: IF row > 28 THEN row = 27
                IF column < 1 THEN column = 2: IF column > 78 THEN column = 77
                LOCATE row, column: PRINT m
                IF m = 1 THEN
                        xe = x: ye = y
                END IF
                IF m = 5 THEN
                        EXIT DO
                END IF
        ELSE
        EXIT DO
        END IF
        LOOP
        IF firsttime = 1 THEN m = 1: movement = 1
  
        x = x + 3: y = y - 3
        COLOR 4
        IF firsttime = 1 THEN
        LINE (xe - 21, ye + 19)-(xe + 39, ye - 41), , B
        ELSE
        LINE (x - 24, y + 22)-(x + 36, y - 38), , B
        END IF
        DO
        choice$ = INKEY$
        LOOP WHILE choice$ = ""
        choice$ = RIGHT$(choice$, 1)

                SELECT CASE choice$
                      
                        CASE CHR$(left)
                        movement = 1
                        m = m + 1: IF m = 6 THEN m = 1
                        COLOR 0
                        LINE (x - 24, y + 22)-(x + 36, y - 38), , B
                        COLOR 4
                        x = x - 40
                        IF firsttime = 1 THEN
                        COLOR 0:  LINE (xe - 21, ye + 19)-(xe + 39, ye - 41), , B
                        END IF
                      
                        CASE CHR$(right)
                        movement = 1
                        m = m - 1: IF m <= 0 THEN m = 5
                        COLOR 0
                        LINE (x - 24, y + 22)-(x + 36, y - 38), , B
                        COLOR 4
                        x = x - 40
                        IF firsttime = 1 THEN
                        COLOR 0: LINE (xe - 21, ye + 19)-(xe + 39, ye - 41), , B
                        END IF
                      
                        CASE CHR$(enter)
                        IF movement = 1 THEN
                        h = h + 1
                        movement = 0
                        SELECT CASE h
                              
                                CASE 1
                                playerscastles(1) = m
                                COLOR 15
                                LOCATE 13, 42: PRINT playerscastles(1)
                                COLOR 4
                              
                                CASE 2
                                IF m = playerscastles(1) THEN
                                BEEP
                                h = h - 1
                                variable = 69
                                ELSE
                                playerscastles(2) = m
                                COLOR 15
                                LOCATE 14, 42: PRINT playerscastles(2)
                                COLOR 4
                                END IF
                               
                                CASE 3
                                IF m = playerscastles(1) OR m = playerscastles(2) THEN
                                BEEP
                                h = h - 1
                                variable = 69
                                ELSE
                                playerscastles(3) = m
                                COLOR 15
                                LOCATE 15, 42: PRINT playerscastles(3)
                                COLOR 4
                                END IF
                              
                                CASE 4
                                IF m = playerscastles(1) OR m = playerscastles(2) OR m = playerscastles(3) THEN
                                BEEP
                                h = h - 1
                                variable = 69
                                ELSE
                                playerscastles(4) = m
                                COLOR 15
                                LOCATE 16, 42: PRINT playerscastles(4)
                                COLOR 4
                                END IF
                              
                                CASE 5
                                IF m = playerscastles(1) OR m = playerscastles(2) OR m = playerscastles(3) OR m = playerscastles(4) THEN
                                BEEP
                                h = h - 1
                                variable = 69
                                ELSE
                                playerscastles(5) = m
                                COLOR 15
                                LOCATE 17, 42: PRINT playerscastles(5)
                                COLOR 4
                                END IF
                                EXIT DO
                        END SELECT
                       
                        ELSE
                        BEEP
                        END IF
                END SELECT
       
        firsttime = 0
IF players = h THEN EXIT FOR
LOOP WHILE variable = 69

LOOP
       
        NEXT p
m = 0
FOR i = h + 1 TO h + computers
IF computers = 0 THEN EXIT FOR
m = 0

FOR j = 1 TO 5
great = 0
m = m + 1
IF m <> playerscastles(1) AND m <> playerscastles(2) AND m <> playerscastles(3) AND m <> playerscastles(4) THEN great = 1


IF great = 1 THEN
playerscastles(i) = m
EXIT FOR
END IF
NEXT j

NEXT i


END SUB

SUB startpicture
CLS
'figure out how fast this computer is
a& = TIMER
DO
speed = speed + 1
B& = TIMER
IF B& - a& > 1 THEN EXIT DO
LOOP
SCREEN 12
COLOR 14
x = 148: y = 80
LINE (0, 0)-(640, 480), , B
LINE (1, 1)-(639, 479), , B
'*******|MEDIEVAL MASSACRE|*********
LINE (x, y)-STEP(0, 100)
LINE -STEP(10, 0)
LINE -STEP(0, -61)
LINE (x, y)-(x + 25, y + 100)
LINE -STEP(25, -100)
LINE -STEP(0, 100)
LINE -STEP(-10, 0)
LINE -STEP(0, -61)
PAINT (x + 5, y + 30): PAINT (x + 45, y + 30)
LINE (x + 1, y)-(x + 26, y + 100)
LINE STEP(-2, 0)-STEP(26, -100)
'******|M
a = 78 + x
B = y + 82
CIRCLE (a, B), 20
CIRCLE (a, B), 15
PAINT (a + 17, B)
COLOR 0
LINE (a, B + 4)-(a + 30, B + 8), , BF
COLOR 14
LINE (a + 17, B + 3)-(a - 17, B - 3), , BF
'******|ME
x = 50 + a: y = B
CIRCLE (x, y), 20
CIRCLE (x, y), 15
PAINT (x + 17, B)
LINE (x + 15, y + 20)-(x + 21, y - 70), , BF
'*******|MED
x = 35 + x
LINE (x, y + 20)-(x + 6, y - 20), , BF
CIRCLE (x + 3, y - 29), 4
PAINT (x + 3, y - 29)
'********| MEDI
a = 35 + x
CIRCLE (a, B), 20
CIRCLE (a, B), 15
PAINT (a + 17, B)
LINE (a + 17, B + 3)-(a - 17, B - 3), , BF
COLOR 0
LINE (a, B + 4)-(a + 30, B + 8), , BF
COLOR 14
'********| MEDIE
x = 40 + a: y = y + 20
LINE (x - 2, y)-(x - 20, y - 38)
LINE STEP(0, 0)-STEP(5, 0)
LINE STEP(0, 0)-STEP(19, 38)
LINE STEP(0, 0)-STEP(-6, 0)
PAINT (x, y - 2)
LINE (x + 5, y)-(x + 23, y - 38)
LINE STEP(0, 0)-STEP(-5, 0)
LINE STEP(0, 0)-STEP(-19, 38)
PAINT (x + 5, y - 5)
'*******| MEDIEV
x = 45 + x: y = y - 18
CIRCLE (x, y), 20, , , , 1.2
CIRCLE (x, y), 15, , , , 1.2
PAINT (x + 16, y)
LINE (x + 13, y + 3)-(x + 20, y + 20)
LINE STEP(0, 0)-STEP(5, 0)
LINE STEP(0, 0)-STEP(-10, -20)
PAINT STEP(2, 7)
'*******| MEDIEVA
x = 35 + x: y = y + 20
LINE (x, y)-(x + 6, y - 95), , BF
'*******| MEDIEVAL
x = 144: y = 200
'*******|MASSACRE|*********
LINE (x, y)-STEP(0, 100)
LINE -STEP(10, 0)
LINE -STEP(0, -61)
LINE (x, y)-(x + 25, y + 100)
LINE -STEP(25, -100)
LINE -STEP(0, 100)
LINE -STEP(-10, 0)
LINE -STEP(0, -61)
PAINT (x + 5, y + 30): PAINT (x + 45, y + 30)
LINE (x + 1, y)-(x + 26, y + 100)
LINE STEP(-2, 0)-STEP(26, -100)

x = 74 + x: y = y + 80
CIRCLE (x, y), 20, , , , 1.2
CIRCLE (x, y), 15, , , , 1.2
PAINT (x + 16, y)
LINE (x + 13, y + 3)-(x + 20, y + 20)
LINE STEP(0, 0)-STEP(5, 0)
LINE STEP(0, 0)-STEP(-10, -20)
PAINT STEP(2, 7)

x = 50 + x: y = y
CIRCLE (x, y), 20
PAINT (x, y)
COLOR 0
LINE (x - 17, y + 20)-(x - 21, y - 20), , BF
LINE (x + 17, y + 20)-(x + 21, y - 20), , BF
        CIRCLE (x, y - 8), 5
        PAINT (x, y - 8)
        CIRCLE (x, y + 8), 5
        PAINT (x, y + 8)
LINE (x, y - 13)-(x + 20, y - 2)
LINE (x, y - 5)-(x + 20, y + 6)
PAINT (x + 5, y - 5)
LINE (x, y + 5)-(x - 20, y - 8)
LINE (x, y + 12)-(x - 20, y - 1)
PAINT (x - 10, y)

x = 40 + x: y = y
COLOR 14
CIRCLE (x, y), 20
PAINT (x, y)
COLOR 0
LINE (x - 17, y + 20)-(x - 21, y - 20), , BF
LINE (x + 17, y + 20)-(x + 21, y - 20), , BF
        CIRCLE (x, y - 8), 5
        PAINT (x, y - 8)
        CIRCLE (x, y + 8), 5
        PAINT (x, y + 8)
LINE (x, y - 13)-(x + 20, y - 2)
LINE (x, y - 5)-(x + 20, y + 6)
PAINT (x + 5, y - 5)
LINE (x, y + 5)-(x - 20, y - 8)
LINE (x, y + 12)-(x - 20, y - 1)
PAINT (x - 10, y)
COLOR 14

x = 40 + x
CIRCLE (x, y), 20, , , , 1.2
CIRCLE (x, y), 15, , , , 1.2
PAINT (x + 16, y)
LINE (x + 13, y + 3)-(x + 20, y + 20)
LINE STEP(0, 0)-STEP(5, 0)
LINE STEP(0, 0)-STEP(-10, -20)
PAINT STEP(2, 7)

x = 47 + x
CIRCLE (x, y), 20
CIRCLE (x, y), 15
PAINT (x + 17, y)
COLOR 0
LINE (x, y - 10)-(x + 30, y + 10), , BF
COLOR 14

x = 24 + x
LINE (x, y + 20)-(x + 6, y - 20), , BF
CIRCLE (x + 20, y - 16), 4
PAINT (x + 20, y - 16)
LINE (x + 20, y - 20)-(x, y - 10)
LINE (x + 20, y - 16)-(x, y - 6)
PAINT (x + 9, y - 13)

a = 48 + x
B = y
CIRCLE (a, B), 20
CIRCLE (a, B), 15
PAINT (a + 17, B)
COLOR 0
LINE (a, B + 4)-(a + 30, B + 8), , BF
COLOR 14
LINE (a + 17, B + 3)-(a - 17, B - 3), , BF
y = 1: z = 1: x = 1
B = 35: g = 55: r = 54
        DO
        IF y = 1 THEN B = B + .3
        IF y = 2 THEN B = B - .3
        IF z = 2 THEN g = g - .3
        IF z = 1 THEN g = g + .3
        IF x = 2 THEN r = r - .3
        IF x = 1 THEN r = r + .3
        blue = CINT(B)
        green = CINT(g)
        red = CINT(r)
        colornumber = 65536 * blue + 256 * green + red
        PALETTE 14, colornumber
        COLOR 14
        IF B > 40 THEN y = 2
        IF B < 30 THEN y = 1
        IF g > 61 THEN
        z = 2
'PLAY "mst255o2l8cfgagfgl4afl3fp6p4l8cfgagfgl4afl3fp6p4l8dgaa+agaa+agal4a+p8p4l8cfgagfgagfgl4ap6p6l2cl4ddl2cl6<al4f>p8p4l2fl3edc"
'    {$$%%%%!!--|||||||--||--|****--|||||||--||--|****--|||||||||||||--||****--|||||||||||--|****--|--||--|--^|--|^****--|--|||}
'
'               1             2                   3                      4                   5                     6
     
     
        PLAY "msmbt255o2p4p8l8cfgagfgl4afl3f"
                FOR i = 1 TO speed * 3
                IF INKEY$ <> "" THEN
                        'PLAY "p6p4l8cfgagfgl4afl3fp6p4l8dgaa+agaa+agal4a+p8p4l8cfgagfgagfgl4ap6p6l2cl4ddl2cl6<al4f>p8p4l2fl3edc"
                        EXIT SUB
                END IF
                NEXT i
        PLAY "p6p4l8cfgagfgl4afl3f "
                FOR i = 1 TO speed * 3
                IF INKEY$ <> "" THEN
                        'PLAY "p6p4l8dgaa+agaa+agal4a+p8p4l8cfgagfgagfgl4ap6p6l2cl4ddl2cl6<al4f>p8p4l2fl3edc"
                        EXIT SUB
                END IF
                NEXT i
        PLAY "p6p4l8dgaa+agaa+agal4a+"
                FOR i = 1 TO speed * 3
                IF INKEY$ <> "" THEN
                        'PLAY "p8p4l8cfgagfgagfgl4ap6p6l2cl4ddl2cl6<al4f>p8p4l2fl3edc"
                        EXIT SUB
                END IF
                NEXT i
        PLAY "p8p4l8cfgagfgagfgl4a "
                FOR i = 1 TO speed * 3
                IF INKEY$ <> "" THEN
                        'PLAY "p6p6l2cl4ddl2cl6<al4f>p8p4l2fl3edc"
                        EXIT SUB
                END IF
                NEXT i
        PLAY "p6p6l2cl4ddl2cl6<al4f>"
                FOR i = 1 TO speed * 4
                IF INKEY$ <> "" THEN
                       'PLAY "p8p4l2fl3edc"
                       EXIT SUB
                END IF
                NEXT i
        PLAY "p8p4l2fl3edc "
                FOR i = 1 TO speed * 3
                IF INKEY$ <> "" THEN
                     
                        EXIT SUB
                END IF
                NEXT i
     
        '      {$$%%%%!!****--|||||||--||--|****--|||||||--||--|****--|||||||||||||--||****--|||||||||||--|****--|--||--|--^|--|^****--|--|||}
        '
        '               1                   2                   3                      4                   5                     6
        'PLAY "mst255o2l2cl4ddl2cl6<al4f>p8p4l2fl3edc"
        END IF
        IF g < 50 THEN z = 1 '1
        IF r > 61 THEN x = 2 '2
        IF r < 50 THEN x = 1 '1
      
         COLOR 14
        'LOCATE 1, 1: PRINT "blue="; blue; "green="; green; "red="; red
        LOOP WHILE INKEY$ = ""
        PLAY OFF


END SUB

