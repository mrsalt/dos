DECLARE SUB CoolLand (c!, comland!())
DECLARE SUB TransferMen (lland(), andposition(), scenario!, skipit!, soldiers!(), homearmy!(), currentplayer!, xposcastle!(), yposcastle!(), xposarmy!(), yposarmy!(), playerscastles!())
DECLARE SUB AwesomeLand (c!, comland())
DECLARE SUB KimLand (c!, comland())
DECLARE SUB MarkLand (x!, y!, c!, players!, comland())
DECLARE SUB castle (x!, y!, q!)
DECLARE SUB soldier (x!, y!, currentplayer!, q!, playerscastles!())
DECLARE SUB playmenu (land(), choice, names$(), currentplayer, sentinent(), gold(), playerscastles(), movement(), xposcastle(), yposcastle(), homearmy(), soldiers(), knights(), catapults(), xposarmy(), players)
DECLARE SUB savegame (comland(), scenario, skillevel(), movement(), names$(), players, soldiers(), knights(), catapults(), gold(), xposarmy(), yposarmy(), land(), playerscastles(), numofcastles(), homearmy(), xposcastle(), yposcastle(),  _
currentplayer, landposition())
DECLARE SUB statusreport (currentplayer, playerscastles(), movement(), xposcastle(), yposcastle(), gold(), land(), homearmy(), soldiers(), knights(), catapults(), names$(), xposarmy(), players)
DECLARE SUB lookatmap (land(), xposarmy(), yposarmy(), homearmy(), scenario, players, landposition(), xposcastle(), yposcastle(), pause, playerscastles(), currentplayer, movement(), gold(), soldiers(), knights(), catapults(), names$())
DECLARE SUB BuildaCastle (comland(), xposarmy(), yposarmy(), playerscastles(), gold(), landposition(), land(), numofcastles(), pause, scenario, currentplayer!, xposcastle(), yposcastle(), players, happen)
DECLARE SUB moraltour (playerscastles(), currentplayer!, land(), soldiers())
DECLARE SUB raidcastle (scenario, xposcastle(), yposcastle(), names$(), currentplayer!, gold(), homearmy(), playerscastles(), players)
DECLARE SUB BuildArmy (pause, scenario, homearmy(), currentplayer, soldiers(), knights(), catapults(), gold(), land(), playerscastles(), xposcastle(), yposcastle())
DECLARE FUNCTION currentcolor (currentplayer!, playerscastles())
CONST pi = 3.14592, yes = 1, no = 0
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22
' $INCLUDE: 'c:\qb45\massacre\types.bas'

SUB BuildaCastle (comland(), xposarmy(), yposarmy(), playerscastles(), gold(), landposition(), land(), numofcastles(), pause, scenario, currentplayer, xposcastle(), yposcastle(), players, happen)
CLS
SCREEN 12
PALETTE
c = 100
pause = 5893
CALL lookatmap(land(), xposarmy(), yposarmy(), homearmy(), scenario, players, landposition(), xposcastle(), yposcastle(), pause, playerscastles(), currentplayer, movement(), gold(), soldiers(), knights(), catapults(), names$())

  placecurrentplayer = currentplayer
  FOR castles = 1 TO 4
  FOR t = 1 TO players
  x = xposcastle(castles, t)
  y = yposcastle(castles, t)

  currentplayer = t
  q = currentcolor(currentplayer!, playerscastles())
  IF xposcastle(castles, t) <> 0 OR yposcastle(castles, t) <> 0 THEN
  CALL castle(x, y, q)
  END IF
  NEXT t
  NEXT castles
  currentplayer = placecurrentplayer

  COLOR 0
x = 10: y = 10: a = 8 * 27: B = 8 * 5.5
LINE (x, y)-(x + a, y + B), , BF
COLOR currentcolor(currentplayer, playerscastles())

IF gold(currentplayer) >= 300 THEN
LOCATE 2, 4: PRINT "Where would you like the"
LOCATE 3, 4: PRINT "new castle to be built?"
ELSE
LOCATE 2, 4: PRINT "Sorry, you don't have "
LOCATE 3, 4: PRINT "enough money. (300)"
DO
LOOP WHILE INKEY$ = ""
happen = 1
EXIT SUB
END IF
COLOR 13
x = 319: y = 219
LINE (x, y)-(x + 20, y + 20), , B
DO
DO
pastx = x
pasty = y
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""
choice$ = RIGHT$(choice$, 1)
SELECT CASE choice$

CASE CHR$(right)
IF x + 20 > 620 THEN
BEEP
ELSE
x = x + 20
COLOR 0
LINE (pastx, pasty)-(pastx + 20, pasty + 20), , B
COLOR 13
LINE (x, y)-(x + 20, y + 20), , B
END IF
CASE CHR$(left)
IF x - 20 < -1 THEN
BEEP
ELSE
x = x - 20
COLOR 0
LINE (pastx, pasty)-(pastx + 20, pasty + 20), , B
COLOR 13
LINE (x, y)-(x + 20, y + 20), , B
END IF
CASE CHR$(up)
IF y - 20 < -1 THEN
BEEP
ELSE
y = y - 20
COLOR 0
LINE (pastx, pasty)-(pastx + 20, pasty + 20), , B
COLOR 13
LINE (x, y)-(x + 20, y + 20), , B
END IF
CASE CHR$(down)
IF y + 20 > 460 THEN
BEEP
ELSE
y = y + 20
COLOR 0
LINE (pastx, pasty)-(pastx + 20, pasty + 20), , B
COLOR 13
LINE (x, y)-(x + 20, y + 20), , B
END IF
CASE CHR$(enter)
position = POINT(x + 10, y + 7)
      
        IF position = 2 THEN
        COLOR 0
        LINE (pastx, pasty)-(pastx + 20, pasty + 20), , B
       
         placex = x
         placey = y
         x = x + 1  '4
         y = y + 21 '18
         SELECT CASE playerscastles(currentplayer)
         CASE 1
         q = 9
         CALL castle(x, y, q)
         CASE 2
         q = 4
         CALL castle(x, y, q)
         CASE 3
         q = 10
         CALL castle(x, y, q)
         CASE 4
         q = 14
         CALL castle(x, y, q)
          CASE 5
         colornumber = 65536 * 40 + 256 * 20 + 40
          PALETTE 13, colornumber
          q = 13
          CALL castle(x, y, q)
          END SELECT
          x = placex + 1
          y = placey + 1 + 20
     DO
        IF xposcastle(4, currentplayer) = 0 AND yposcastle(4, currentplayer) = 0 THEN
        xposcastle(4, currentplayer) = x: yposcastle(4, currentplayer) = y
        numofcastles(currentplayer) = numofcastles(currentplayer) + 1
        comland(x / 20, y / 20 - 1) = currentcolor(currentplayer, playerscastles()) * 20
        EXIT DO
        END IF
       
        IF xposcastle(3, currentplayer) = 0 AND yposcastle(3, currentplayer) = 0 THEN
        xposcastle(3, currentplayer) = x: yposcastle(3, currentplayer) = y
        numofcastles(currentplayer) = numofcastles(currentplayer) + 1
        comland(x / 20, y / 20 - 1) = currentcolor(currentplayer, playerscastles()) * 5
        EXIT DO
        END IF
       
        IF xposcastle(2, currentplayer) = 0 AND yposcastle(2, currentplayer) = 0 THEN
        xposcastle(2, currentplayer) = x: yposcastle(2, currentplayer) = y
        numofcastles(currentplayer) = numofcastles(currentplayer) + 1
        comland(x / 20, y / 20 - 1) = currentcolor(currentplayer, playerscastles()) * 5
        EXIT DO
        END IF
       
        IF xposcastle(1, currentplayer) = 0 AND yposcastle(1, currentplayer) = 0 THEN
        xposcastle(1, currentplayer) = x: yposcastle(1, currentplayer) = y
        numofcastles(currentplayer) = numofcastles(currentplayer) + 1
        comland(x / 20, y / 20 - 1) = currentcolor(currentplayer, playerscastles()) * 5
        EXIT DO
        END IF
      
     LOOP
        DO
                FOR i = 1 TO 4
                       
                        IF (xposcastle(5 - i, currentplayer) = 0 AND yposcastle(5 - i, currentplayer) = 0) AND (yposcastle(4 - i, currentplayer) <> 0 OR xposcastle(4 - 1, currentplayer) <> 0) THEN
                                IF xposcastle(4, currentplayer) = 0 AND yposcastle(4, currentplayer) = 0 THEN
                                xposcastle(4, currentplayer) = xposcastle(3, currentplayer): yposcastle(4, currentplayer) = yposcastle(3, currentplayer)
                                xposcastle(3, currentplayer) = 0: yposcastle(3, currentplayer) = 0
                                END IF
                               
                                IF xposcastle(3, currentplayer) = 0 AND yposcastle(3, currentplayer) = 0 THEN
                                xposcastle(3, currentplayer) = xposcastle(2, currentplayer): yposcastle(3, currentplayer) = yposcastle(2, currentplayer)
                                xposcastle(2, currentplayer) = 0: yposcastle(2, currentplayer) = 0
                                END IF
                       
                                IF xposcastle(2, currentplayer) = 0 AND yposcastle(2, currentplayer) = 0 THEN
                                xposcastle(2, currentplayer) = xposcastle(1, currentplayer): yposcastle(2, currentplayer) = yposcastle(1, currentplayer)
                                xposcastle(1, currentplayer) = 0: yposcastle(2, currentplayer) = 0
                                END IF
                        END IF


                NEXT i
                again = 0
                FOR i = 1 TO 4
                        IF (xposcastle(5 - i, currentplayer) = 0 AND yposcastle(5 - i, currentplayer) = 0) AND (yposcastle(4 - i, currentplayer) <> 0 OR xposcastle(4 - 1, currentplayer) <> 0) THEN
                        again = 1
                        END IF
                NEXT i
                IF again = 0 THEN EXIT DO
        LOOP
      
       
       
        land(currentplayer) = land(currentplayer) + 1
        y = y - 20
        IF landposition(x / 20, y / 20) <> 0 THEN
                placecurrentplayer = currentplayer
                FOR i = 1 TO players
                currentplayer = i
                        IF currentcolor(currentplayer, playerscastles()) = landposition(x / 20, y / 20) THEN
                        land(currentplayer) = land(currentplayer) - 1
                        END IF
                NEXT i
                currentplayer = placecurrentplayer
        END IF
        landposition(x / 20, y / 20) = 0
        a& = TIMER
        DO
        B& = TIMER: IF B& - a& > 1 THEN EXIT DO
        LOOP WHILE INKEY$ = ""
        EXIT SUB
        END IF

END SELECT
LOOP WHILE INKEY$ = ""
LOOP



END SUB

SUB BuildArmy (pause, scenario, homearmy(), currentplayer, soldiers(), knights(), catapults(), gold(), land(), playerscastles(), xposcastle(), yposcastle())

SCREEN 12
CLS
colornumber = 65536 * 63 + 256 * 63 + 63
PALETTE 0, colornumber
COLOR currentcolor(currentplayer!, playerscastles())
FOR x = 1 TO 120
LINE (120 - x, 120 - x)-(519 + x, 359 + x), , B
NEXT x

COLOR 8
LINE (136, 360)-(536, 376), , BF
LINE (520, 135)-(536, 376), , BF
row = 8
lines = 13
'****************| Asks what kind of build army |***************************
horo = 20
LOCATE row + 5, horo: PRINT "First of all, what would you like to do:"
LOCATE row + 7, horo: PRINT " 1. Build campaign army"
LOCATE row + 8, horo: PRINT " 2. Build home army"
LOCATE row + 9, horo: PRINT " 3. Transfer men from one army to another"
DO
DO
armychoice$ = INKEY$
LOOP WHILE armychoice$ = ""

SELECT CASE armychoice$
        CASE "1"
        armychoice = 1
      
        CASE "2"
        armychoice = 2
        c = 100
        PALETTE
        CLS
        x = 0: y = 0
        pause = 5893
        CALL lookatmap(land(), xposarmy(), yposarmy(), homearmy(), scenario, players, landposition(), xposcastle(), yposcastle(), pause, playerscastles(), currentplayer, movement(), gold(), soldiers(), knights(), catapults(), names$())
        FOR i = 1 TO 4
                q = currentcolor(currentplayer, playerscastles())
                x = xposcastle(i, currentplayer)
                y = yposcastle(i, currentplayer)
                IF x <> 0 OR y <> 0 THEN
                CALL castle(x, y, q)
                COLOR 15: LOCATE CINT(y / 16) - 1, CINT(x / 8) + 1: PRINT i; homearmy(i, currentplayer); "Men"
                END IF
        NEXT i
        COLOR 15: LOCATE 23, 10: PRINT "Press the # of the castle to add men to"
        DO
        DO
        currentcastle$ = INKEY$
        LOOP WHILE currentcastle$ = ""
        IF VAL(currentcastle$) > 0 AND VAL(currentcastle$) < 5 THEN
        IF xposcastle(VAL(currentcastle$), currentplayer) <> 0 OR yposcastle(VAL(currentcastle$), currentplayer) <> 0 THEN
        currentcastle = VAL(currentcastle$)
        SCREEN 12
        CLS
        colornumber = 65536 * 63 + 256 * 63 + 63
        PALETTE 0, colornumber
        COLOR currentcolor(currentplayer!, playerscastles())
        FOR x = 1 TO 120
        LINE (120 - x, 120 - x)-(519 + x, 359 + x), , B
        NEXT x
        COLOR 8
        LINE (136, 360)-(536, 376), , BF
        LINE (520, 135)-(536, 376), , BF
        row = 8
        lines = 13
        EXIT DO
        END IF
        END IF
        LOOP
      
      
      
        CASE "3"
        CALL TransferMen(land(), landposition(), scenario, skipit, soldiers(), homearmy(), currentplayer!, xposcastle(), yposcastle(), xposarmy(), yposarmy(), playerscastles())
      
        EXIT SUB
      
        CASE ELSE
        BEEP
END SELECT
IF armychoice <> 0 THEN EXIT DO
LOOP

FOR q = 1 TO 6
LOCATE 12 + q, 16: PRINT "                                               "
NEXT q
'*******************| Builds the army |*************************************
        IF armychoice = 1 THEN
        COLOR 9
        LOCATE row + 5, 25: PRINT "Soldiers   (3 gold) ", soldiers(currentplayer)
        LOCATE row + 1, 25: PRINT "    ( Building Campaign Army )"
        END IF
      
        IF armychoice = 2 THEN
        COLOR 9
        LOCATE row + 5, 25: PRINT "Soldiers   (3 gold) ", homearmy(currentcastle, currentplayer)
        LOCATE row + 1, 25: PRINT "      ( Building Home Army )"
        END IF
COLOR 8
LOCATE row + 2, 25: PRINT "Your have"; gold(currentplayer); "gold good sir."
COLOR 4
LOCATE 10, 34: PRINT gold
COLOR 8

LOCATE row + 3, 25: PRINT "Your army is:"
LOCATE row + 7, 25: PRINT "Knights    (15 gold)", knights(currentplayer)
LOCATE row + 9, 25: PRINT "Catapults  (40 gold)", catapults(currentplayer)
LOCATE row + 12, 25: PRINT "Exit"

DO
        COLOR 4
        LOCATE 10, 34: PRINT gold(currentplayer)
        COLOR 8
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""

choice$ = RIGHT$(choice$, 1)
        IF armychoice = 1 THEN
        sol = soldiers(currentplayer)
        END IF
        IF armychoice = 2 THEN
        sol = homearmy(currentcastle, currentplayer)
        END IF
SELECT CASE choice$
      
        CASE CHR$(up)
        IF lines = 13 THEN BEEP
        IF lines <> 13 THEN
       
        SELECT CASE lines
      
        CASE 15
        COLOR 8
        LOCATE row + 7, 25: PRINT "Knights    (15 gold)", knights(currentplayer)
        COLOR 9
        LOCATE row + 5, 25: PRINT "Soldiers   (3 gold) ", sol
        lines = lines - 2
      
        CASE 17
        COLOR 8
        LOCATE row + 9, 25: PRINT "Catapults  (40 gold)", catapults(currentplayer)
        COLOR 9
        LOCATE row + 7, 25: PRINT "Knights    (15 gold)", knights(currentplayer)
        lines = lines - 2
      
        CASE 20
        COLOR 8
        LOCATE row + 12, 25: PRINT "Exit"
        COLOR 9
        LOCATE row + 9, 25: PRINT "Catapults  (40 gold)", catapults(currentplayer)
        lines = lines - 3
        END SELECT
        END IF

        CASE CHR$(down)
        IF lines = 20 THEN BEEP
        IF lines <> 20 THEN
        SELECT CASE lines
     
        CASE 13
        COLOR 8
        LOCATE row + 5, 25: PRINT "Soldiers   (3 gold) ", sol
        COLOR 9
        LOCATE row + 7, 25: PRINT "Knights    (15 gold)", knights(currentplayer)
        lines = lines + 2
     
        CASE 15
        COLOR 8
        LOCATE row + 7, 25: PRINT "Knights    (15 gold)", knights(currentplayer)
        COLOR 9
        LOCATE row + 9, 25: PRINT "Catapults  (40 gold)", catapults(currentplayer)
        lines = lines + 2
     
        CASE 17
        COLOR 8
        LOCATE row + 9, 25: PRINT "Catapults  (40 gold)", catapults(currentplayer)
        COLOR 9
        LOCATE row + 12, 25: PRINT "Exit"
        lines = lines + 3
        END SELECT
        END IF
      
      
        CASE CHR$(enter)
        IF lines = 20 THEN EXIT SUB
        SELECT CASE lines
      
        CASE 13
                IF armychoice = 1 THEN
                        IF gold(currentplayer) - 3 < 0 THEN
                        BEEP
                        ELSE
                        soldiers(currentplayer) = 1 + soldiers(currentplayer)
                        gold(currentplayer) = gold(currentplayer) - 3
                        COLOR 9
                        LOCATE row + 5, 25: PRINT "Soldiers   (3 gold) ", soldiers(currentplayer)
                        COLOR 8
                        END IF
                END IF
                IF armychoice = 2 THEN
                        IF gold(currentplayer) - 3 < 0 THEN
                        BEEP
                        ELSE
                        homearmy(currentcastle, currentplayer) = 1 + homearmy(currentcastle, currentplayer)
                        gold(currentplayer) = gold(currentplayer) - 3
                        COLOR 9
                        LOCATE row + 5, 25: PRINT "Soldiers   (3 gold) ", homearmy(currentcastle, currentplayer)
                        COLOR 8
                        END IF
                END IF
      
        CASE 15
        IF armychoice = 1 THEN
        IF gold(currentplayer) - 15 < 0 THEN
        BEEP
        ELSE
        knights(currentplayer) = 1 + knights(currentplayer)
        gold(currentplayer) = gold(currentplayer) - 15
        COLOR 9
        LOCATE row + 7, 25: PRINT "Knights    (15 gold)", knights(currentplayer)
        COLOR 8
        END IF
        ELSE
        BEEP
        END IF
      
        CASE 17
        IF armychoice = 1 THEN
        IF gold(currentplayer) - 40 < 0 THEN
        BEEP
        ELSE
        catapults(currentplayer) = 1 + catapults(currentplayer)
        gold(currentplayer) = gold(currentplayer) - 40
        COLOR 9
        LOCATE row + 9, 25: PRINT "Catapults  (40 gold)", catapults(currentplayer)
        COLOR 8
        END IF
        ELSE
        BEEP
        END IF
        END SELECT
        END SELECT
      
      
        COLOR 4
        LOCATE 10, 34: PRINT gold(currentplayer)
        COLOR 8
LOOP
END SUB

SUB lookatmap (land(), xposarmy(), yposarmy(), homearmy(), scenario, players, landposition(), xposcastle(), yposcastle(), pause, playerscastles(), currentplayer, movement(), gold(), soldiers(), knights(), catapults(), names$())


SCREEN 12
CLS
PALETTE
c = 100
placeholderpause = pause

SELECT CASE scenario
CASE 1: CALL MarkLand(x, y, c, players, comland())
CASE 2: CALL KimLand(c, comland())
CASE 3
CASE 4
CASE 5: CALL CoolLand(c, comland())
CASE 6: CALL AwesomeLand(c, comland())
END SELECT
place = currentplayer
FOR a = 1 TO players
currentplayer = a
x = xposcastle(4, a)
y = yposcastle(4, a)
q = currentcolor(currentplayer, playerscastles())
IF x <> 0 OR y <> 0 THEN CALL castle(x, y, q)
NEXT a
currentplayer = place
placecurrentplayer = currentplayer
  FOR castles = 1 TO 3
  FOR t = 1 TO players
  x = xposcastle(castles, t)
  y = yposcastle(castles, t)
 
  currentplayer = t
  q = currentcolor(currentplayer!, playerscastles())

  IF xposcastle(castles, t) <> 0 OR yposcastle(castles, t) <> 0 THEN
  CALL castle(x, y, q)
  END IF

  NEXT t
  NEXT castles
  IF pause <> 5893 THEN
  currentplayer = placecurrentplayer
  FOR squares = 0 TO 24
  FOR acrosquares = 0 TO 32
  paintcolor = landposition(acrosquares, squares)
          IF paintcolor > 0 THEN
          COLOR 0
          LINE (acrosquares * 20 - 1, squares * 20 - 1)-STEP(20, 20), , B
          COLOR paintcolor
          LINE (acrosquares * 20 + 10, squares * 20 + 10)-STEP(0, 0)
          PAINT (acrosquares * 20 + 10, squares * 20 + 10), , 0
          END IF
  NEXT acrosquares
  acrosquares = 1
  NEXT squares
  placecurrentplayer = currentplayer
  END IF
          FOR m = 1 TO players
          currentplayer = m
          x = xposarmy(currentplayer)
          y = yposarmy(currentplayer)
          q = currentcolor(currentplayer, playerscastles())
          CALL soldier(x, y, currentplayer, q, playerscastles())
          NEXT m
  currentplayer = placecurrentplayer
  pause = placeholderpause
  IF pause <> 1 AND pause <> 5893 THEN
 
  DO
  LOOP WHILE INKEY$ = ""
  CALL statusreport(currentplayer, playerscastles(), movement(), xposcastle(), yposcastle(), gold(), land(), homearmy(), soldiers(), knights(), catapults(), names$(), xposarmy(), players)
  WIDTH 80, 30
  END IF
END SUB

SUB moraltour (playerscastles(), currentplayer, land(), soldiers())
CLS
colornumber = 65536 * 35 + 256 * 35 + 35
PALETTE 0, colornumber
SCREEN 12 '640 * 350 -80 x 25 or 80 x 43 text format, 8 x 14 or 8 x 8 character box size
COLOR currentcolor(currentplayer!, playerscastles())
LINE (0, 0)-(640, 480), , BF
row = 8
column = 20
SELECT CASE land(currentplayer)
CASE IS <= 100
z = 4
CASE IS < 10
z = 4
CASE IS > 100
z = 6
END SELECT
COLOR 0
COLOR 8
LOCATE row + 2, column:     PRINT "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
FOR q = 1 TO z
LOCATE row + 2 + q, column: PRINT "º                                     º"
NEXT q
LOCATE row + 2 + q, column: PRINT "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
SELECT CASE land(currentplayer)
CASE IS < 20
LOCATE row + 3, column + 2: PRINT "Thine determination was great, but"
LOCATE row + 4, column + 2: PRINT "your profit was small.  Nevertheless"
LOCATE row + 5, column + 2: PRINT "thou hast promoted"; land(currentplayer); "soldiers to"
LOCATE row + 6, column + 2: PRINT "royal army."
soldiers(currentplayer) = land(currentplayer) + soldiers(currentplayer)
CASE IS <= 100
IF land(currentplayer) > 19 THEN
LOCATE row + 3, column + 2: PRINT "Thine determination was great, and"
LOCATE row + 4, column + 2: PRINT "your profit was fair.  Consequently"
LOCATE row + 5, column + 2: PRINT "thou hast promoted"; land(currentplayer); "soldiers to"
LOCATE row + 6, column + 2: PRINT "your royal army."
soldiers(currentplayer) = land(currentplayer) + soldiers(currentplayer)
END IF
CASE IS > 100
LOCATE row + 3, column + 2: PRINT "As thou traveled from one end of the"
LOCATE row + 4, column + 2: PRINT "kingdom to another thou saw many who"
LOCATE row + 5, column + 2: PRINT "were anxious to aid in thine cause."
LOCATE row + 6, column + 2: PRINT "Several of them even decided to join"
LOCATE row + 7, column + 2: PRINT "your holy army.  Your army now has "
LOCATE row + 8, column + 2: PRINT ""; land(currentplayer); "more soldiers."
soldiers(currentplayer) = land(currentplayer) + soldiers(currentplayer)
END SELECT
DO
LOOP WHILE INKEY$ = ""
END SUB

SUB playmenu (land(), choice, names$(), currentplayer, sentinent(), gold(), playerscastles(), movement(), xposcastle(), yposcastle(), homearmy(), soldiers(), knights(), catapults(), xposarmy(), players)

COLOR 6

IF sentinent(currentplayer) = 0 THEN
'CALL makechoice(players, downs, currentplayer, gold(),numofcastles(), movement(), skillevel)
END IF
comm$ = "What would thou have us do,"'names$(currentplayer) ;":"
comm1$ = "   Build thine holy army?"
comm2$ = "   Raid an enemy castle?"
comm3$ = "  Promote soldiers to thine cause?"
comm4$ = " Train the army for ?  "
comm5$ = "Build a castle?"
comm6$ = " Look at the Map?  "
comm7$ = "  Save the Game?   "
IF gold(currentplayer) > 9999 THEN add = 2
IF gold(currentplayer) > 999 THEN add = 1
IF gold(currentplayer) < 100 THEN add = -1

LOCATE 6, 9: PRINT "What should we do next?  You have"
LOCATE 7, 10: PRINT gold(currentplayer); "gold"
LOCATE 7, 9 + 11 + add: PRINT names$(currentplayer)
LOCATE 7, 9 + 10 + LEN(names$(currentplayer)) + add: PRINT "."
LOCATE 9, 8: PRINT comm1$
LOCATE 11, 8: PRINT comm2$
LOCATE 13, 8: PRINT comm3$
LOCATE 15, 8: PRINT comm4$
LOCATE 17, 8: PRINT comm5$
LOCATE 19, 8: PRINT comm6$
LOCATE 21, 8: PRINT comm7$

h = 18

x = 0
row = 8
COLOR 9
LOCATE h - 9, 8: PRINT comm1$
DO
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""

choice$ = RIGHT$(choice$, 1)
IF choice$ = "8" THEN choice$ = CHR$(up)
IF choice$ = "2" THEN choice$ = CHR$(down)




SELECT CASE choice$

        CASE CHR$(up)
        IF row = 8 THEN BEEP
        IF row <> 8 THEN
         
               SELECT CASE row
              
                CASE 14
                COLOR 6
                LOCATE h + 3, 8: PRINT comm7$
                row = row - 1
                COLOR 9
                LOCATE h + 1, 8: PRINT comm6$
              
                CASE 13
                COLOR 6
                LOCATE h + 1, 8: PRINT comm6$
                row = row - 1
                COLOR 9
                LOCATE h - 1, 8: PRINT comm5$
              
                CASE 12
                COLOR 6
                LOCATE h - 1, 8: PRINT comm5$
                row = row - 1
                COLOR 9
                LOCATE h - 3, 8: PRINT comm4$
              
                CASE 11
                COLOR 6
                LOCATE h - 3, 8: PRINT comm4$
                row = row - 1
                COLOR 9
                LOCATE h - 5, 8: PRINT comm3$
              
                CASE 10
                COLOR 6
                LOCATE h - 5, 8: PRINT comm3$
                row = row - 1
                COLOR 9
                LOCATE h - 7, 8: PRINT comm2$
                          
                CASE 9
                COLOR 6
                LOCATE h - 7, 8: PRINT comm2$
                row = row - 1
                COLOR 9
                LOCATE h - 9, 8: PRINT comm1$
              
                END SELECT
      
        END IF



        CASE CHR$(down)
            IF row = 14 THEN BEEP
            IF row <> 14 THEN

                SELECT CASE row
              
                CASE 8
                COLOR 6
                LOCATE h - 9, 8: PRINT comm1$
                row = row + 1
                COLOR 9
                LOCATE h - 7, 8: PRINT comm2$
              
                CASE 9
                COLOR 6
                LOCATE h - 7, 8: PRINT comm2$
                row = row + 1
                COLOR 9
                LOCATE h - 5, 8: PRINT comm3$
              
                CASE 10
                COLOR 6
                LOCATE h - 5, 8: PRINT comm3$
                row = row + 1
                COLOR 9
                LOCATE h - 3, 8: PRINT comm4$
              
                CASE 11
                COLOR 6
                LOCATE h - 3, 8: PRINT comm4$
                row = row + 1
                COLOR 9
                LOCATE h - 1, 8: PRINT comm5$
              
                CASE 12
                COLOR 6
                LOCATE h - 1, 8: PRINT comm5$
                row = row + 1
                COLOR 9
                LOCATE h + 1, 8: PRINT comm6$
                          
                CASE 13
                COLOR 6
                LOCATE h + 1, 8: PRINT comm6$
                row = row + 1
                COLOR 9
                LOCATE h + 3, 8: PRINT comm7$
              
                END SELECT
             END IF

        CASE CHR$(enter)
        choice = row
        EXIT SUB
        CASE ELSE
        BEEP
END SELECT

LOOP


END SUB

SUB raidcastle (scenario, xposcastle(), yposcastle(), names$(), currentplayer, gold(), homearmy(), playerscastles(), players)
CLS
PALETTE
c = 100
  place = currentplayer
  FOR i = 1 TO players
  currentplayer = i
  FOR j = 1 TO 4
  IF xposcastle(j, i) <> 0 THEN
  x = xposcastle(j, i)
  y = yposcastle(j, i)
  q = currentcolor(currentplayer, playerscastles())
  CALL castle(x, y, q)
  END IF
  NEXT j
  NEXT i
  currentplayer = place

COLOR 0
LINE (17 * 8, 21.5 * 16)-(57 * 8, 24 * 16 + (players * 16)), , BF
COLOR 4
LOCATE 23, 20: PRINT "Who's castle would you like to raid?"
x = players
a = 0

        FOR i = 1 TO x
        a = a + 1
        IF i <> currentplayer THEN
        LOCATE 23 + a, 24: PRINT a
        LOCATE 23 + a, 26: PRINT ". "; names$(i)
        dis = LEN(names$(i))
        LOCATE 23 + a, 27 + dis: PRINT "'s"
        ELSE
        a = i - 1
        END IF
        NEXT i

LOCATE 24 + a, 20: PRINT "Enter the number of the swine to rob."
' 49 - 53 = ascii code numbers for numbers 1 - 5
DIM playspos(players - 1)

DO
FOR B = 1 TO players - 1
c = B
IF B >= currentplayer THEN
c = B + 1
END IF
playspos(B) = c
NEXT B

DO
1
choice$ = INKEY$
LOOP WHILE choice$ = ""

choice$ = RIGHT$(choice$, 1)
RANDOMIZE TIMER
winlose = -5
SELECT CASE choice$

CASE CHR$(49)
chance = (homearmy(4, playspos(1)) * (RND * 30)) / 100
IF chance >= 9 THEN
winlose = 1
ELSE
loseto = playspos(1)
winlose = 0
END IF

CASE CHR$(50)
IF 2 >= players THEN GOTO 1
chance = (homearmy(4, playspos(2)) * (RND * 30)) / 100
IF chance >= 9 THEN
winlose = 2
ELSE
loseto = playspos(2)
winlose = 0
END IF

CASE CHR$(51)
IF 3 >= players THEN GOTO 1
chance = (homearmy(4, playspos(3)) * (RND * 30)) / 100
IF chance >= 9 THEN
loseto = playspos(3)
winlose = 3
ELSE
winlose = 0
END IF

CASE CHR$(52)
IF 4 >= players THEN GOTO 1
chance = (homearmy(4, playspos(4)) * (RND * 30)) / 100
IF chance >= 9 THEN
winlose = 4
ELSE
loseto = playspos(4)
winlose = 0
END IF
END SELECT

IF winlose > 0 THEN
COLOR 0
LINE (320 - (8 * 11), 13.5 * 16)-(320 + (8 * 14), 15.5 * 16), , BF
COLOR 4
LOCATE 15, 31: PRINT "The raid was a success!"
newmoney = CINT(gold(playspos(winlose)) * .6)
gold(playspos(winlose)) = gold(playspos(winlose)) - newmoney
gold(currentplayer) = gold(currentplayer) + newmoney
DO
LOOP WHILE INKEY$ = ""
EXIT SUB
END IF

IF winlose = 0 THEN
COLOR 0
LINE (320 - (8 * 11), 13.5 * 16)-(320 + (8 * 23), 18.5 * 16), , BF
COLOR 4
LOCATE 15, 31: PRINT "The raid was a failure.  Some of"
LOCATE 16, 31: PRINT "your best chieftains have been  "
LOCATE 17, 31: PRINT "captured.  For their mandatory  "

LOCATE 18, 31: PRINT "return you must pay"; CINT(gold(currentplayer) * .4); "!"
valuelost = CINT(gold(currentplayer) * .4)
gold(currentplayer) = gold(currentplayer) - valuelost
gold(loseto) = gold(loseto) + valuelost
DO
LOOP WHILE INKEY$ = ""
EXIT SUB
END IF

LOOP




END SUB

SUB savegame (comland(), scenario, skillevel(), movement(), names$(), players, soldiers(), knights(), catapults(), gold(), xposarmy(), yposarmy(), land(), playerscastles(), numofcastles(), homearmy(), xposcastle(), yposcastle(), currentplayer,  _
landposition())
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
FILES "*.SVE"

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
             '   |         5    1    5    2    5    3    5    |
LOCATE 5, column:  PRINT "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"'  5
LOCATE 6, column:  PRINT "º ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄ¿         º"'
LOCATE 7, column:  PRINT "º ³                 ³ ³ÚÄÄÄÄÄÄ¿ º"'
LOCATE 8, column:  PRINT "º ³                 ÃÄ´³ SAVE ³ º"'
LOCATE 9, column:  PRINT "º ³                 ³ ³ÀÄÄÄÄÄÄÙ º"'
LOCATE 10, column: PRINT "º ³                 ³ ³ÚÄÄÄÄÄÄ¿ º"' 1
LOCATE 11, column: PRINT "º ³                 ³ ³³DELETE³ º"'
LOCATE 12, column: PRINT "º ³                 ³ ³ÀÄÄÄÄÄÄÙ º"'
LOCATE 13, column: PRINT "º ³                 ³ ³ÚÄÄÄÄÄÄ¿ º"'
LOCATE 14, column: PRINT "º ³                 ³ ³³CANCEL³ º"'
LOCATE 15, column: PRINT "º ³                 ³ ³ÀÄÄÄÄÄÄÙ º"'  5
LOCATE 16, column: PRINT "º ³                 ÃÄ´ÚÄÄÄÄÄÄ¿ º"'
LOCATE 17, column: PRINT "º ³                 ³ ³³ QUIT ³ º"'
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
                LOCATE 6 + i, 8: PRINT title$
                title$(i) = title$
        END IF
        CLOSE #i
        LENGTH = 12
NEXT i
row = 1: column = 7: side = 1: fun = 1
DO
diskfile$ = "game" + CHR$(48 + row) + ".sve"
'LOCATE 1, 1: PRINT diskfile$
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
                LOCATE 7, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 8, column + 20: PRINT "³ SAVE ³"'
                LOCATE 9, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
        CASE 2
                LOCATE 10, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 11, column + 20: PRINT "³DELETE³"'
                LOCATE 12, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
     
        CASE 3
                LOCATE 13, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 14, column + 20: PRINT "³CANCEL³"'
                LOCATE 15, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
     
        CASE 4
                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 17, column + 20: PRINT "³ QUIT ³"'
                LOCATE 18, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
     
        END SELECT
        END IF
CASE CHR$(right)
        IF side = 1 AND editname = 0 THEN
                        COLOR 4
                        LINE (45, row * 8 + 39)-(23 * 8, row * 8 + 47), , B
        side = 2
        COLOR 4
        SELECT CASE fun
        CASE 1
                LOCATE 7, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 8, column + 20: PRINT "³ SAVE ³"'
                LOCATE 9, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
        CASE 2
                LOCATE 10, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 11, column + 20: PRINT "³DELETE³"'
                LOCATE 12, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
      
        CASE 3
                LOCATE 13, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 14, column + 20: PRINT "³CANCEL³"'
                LOCATE 15, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
      
        CASE 4
                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                LOCATE 17, column + 20: PRINT "³ QUIT ³"'
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
                                                LOCATE 7, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 8, column + 20: PRINT "³ SAVE ³"'
                                                LOCATE 9, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                        CASE 2
                                                LOCATE 10, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 11, column + 20: PRINT "³DELETE³"'
                                                LOCATE 12, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                     
                                        CASE 3
                                                LOCATE 13, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 14, column + 20: PRINT "³CANCEL³"'
                                                LOCATE 15, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                     
                                        CASE 4
                                                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 17, column + 20: PRINT "³ QUIT ³"'
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
                IF fun < 4 THEN
                        fun = fun + 1
                      
                        FOR i = 1 TO 2
                                IF i = 1 THEN
                                COLOR 15
                                ELSE
                                COLOR 4
                                END IF
                                SELECT CASE fun + i - 2
                                        CASE 1
                                                LOCATE 7, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 8, column + 20: PRINT "³ SAVE ³"'
                                                LOCATE 9, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                        CASE 2
                                                LOCATE 10, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 11, column + 20: PRINT "³DELETE³"'
                                                LOCATE 12, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                    
                                        CASE 3
                                                LOCATE 13, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 14, column + 20: PRINT "³CANCEL³"'
                                                LOCATE 15, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
                                    
                                        CASE 4
                                                LOCATE 16, column + 20: PRINT "ÚÄÄÄÄÄÄ¿"'
                                                LOCATE 17, column + 20: PRINT "³ QUIT ³"'
                                                LOCATE 18, column + 20: PRINT "ÀÄÄÄÄÄÄÙ"'
    
                                END SELECT
                        NEXT i
                ELSE
                        BEEP
                END IF
        END IF


CASE CHR$(enter)
        SELECT CASE side
        CASE 1
                o = 1
                o = LEN(title$(row)) + 1
                IF o = 0 THEN o = 1
                DO
                      
                        'LOCATE 1, 1: PRINT title$(row) + "                "
                      
                        IF choice$ = CHR$(8) AND o = 1 THEN
                        LOCATE row + 6, o + 7: PRINT " "
                        END IF
                        DO
                                choice$ = INKEY$
                        LOOP WHILE choice$ = ""
                        choice$ = RIGHT$(choice$, 1)
                      
                      
                        IF choice$ = CHR$(8) AND o > 1 THEN
                        choice$ = ""
                        IF o > 1 THEN
                        title$(row) = LEFT$(title$(row), o - 2)
                        ELSE
                        title$(row) = LEFT$(title$(row), o - 1)
                        END IF
                        LOCATE row + 6, o + 6: PRINT " "
                        o = o - 2
                      
                        END IF
                      
                        IF choice$ = CHR$(enter) THEN
                        COLOR 4
                        LINE (45, row * 8 + 39)-(23 * 8, row * 8 + 47), , B
                              
                                EXIT DO
                        END IF
                      
                        IF o < 17 AND choice$ <> CHR$(8) THEN
                        title$(row) = title$(row) + choice$
                        LOCATE row + 6, 7 + o: PRINT choice$
                        END IF
                      
                        IF o < 17 THEN
                        o = o + 1
                        END IF
                       
                LOOP
        CASE 2
                SELECT CASE fun
                CASE 1 'save
                        IF title$(row) <> "" THEN
                        LOCATE 19, 6: PRINT " Saving .... "
                        diskfile$ = "game" + CHR$(48 + row) + ".sve"
                        KILL diskfile$
                        OPEN diskfile$ FOR OUTPUT AS #1
                      
                        WRITE #1, title$(row), players, currentplayer, scenario
                      
                        FOR i = 1 TO 32
                        FOR j = 1 TO 24
                        WRITE #1, landposition(i, j)
                        WRITE #1, comland(i, j)
                        NEXT j
                        NEXT i
                      
                        FOR i = 1 TO players
                        WRITE #1, names$(i), soldiers(i), knights(i), catapults(i), gold(i), xposarmy(i), yposarmy(i), land(i), playerscastles(i), numofcastles(i), skillevel(i), movement(i)
                       
                      
                        FOR j = 1 TO 4
                        WRITE #1, xposcastle(j, i), yposcastle(j, i)
                        WRITE #1, homearmy(j, i)
                        NEXT j
                        NEXT i
                      
                      
                        CLOSE #1
                        LOCATE 19, 6: PRINT "             "
                        END IF
                CASE 2 'delete
                        diskfile$ = "game" + CHR$(48 + row) + ".sve"
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
                CASE 4 'quit
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
                                SYSTEM
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

SUB statusreport (currentplayer, playerscastles(), movement(), xposcastle(), yposcastle(), gold(), land(), homearmy(), soldiers(), knights(), catapults(), names$(), xposarmy(), players)

SCREEN 12
CLS
WIDTH 80, 30
KEY OFF

LINE (0, 0)-(213, 479), , B
LINE (213, 0)-(426, 479), , B
LINE (213, 0)-(639, 479), , B
LINE (0, 240)-(642, 240)
colornumber = 65536 * 30 + 256 * 30 + 30
PALETTE 0, colornumber
colornumber = 65536 * 1 + 256 * 1 + 1
PALETTE 8, colornumber
COLOR 8
PAINT (0, 0), , 0
placehold = currentplayer
PAINT (320, 400), , 8
FOR r = 1 TO 5 - players
SELECT CASE r
CASE 1
x = 600: y = 400
CASE 2
x = 30: y = 400
CASE 3
x = 600: y = 30
CASE 4
x = 320: y = 400
END SELECT
PAINT (x, y), , 8
NEXT r
placehold = currentplayer
FOR a = 1 TO players
currentplayer = a
COLOR currentcolor(currentplayer, playerscastles())
SELECT CASE a
CASE 1
x = 0: y = 0
CASE 2
x = 213: y = 0
CASE 3
x = 426: y = 0
CASE 4
x = 0: y = 240
CASE 5
x = 426: y = 240
END SELECT
FOR B = 1 TO 7
LINE (x + B, y + B)-(x + 213 - B, y + 240 - B), , B
NEXT B
NEXT a
currentplayer = placehold

FOR status = 1 TO players
place = currentplayer
currentplayer = status
COLOR currentcolor(currentplayer, playerscastles())
currentplayer = place
SELECT CASE status
CASE 1
x = 1: y = 1
CASE 2
x = 213: y = 1
CASE 3
x = 426: y = 1
CASE 4
x = 1: y = 240
CASE 5
x = 426: y = 240
END SELECT

FOR w = 1 TO 4
IF xposcastle(w, status) <> 0 OR yposcastle(w, status) <> 0 THEN
numofcast = 1 + numofcast
END IF
NEXT w
NAME$ = names$(status)
' if len$(names$(2)) >  'whatever
income = land(status) * 5 + (land(status) * 5) * numofcast / 4
column = x / 8 + 3
LOCATE y / 16 + 2, column:  PRINT "Player:"; status
LOCATE y / 16 + 3, column:  PRINT "Name:"; NAME$
LOCATE y / 16 + 4, column:  PRINT "Land Squares:"; land(status)
LOCATE y / 16 + 5, column: PRINT "Gold"; gold(status)
LOCATE y / 16 + 5, column + 11: PRINT "Income"; CINT(income)

'LOCATE y / 16 + 6, column:  PRINT "Size of Campaign Army"
IF column < 50 THEN
LOCATE y / 16 + 6, column:  PRINT "Soldiers:", soldiers(status)
LOCATE y / 16 + 7, column: PRINT "Knights:", knights(status)
LOCATE y / 16 + 8, column: PRINT "Catapults:", catapults(status)
ELSE
LOCATE y / 16 + 6, column:  PRINT "Soldiers:"
LOCATE y / 16 + 7, column: PRINT "Knights:"
LOCATE y / 16 + 8, column: PRINT "Catapults:"
LOCATE y / 16 + 6, column + 11: PRINT soldiers(status)
LOCATE y / 16 + 7, column + 11: PRINT knights(status)
LOCATE y / 16 + 8, column + 11: PRINT catapults(status)
END IF
KEY OFF
'LOCATE y / 16 +  9, COLUMN: PRINT "Number of Castles"; numofcast
u = numofcast - 1
IF numofcast > 1 THEN
        FOR F = 1 TO u
        LOCATE y / 16 + 8 + F, column: PRINT "Castle"; F; ":"; homearmy(F, status); "Soldiers"
        NEXT F
END IF

LOCATE y / 16 + 12, column: PRINT "Home Castle:"; homearmy(4, status); "Men"
numofcast = 0
LOCATE y / 16 + 13, column: PRINT "Movement of Army"; movement(status)
NEXT status


DO
LOOP WHILE INKEY$ = ""
PALETTE
END SUB

