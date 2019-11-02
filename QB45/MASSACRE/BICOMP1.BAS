CHDIR "C:\QB45"
OPEN "CIVIL0.MAP" FOR BINARY AS #1
OPEN "CIVIL3.MAP" FOR BINARY AS #2

DIM cs(2, 255)
SCREEN 12
WIDTH 80, 60
CLS
DIM l(2)
l(1) = LOF(1)
l(2) = LOF(2)

FOR u = 1 TO 2
     
     DIM BYTE AS STRING * 14892
    
    
     GET u, 1, BYTE

     FOR i = 1 TO LOF(u)
     h = ASC(MID$(BYTE, i, 1))
     cs(u, h) = cs(u, h) + 1
     
     NEXT
    
     CLOSE u
     
NEXT

'FOR u = 1 TO 2
'FOR j = 1 TO 16
'FOR g = 1 TO 16
'LOCATE g, (j - 1) * 6 + 1: PRINT CHR$(g - 1 + (j - 1) * 16) + ":"; cs(u, g - 1 + (j - 1) * 16)
'NEXT
'NEXT
'DO: LOOP WHILE INKEY$ = ""
'NEXT
CLS
FOR i = 0 TO 255
PRINT "1st file"; i; "byte="; cs(1, i), "2nd file"; i; "byte="; cs(2, i)
NEXT

