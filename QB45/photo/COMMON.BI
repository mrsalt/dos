DEFINT A-Z
CONST Yes = -1
CONST No = 0
CONST Debug = No
CONST CharH = 16
CONST CharW = 8
CONST MenuY = 10
CONST MenuX = 27
CONST Margin = 11

COMMON SHARED Pal AS STRING * 768
COMMON SHARED TemplateFileName AS STRING * 12
COMMON SHARED TextColor AS INTEGER
COMMON SHARED HighColor AS INTEGER
COMMON SHARED TotalItems AS INTEGER
COMMON SHARED ErrNum
COMMON SHARED Title$()
COMMON SHARED FPos() AS LONG
COMMON SHARED CurPos AS LONG
COMMON SHARED MainMenu() AS STRING * 20
COMMON SHARED EditMenu() AS STRING * 12
COMMON SHARED CopyMenu() AS STRING * 15
COMMON SHARED PrntMenu() AS STRING * 20
COMMON SHARED CstmMenu() AS STRING * 35
COMMON SHARED ColorMenu() AS STRING * 35
COMMON SHARED Months() AS STRING * 9
COMMON SHARED Quarters() AS STRING * 6
COMMON SHARED Modes() AS STRING * 7
COMMON SHARED Text() AS STRING * 40
COMMON SHARED BufText() AS STRING * 40
COMMON SHARED MaxLines() AS INTEGER
COMMON SHARED BufMaxLines AS INTEGER
COMMON SHARED TemplateText() AS STRING * 40
COMMON SHARED TemplateLength AS INTEGER
COMMON SHARED Month AS INTEGER
COMMON SHARED Quarter AS INTEGER
COMMON SHARED Year AS INTEGER
COMMON SHARED NewMonthDef AS INTEGER
COMMON SHARED MonthData() AS LONG
COMMON SHARED QuartData() AS LONG
COMMON SHARED YearData() AS LONG
COMMON SHARED MonthMax() AS LONG
COMMON SHARED QuartMax() AS LONG
COMMON SHARED MonthLow AS LONG
COMMON SHARED QuartLow AS LONG
COMMON SHARED Item() AS STRING * 12

DECLARE SUB EditColors ()
DECLARE SUB DrawColorMenu (MenuC%, MenuR%, EditColor%, Red%, Green%, Blue%, FRed%, FGreen%, FBlue%, LRed%, LGreen%, LBlue%)
DECLARE SUB ChangeNewMonthDefault ()
DECLARE SUB EditList ()
DECLARE FUNCTION BlankRow% (Text$, NumChars%)
DECLARE SUB LoadTemplate ()
DECLARE FUNCTION GetAnswer$ (prompt$, MaxLen%)
DECLARE SUB LoadConfig ()
DECLARE SUB SaveConfiguration ()
DECLARE SUB Customize ()
DECLARE SUB CombineInfo ()
DECLARE SUB PrintStuff ()
DECLARE FUNCTION TotalHighest& (Mode%, MonthMax&(), QuartMax&(), Selected%(), TotalItems%, Low&)
DECLARE SUB Graph ()
DECLARE SUB Paste (NewMonth, Row, Column, ActiR, ActiC, ActuR, ActuC, CurLine, Mode)
DECLARE SUB Copy (PreChoice)
DECLARE FUNCTION AreYouSure% (Text$)
DECLARE FUNCTION TotalSimLines& (TextToFind$, Mode%, Month%, Quarter%, Year%)
DECLARE FUNCTION ConvertMoneyToString$ (Money&)
DECLARE FUNCTION GetMoney& (Text$)
DECLARE SUB EditRow (Choice$, ActuC%, ActiC%, ActuR%, ActiR%, CurLine%, Row%, Column%, Month%, Mode%, Quarter%)
DECLARE SUB SaveRecords ()
DECLARE SUB HighLightRow (Row%, Column%, ActiR%, ActiC%, ActuR%, ActuC%, CurLine%, Month%)
DECLARE SUB BlackTextOut (FgColor%, Text$, Column%, Row%)
DECLARE FUNCTION GetWordPos% (Month%, Row%, StartColumn%)
DECLARE SUB ShowRecords (CurLine%, Mode%, Month%, Quarter%)
DECLARE SUB LoadYear (YearToOpen)
DECLARE FUNCTION FormatMoney$ (Digits%, Money!)
DECLARE FUNCTION Expense! (Mode%, Month%, Quarter%, Year%)
DECLARE SUB SearchAZ (TextToFind$, start&, StopPos&)
DECLARE SUB Search (TextToFind$, start&, StopPos&)
DECLARE FUNCTION Income& (Mode%, Month%, Quarter%, Year%)
DECLARE SUB TextOut (FgColor%, Text$, Column%, Row%)
DECLARE SUB EditRecords ()
DECLARE SUB DrawBackGround ()
DECLARE SUB Load ()

