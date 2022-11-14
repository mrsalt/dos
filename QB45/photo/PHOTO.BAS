DEFINT A-Z
' $INCLUDE: 'SVGABC.BI'
' $INCLUDE: 'COMMON.BI'
DIM SHARED Enter AS STRING * 1
DIM SHARED LF AS STRING * 1
DIM FONT AS STRING * 4098
REDIM SHARED Title$(2)
REDIM SHARED FPos(13, 2) AS LONG
REDIM SHARED MainMenu(5) AS STRING * 20
REDIM SHARED EditMenu(4) AS STRING * 12
REDIM SHARED CopyMenu(6) AS STRING * 15
REDIM SHARED PrntMenu(6) AS STRING * 20
REDIM SHARED CstmMenu(7) AS STRING * 35
REDIM SHARED ColorMenu(19) AS STRING * 35
REDIM SHARED Months(12) AS STRING * 9
REDIM SHARED Quarters(4) AS STRING * 6
REDIM SHARED Modes(3) AS STRING * 7
REDIM SHARED Text(12, 100) AS STRING * 40
REDIM SHARED BufText(100) AS STRING * 40
REDIM SHARED MaxLines(12) AS INTEGER
REDIM SHARED TemplateText(50) AS STRING * 40

IF Debug = No THEN
'     ON ERROR GOTO ErrorHandler
END IF
GOSUB Load
VIDEOOFF
DrawBackGround
DRWFILLBOX 1, 0, 100 + 10, 80 + 10, 540 + 10, 400 + 10
DO
DRWFILLBOX 1, 255, 100, 80, 540, 400
VIDEOON
TextOut TextColor, Title$(1), MenuX, MenuY
TextOut TextColor, Title$(2), MenuX, MenuY + 1

RESTORE MainMenu
i = 2
DO
     READ j$
     IF j$ = "END" THEN EXIT DO
     TextOut TextColor, j$, MenuX, MenuY + i
     i = i + 1
LOOP
MOUSESHOW
MOUSERANGESET 230, 210, 385, 290
DO
     IF Row <> ORow THEN
          MOUSEHIDE
          IF ORow > 12 AND ORow < 18 THEN TextOut TextColor, MainMenu(ORow - MenuY - 2), MenuX + 2, ORow
          IF Row > 12 AND Row < 18 THEN TextOut HighColor, MainMenu(Row - MenuY - 2), MenuX + 2, Row
          MOUSESHOW
     END IF
    
     Ox = X: OY = Y
     OColumn = Column: ORow = Row
     MOUSESTATUS X, Y, MButs
     IF MButs AND 1 THEN LBut = Yes ELSE LBut = No
     IF MButs AND 2 THEN RBut = Yes ELSE RBut = No
     Column = X \ CharW
     Row = Y \ CharH
     IF Debug = Yes THEN
          s$ = "x=" + STR$(X) + " y=" + STR$(Y) + "  "
          DRWSTRING 1, 0, 255, s$, 0, 0
          s$ = "Column=" + STR$(Column) + " Row=" + STR$(Row) + "  "
          DRWSTRING 1, 0, 255, s$, 0, 16
     END IF
     Choice$ = INKEY$
LOOP WHILE Choice$ = "" AND LBut = No
IF Choice$ = "1" OR Row = MenuY + 3 THEN
     EditRecords
ELSEIF Choice$ = "2" OR Row = MenuY + 4 THEN
     Graph
ELSEIF Choice$ = "3" OR Row = MenuY + 5 THEN
     PrintStuff
ELSEIF Choice$ = "4" OR Row = MenuY + 6 THEN
     Customize
ELSEIF Choice$ = "5" OR Row = MenuY + 7 THEN
test = RESTEXT
SYSTEM
END IF


LOOP
test = RESTEXT
SYSTEM


F1:

Load:
OPEN "PHOTO.CFG" FOR BINARY AS #1

GET #1, , tit1
GET #1, , tit2
Title$(1) = SPACE$(tit1)
Title$(2) = SPACE$(tit2)
GET #1, , Title$(1)
GET #1, , Title$(2)
GET #1, , TemplateFileName

TotalItems = 20
REDIM SHARED MonthData(12, TotalItems) AS LONG
REDIM SHARED QuartData(4, TotalItems) AS LONG
REDIM SHARED YearData(TotalItems) AS LONG
REDIM SHARED MonthMax(TotalItems) AS LONG
REDIM SHARED QuartMax(TotalItems) AS LONG
REDIM SHARED Item(TotalItems) AS STRING * 12
FOR i = 1 TO 20
Item(i) = SPACE$(12)
NEXT

GET #1, , TotalItems
FOR i = 1 TO TotalItems
GET #1, , Item(i)
NEXT
GET #1, , NewMonthDef
GET #1, , TextColor
GET #1, , HighColor

CLOSE #1

MainMenu(1) = "1.  Edit Records   "
MainMenu(2) = "2.  Graph Data     "
MainMenu(3) = "3.  Print Records  "
MainMenu(4) = "4.  Change config. "
MainMenu(5) = "5.  Exit Program   "

EditMenu(1) = "Save Records"
EditMenu(2) = "Copy to Buff"
EditMenu(3) = "Paste Month "
EditMenu(4) = "Exit Editing"

CopyMenu(1) = "This Month  "
CopyMenu(2) = "Last Month  "
CopyMenu(3) = "1 Year Ago  "
CopyMenu(4) = "Nothing     "
CopyMenu(5) = "Template    "
CopyMenu(6) = "Cancel copy "

PrntMenu(1) = "Month            "
PrntMenu(2) = "Quarter          "
PrntMenu(3) = "Year             "
PrntMenu(4) = "Quarter Summary  "
PrntMenu(5) = "Annual Summary   "
PrntMenu(6) = "Cancel Print     "

CstmMenu(1) = "Change template file name...       "
CstmMenu(2) = "Change background colors...        "
CstmMenu(3) = "Change program title...            "
CstmMenu(4) = "Edit list of critical subtitles... "
CstmMenu(5) = "Change default for new months...   "
CstmMenu(6) = "Save configuration file            "
CstmMenu(7) = "Exit configuration change menu     "

ColorMenu(1) = "Change normal text color (=  )     "
ColorMenu(2) = "Change highlighted text color (=  )"
ColorMenu(3) = "                                   "
ColorMenu(4) = "Edit color #                     "
ColorMenu(5) = "    Red   =   "
ColorMenu(6) = "    Green =   "
ColorMenu(7) = "    Blue  =   "
ColorMenu(8) = "                                   "
ColorMenu(9) = "Edit background colors:            "
ColorMenu(10) = " First color-                      "
ColorMenu(11) = "    Red   =   "
ColorMenu(12) = "    Green =   "
ColorMenu(13) = "    Blue  =   "
ColorMenu(14) = " Last color-                       "
ColorMenu(15) = "    Red   =   "
ColorMenu(16) = "    Green =   "
ColorMenu(17) = "    Blue  =   "
ColorMenu(18) = "                                   "
ColorMenu(19) = "Exit color customization menu      "


Months(1) = "January  "
Months(2) = "February "
Months(3) = "March    "
Months(4) = "April    "
Months(5) = "May      "
Months(6) = "June     "
Months(7) = "July     "
Months(8) = "August   "
Months(9) = "September"
Months(10) = "October  "
Months(11) = "November "
Months(12) = "December "
Quarters(1) = "Winter"
Quarters(2) = "Spring"
Quarters(3) = "Summer"
Quarters(4) = "Fall  "
Modes(1) = "Month  "
Modes(2) = "Quarter"
Modes(3) = "Year   "
Month = VAL(LEFT$(DATE$, 2))
Quarter = (Month - 1) \ 3 + 1
Year = VAL(RIGHT$(DATE$, 4))
CurPos = 1
Enter = CHR$(13)
LF = CHR$(10)
test = WHICHVGA
test = RES640
test = WHICHMOUSE
MOUSEENTER

OPEN "BLOCK.FNT" FOR BINARY AS #1
GET #1, , FONT
CLOSE #1

OPEN "BLUE.PAL" FOR BINARY AS #1
GET #1, , Pal
CLOSE #1

PALSET Pal, 0, 255
'FONTSET FONT

KEY 1, "F1"               ' Left arrow
ON KEY(1) GOSUB F1                    ' Set event trapping for the
KEY(1) ON                                   ' Turn on the keys
LoadTemplate
LoadYear Year

RETURN

MainMenu:

DATA "                     "
DATA "  1.  Edit Records   "
DATA "  2.  Graph Data     "
DATA "  3.  Print Records  "
DATA "  4.  Change config. "
DATA "  5.  Exit Program   "
DATA "END"

ErrorHandler:
ErrNum = ERR
SELECT CASE ErrNum
CASE 25 'Device fault
     IF AreYouSure("The printer may not be ON LINE.Check the printer.Do you wish to print now?") = Yes THEN
          ErrNum = 0
          RESUME
     ELSE
          ErrNum = 25
          RESUME NEXT
     END IF
CASE 52 'Bad file name or number
     errortimes = errortimes + 1
CASE 53 'File not found
     IF AreYouSure("This file does not exist.in the current directory.Do you want to try again?") = Yes THEN
          ErrNum = 53
          RESUME NEXT
     ELSE
          ErrNum = 54
          RESUME NEXT
     END IF
CASE 61 'Disk full

CASE 64 'Bad file name
     errortimes = errortimes + 1
     RESUME NEXT
CASE 71 'Disk not ready

CASE 76 'Path not found
     LOCATE 6, 10: PRINT "Path not found.  Try a different path"
     DO: LOOP WHILE INKEY$ = ""
     LOCATE 6, 10: PRINT "                                     "
     RESUME NEXT
CASE ELSE
     PRINT "Error "; ErrNum; " occured."
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

