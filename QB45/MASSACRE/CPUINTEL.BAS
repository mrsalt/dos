DECLARE SUB makechoice (players, nextstep, land(), comland(), downs, currentplayer, gold(), numofcastles(), movement(), skillevel(), soldiers(), knights(), catapults(), homearmy(), xposarmy(), yposarmy())
DECLARE SUB relocate (numofcastles(), playerscastles(), comland(), lose!, xposarmy(), yposarmy(), xposcastle(), yposcastle(), startposx(), startposy())
DECLARE FUNCTION currentcolor (currentplayer!, playerscastles())
CONST pi = 3.14592, yes = 1, no = 0
CONST space = 32, esc = 27, enter = 13, tabkey = 9
CONST down = 80, up = 72, left = 75, right = 77
CONST home = 71, endk = 79, pgdn = 81, pgup = 73
CONST ins = 82, del = 83, null = 0
CONST ctrld = 4, ctrlg = 7, ctrlh = 8, ctrls = 19, ctrlv = 22

'
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
' $INCLUDE: 'c:\qb45\massacre\types.bas'

SUB makechoice (players, nextstep, land(), comland(), downs, currentplayer, gold(), numofcastles(), movement(), skillevel(), soldiers(), knights(), catapults(), homearmy(), xposarmy(), yposarmy())
'*********| The purpose of this subrotine is for the computer to   |************
'*********| decide what he / she will do during the following turn |**********
choice = 3' until nothing better is found to do
'"   Build thine holy army?"
'     - When your enemy has a stronger army and he is near enough to be a
'       THREAT.
'     - When it is advantadgeous to have a strong army
'
'"   Raid an enemy castle?"
'     - never, well very rarely
'
'"  Promote soldiers to thine cause?"
'     - When nothing better is found to do
'     - There is not enough money to do anything better
'
'" Train the army for ?  "
'     - When there are no threats, as often as neccesary increase movement
'     - When you are in a good position to train your army
'
'"Build a castle?"
'     - At the start of the game, and then foritify them
'     - To stay alive in the game
'
'Look at the Map?  "
'     - never
'
'"  Save the Game?   "
'     - never
' * most of the time will be spent training or building the army
IF numofcastles(currentplayer) < 4 AND gold(currentplayer) > 299 THEN
' look at building a new castle

' cx = 100, x = 300 cy = 100 y - 400
' dis = the greater of abs(cx - x) or abs(cy - y)
turnlow = 1000
FOR i = 1 TO 32
        FOR j = 1 TO 24
                cx = i * 20: cy = j * 20
                happen = 0
                FOR k = 1 TO players
                        IF k = currentplayer OR comland(i, j) >= 0 THEN EXIT FOR
                        x = xposarmy(k): y = yposarmy(k)
                        xaxis = ABS(cx - x): yaxis = ABS(cy - y)
                        IF xaxis > yaxis THEN
                                number = ABS(cx - x)
                        ELSE
                                number = ABS(cy - y)
                        END IF
                              
                        IF number < turnlow THEN 'is the lowest of this for next  and the highest overall
                                happen = 1
                                turnlow = number
                        END IF
                NEXT k
        IF turnlow > bestyet AND happen = 1 THEN
                bestyet = turnlow
                bestx = i * 20
                besty = j * 20
        END IF
        turnlow = 1000
        NEXT j
NEXT i


END IF

END SUB

SUB relocate (numofcastles(), playerscastles(), comland(), lose, xposarmy(), yposarmy(), xposcastle(), yposcastle(), startposx(), startposy())
        place = currentplayer: currentplayer = lose

FOR e = 1 TO numofcastles(lose)

        startposx(lose) = xposcastle(5 - e, lose) / 20
        startposy(lose) = yposcastle(5 - e, lose) / 20

FOR q = 1 TO 8
        IF comland(startposx(lose), startposy(lose)) > 1 AND comland(startposx(lose), startposy(lose)) < 15 THEN
                xposarmy(lose) = xposcastle(4, lose)
                yposarmy(lose) = xposcastle(4, lose)
               
                IF comland(startposx(lose), startposy(lose)) = 1 THEN
                land(lose) = land(lose) + 1
                landposition(startposx(lose), startposy(lose)) = currentcolor(currentplayer, playerscastles())
                comland(startposx(lose), startposy(lose)) = currentcolor(currentplayer, playerscastles()) * -1
                END IF
                
                IF (comland(startposx(lose), startposy(lose))) > 1 AND (comland(startposx, startposy(lose))) < 15 THEN
                place = currentplayer: currentplayer = lose
                landposition(startposx(lose), startposy(lose)) = currentcolor(currentplayer, playerscastles())
                currentplayer = place
                land(lose) = land(lose) + 1
                FOR i = 1 TO players
                currentplayer = i
                        IF currentcolor(currentplayer, playerscastles()) = comland(startposx, startposy) THEN
                        land(currentplayer) = land(currentplayer) - 1
                        END IF
                NEXT i
                currentplayer = place
                comland(startposx(lose), startposy(lose)) = currentcolor(currentplayer, playerscastles()) * -1
                END IF
        quit = 1: EXIT FOR
        END IF
       
        SELECT CASE q
        CASE 1: startposx(lose) = startposx(lose) - 1: startposy(lose) = startposy(lose) - 2
        CASE 2: startposx(lose) = startposx(lose) + 1
        CASE 3: startposx(lose) = startposx(lose) + 1
        CASE 4: startposx(lose) = startposx(lose) - 2: startposy(lose) = startposy(lose) + 1
        CASE 5: startposx(lose) = startposx(lose) + 2
        CASE 6: startposx(lose) = startposx(lose) - 2: startposy(lose) = startposy(lose) + 1
        CASE 7: startposx(lose) = startposx(lose) + 2
        END SELECT
NEXT q
IF quit = 1 THEN EXIT FOR
NEXT e
DO WHILE quit = 0
       
       
LOOP


'  |1 |2 |3 |4 |5 |6 |7 |8 |9 |10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|                            
'--                                                                         --
'1
'--                                                                         --
'2
'--                                                                         --
'3
'-                                                                          --
'4
'-                                                                          --
'5
'-                                                                          --
'6
'-                                                                          --
'7
'-                                                                          --
'8                                                                        
'-                                                                          --
'9
'-                                                                          --
'10
'-                                                                          --
'11
'-                                                                          --
'12
'-                                                                          --
'13
'-                                                                          --
'14
'-                                                                          --
'15
'-                                                                          --
'16
'-                                                                          --
'17
'-                                                                          --
'18
'-                                                                          --
'19
'-                                                                          --
'20
'-                                                                          --
'21
'-                                                                          --
'22
'-                                                                          --
'23
'-                                                                          --
'24
'-                                                                          --
'25
'-                                                                          --
'26
'-                                                                          --
'27
'-                                                                          --
'28
'-                                                                          --
'29
'-                                                                          --
'30
'-                                                                          --
'31
'-                                                                          --
'32
'-                                                                          --
'  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

END SUB

SUB showcomp (comland())
CLS
COLOR 15
FOR i = 1 TO 32
FOR j = 1 TO 24
IF comland(i, j) = 0 THEN character$ = " "
IF comland(i, j) = 1 THEN character$ = "ÛÛ"
IF comland(i, j) > 79 THEN character$ = CHR$(16) + CHR$(17)
IF comland(i, j) = -1 THEN character$ = "ºº"
IF comland(i, j) < -1 THEN character$ = CHR$(1)
LOCATE j, i * 2: PRINT character$
NEXT j
NEXT i

END SUB

