DECLARE SUB getfile (name$)
ON ERROR GOTO errorhandler
DIM number AS INTEGER
DIM test AS INTEGER
DIM mark AS STRING * 20
DIM debt AS LONG
DIM outdebt AS LONG


CLS
CALL getfile(name$)
CLS
PRINT "Do you want to:"
PRINT "1. Search for a given number?"
PRINT "2. Change a number at a known location?"
PRINT "3. Compare two files, to see if two different"
PRINT "   numbers exist in the same location."
PRINT "4. Compare two files, to see where the differences are."

DO
LOCATE 7, 1: PRINT "       "
LOCATE 7, 1: INPUT choice
IF choice = 0 THEN choice = 2
LOOP UNTIL (choice > 0 AND choice < 5)

CLS
SELECT CASE choice
CASE 1
INPUT "Enter number to search for."; number

FOR i = 1 TO LOF(1) STEP 2
GET 1, i, test
IF test = number THEN
PRINT "Match found at "; i
DO: LOOP WHILE INKEY$ = ""
END IF
NEXT i

CASE 2
PRINT "Enter the record number. (If known)"
PRINT "for the number you want to change. (319)"

DO


     DO
          LOCATE 4, 1: PRINT "            "
          LOCATE 4, 1: INPUT choice
          IF choice = 0 THEN choice = 319
     LOOP WHILE choice < 1 OR choice > LOF(1)
    
     GET #1, choice, number
     LOCATE 5, 1: PRINT "The value in this location is"; number
     LOCATE 6, 1: INPUT "Is this the number you wish to change"; yesno$
    
     IF yesno$ = "" OR LCASE$(yesno$) = "yes" OR LCASE$(yesno$) = "y" THEN
          EXIT DO
     ELSE
          LOCATE 5, 1: PRINT "                                             "
          LOCATE 6, 1: PRINT "                                             "
     END IF
LOOP

IF choice <> 319 THEN
     LOCATE 7, 1: INPUT "Enter number to change to"; number
ELSE
    
     n = FREEFILE
     OPEN "borrow.dat" FOR BINARY AS n
     debt = 30000 - number
     GET n, 1, outdebt
     outdebt = debt + outdebt
     PUT n, 1, outdebt
     PRINT USING "$$#########,.##-has been borrowed."; outdebt
     CLOSE n
     number = 30000
END IF
PUT 1, choice, number

CASE 3
PRINT "Choose the name of the second file."
PRINT "Press a key to continue."
DO: LOOP WHILE INKEY$ = ""
CLS
CALL getfile(name$)
CLS
PRINT "Enter the 2 numbers to look for."
INPUT "First number  (from 1st file)"; number
INPUT "Second number (from 2nd file)"; test
DIM cs(2, 255)

DIM j AS INTEGER
DIM h AS INTEGER
DIM b1 AS STRING * 1
DIM b2 AS STRING * 1

FOR i = 1 TO LOF(1) STEP 2
     LOCATE 1, 1: PRINT i
     GET 1, i, j
     GET 2, i, h
'n1 = ASC(b1)
'n2 = ASC(b2)

IF j = number AND h = test THEN
LOCATE 4, 1: PRINT j; "    "
LOCATE 6, 1: PRINT h; "    "
LOCATE 9, 1: PRINT "record number:"; i

'h = 30000
'PUT 1, i, h
END IF
NEXT
CASE 4
PRINT "Choose the name of the second file."
PRINT "Press a key to continue."
DO: LOOP WHILE INKEY$ = ""
CLS
CALL getfile(name$)
CLS
FOR i = 1 TO LOF(1) STEP 2
     LOCATE 1, 1: PRINT i
     GET 1, i, number
     GET 2, i, test
'n1 = ASC(b1)
'n2 = ASC(b2)

IF number <> test THEN
LOCATE 4, 1: PRINT number; "    "
LOCATE 6, 1: PRINT test; "    "

LOCATE 9, 1: PRINT "record number:"; i
DO: LOOP WHILE INKEY$ = ""
'h = 30000
'PUT 1, i, h
END IF
NEXT

END SELECT
CLOSE #1

'FOR u = 1 TO 2
'FOR j = 1 TO 16
'FOR g = 1 TO 16
'LOCATE g, (j - 1) * 6 + 1: PRINT CHR$(g - 1 + (j - 1) * 16) + ":"; cs(u, g - 1 + (j - 1) * 16)
'NEXT
'NEXT
'DO: LOOP WHILE INKEY$ = ""
'NEXT
errorhandler:
SELECT CASE ERR
CASE 19
PRINT "Error"; ERR; "File not found"
SYSTEM

END SELECT

SUB getfile (name$)

PRINT "Default directory is C:\GAMES\DOSCIV\MARKSAVE"
PRINT "Other directories available:"
PRINT "1.  C:\GAMES\DOSCIV"
PRINT "2.  C:\GAMES\DOSCIV\KIRKSAVE"
INPUT choice
DO
     SELECT CASE choice
     CASE 1
          CHDIR "c:\games\dosciv"
          EXIT DO
     CASE 2
          CHDIR "c:\games\dosciv\kirksave"
          EXIT DO
     CASE 0
          CHDIR "c:\games\dosciv\marksave"
          EXIT DO
     CASE ELSE
          LOCATE 5, 1: INPUT choice
     END SELECT

LOOP
   
CLS
SHELL "dir *.sve /o:d"
LOCATE 13, 1: PRINT "The above files are available for alteration."
PRINT "Enter 0-9 to choose from the above"
    
DO
     LOCATE 15, 1: PRINT "                                                      "
     DO
          LOCATE 15, 1: INPUT choice
          IF choice >= 0 AND choice < 10 THEN
               EXIT DO
          END IF
     LOOP
         
     name$ = "CIVIL" + CHR$(choice + 48) + ".SVE"
    
     n = FREEFILE
     OPEN name$ FOR BINARY AS n
         
     IF LOF(n) = 0 THEN
         
          CLOSE n
          KILL name$
          LOCATE 16, 1: PRINT "File not found or other error. Enter another number."
     ELSE
          EXIT DO
     END IF

LOOP

END SUB

