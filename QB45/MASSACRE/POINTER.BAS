CALL pointer

'
SUB pointer
x1 = 0: x2 = 25: y1 = 0: y2 = 25
DIM blackspot(dimsize(x1, x2, y1, y2))
GET (0, 0)-(20, 20), blackspot
COLOR 0
LINE (0, 0)-(20, 20), , BF
COLOR 4
LINE (12, 5)-(12, 10)
LINE (12, 14)-(12, 19)
LINE (5, 12)-(10, 12)
LINE (14, 12)-(19, 12)
DIM cross(dimsize(x1, x2, y1, y2))
GET (0, 0)-(20, 20), cross
PUT (0, 0), blackspot, PSET
ERASE blackspot
x = 300
y = 300
PUT (x, y), cross, XOR

movement = 10
DO
b = x: c = y
LOCATE 1, 1: PRINT "x="; x + 12
LOCATE 2, 1: PRINT "y="; y + 12
spot = POINT(x + 12, y + 12)
LOCATE 3, 1: PRINT "Color at center="; spot
DO
choice$ = INKEY$
LOOP WHILE choice$ = ""
choice$ = RIGHT$(choice$, 1)

SELECT CASE choice$
CASE ","
IF movement > 1 THEN
movement = movement - 1
ELSE
BEEP
END IF
CASE "."
IF movement < 20 THEN
movement = movement + 1
ELSE
BEEP
END IF
CASE CHR$(up)
 IF y - movement < 0 THEN
 BEEP
 ELSE
 y = y - movement
 END IF
CASE CHR$(down)
 IF y + movement > 480 THEN
 BEEP
 ELSE
 y = y + movement
 END IF
CASE CHR$(left)
 IF x - movement < 0 THEN
 BEEP
 ELSE
 x = x - movement
 END IF
CASE CHR$(right)
 IF x + movement > 640 THEN
 BEEP
 ELSE
 x = x + movement
 END IF
CASE CHR$(enter)
 obnum = obnum + 1
 locx = CINT(x / 8)
 locy = CINT(y / 16)
 LOCATE locy, locx: PRINT obnum
 LOCATE locy, locx + 2: PRINT "x="; x + 12
 LOCATE locy + 1, locx: PRINT "  y="; y + 12
CASE CHR$(esc)
CASE ELSE
BEEP
END SELECT
 PUT (b, c), cross, XOR
 PUT (x, y), cross, XOR
LOOP
END SUB

'

