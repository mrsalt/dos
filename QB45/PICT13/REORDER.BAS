
CONST plds = 255
DIM byte AS STRING * 768
DIM SHARED picture(101, 121)  AS LONG
DIM piece(plds)
DIM opiece(plds)
DIM opiece$(plds)

CLS
RESTORE neworder
FOR i = 1 TO 142
READ j

IF j = -1 THEN
i = 127
ELSE
piece(i) = j
opiece(j) = i
END IF

NEXT
LOCATE 3, 1: PRINT TIME$
a& = TIMER
OPEN "c:\qb45\pict13\plds\worldmap.dat" FOR BINARY AS #1

FOR j = 0 TO 479
byteposition& = 1 + j * (768)
GET #1, byteposition&, byte

FOR i = 1 TO 768
MID$(byte, i, 1) = CHR$(opiece(ASC(MID$(byte, i, 1))))
NEXT

PUT #1, byteposition&, byte
b& = TIMER
f! = ((j + 1) / (480))
LOCATE 1, 1: PRINT USING "###.##%"; f! * 100
LOCATE 2, 1: PRINT "Hours est:"
LOCATE 2, 12: PRINT USING "#.###"; ((b& - a&) / f!) / 3600
NEXT

CLOSE #1

NAMES:
DATA "BRIDGE1.PLD"
' # 1
DATA "BRIDGE2.PLD"
' # 2
DATA "RIVBEGN2.PLD"
' # 3
DATA "RIVBEGN4.PLD"
' # 4
DATA "RIVBEGN1.PLD"
' # 5
DATA "RIVBEGN3.PLD"
' # 6
DATA "RIVER6.PLD"
' # 7
DATA "RIVER1.PLD"
' # 8
DATA "RIVER3.PLD"
' # 9
DATA "RIVER2.PLD"
' # 10
DATA "RIVER5.PLD"
' # 11
DATA "RIVER4.PLD"
' # 12
DATA "RIVJOIN3.PLD"
' # 13
DATA "RIVJOIN2.PLD"
' # 14
DATA "RIVJOIN4.PLD"
' # 15
DATA "RIVJOIN1.PLD"
' # 16
DATA "RIVJOIN5.PLD"
' # 17
DATA "RIVER7.PLD"
' # 18
DATA "ROAD1.PLD"
' # 19
DATA "ROAD2.PLD"
' # 20
DATA "ROAD3.PLD"
' # 21
DATA "ROAD4.PLD"
' # 22
DATA "ROAD5.PLD"
' # 23
DATA "ROAD6.PLD"
' # 24
DATA "RODJOIN1.PLD"
' # 25
DATA "RODJOIN2.PLD"
' # 26
DATA "RODJOIN3.PLD"
' # 27
DATA "RODJOIN4.PLD"
' # 28
DATA "RODJOIN5.PLD"
' # 29
DATA "ROAD7.PLD"
' # 30
DATA "SHORE3.PLD"
' # 31
DATA "SHORE4.PLD"
' # 32
DATA "SHORE1.PLD"
' # 33
DATA "SHORE2.PLD"
' # 34
DATA "SHORE10.PLD"
' # 35
DATA "SHORE8.PLD"
' # 36
DATA "SHORE9.PLD"
' # 37
DATA "SHORE5.PLD"
' # 38
DATA "SHORE11.PLD"
' # 39
DATA "SHORE7.PLD"
' # 40
DATA "SHORE12.PLD"
' # 41
DATA "SHORE6.PLD"
' # 42
DATA "MOUTH1.PLD"
' # 43
DATA "MOUTH2.PLD"
' # 44
DATA "MOUTH4.PLD"
' # 45
DATA "MOUTH3.PLD"
' # 46
DATA "BRIDGE3.PLD"
' # 47
DATA "BRIDGE4.PLD"
' # 48
DATA "BRIDGE6.PLD"
' # 49
DATA "BRIDGE7.PLD"
' # 50
DATA "BRIDGE8.PLD"
' # 51
DATA "BRIDGE5.PLD"
' # 52
DATA "MOUNTAN1.PLD"
' # 53
DATA "MOUNTAN2.PLD"
' # 54
DATA "MOUNTAN3.PLD"
' # 55
DATA "MOUNTAN4.PLD"
' # 56
DATA "MOUNTAN5.PLD"
' # 57
DATA "MOUNTAN6.PLD"
' # 58
DATA "MOUNTAN7.PLD"
' # 59
DATA "MOUNTAN8.PLD"
' # 60
DATA "MOUNTAN9.PLD"
' # 61
DATA "MOUNTA10.PLD"
' # 62
DATA "MOUNTA11.PLD"
' # 63
DATA "MOUNTA12.PLD"
' # 64
DATA "MOUNTA13.PLD"
' # 65
DATA "MOUNTA14.PLD"
' # 66
DATA "MOUNTA15.PLD"
' # 67
DATA "MOUNTA16.PLD"
' # 68
DATA "FOREST2.PLD"
' # 69
DATA "FOREST1.PLD"
' # 70
DATA "FOREST3.PLD"
' # 71
DATA "FOREST4.PLD"
' # 72
DATA "TREES1.PLD"
' # 73
DATA "TREES2.PLD"
' # 74
DATA "WALL1.PLD"
' # 75
DATA "WALL2.PLD"
' # 76
DATA "WALL3.PLD"
' # 77
DATA "WALL4.PLD"
' # 78
DATA "WALL5.PLD"
' # 79
DATA "WALL6.PLD"
' # 80
DATA "WALL7.PLD"
' # 81
DATA "WALL8.PLD"
' # 82
DATA "WALL9.PLD"
' # 83
DATA "WALL10.PLD"
' # 84
DATA "WALL11.PLD"
' # 85
DATA "WALL12.PLD"
' # 86
DATA "WALL13.PLD"
' # 87
DATA "WALL14.PLD"
' # 88
DATA "WALL15.PLD"
' # 89
DATA "WALL16.PLD"
' # 90
DATA "PLAINS1.PLD"
' # 91
DATA "PLAINS2.PLD"
' # 92
DATA "PLAINS3.PLD"
' # 93
DATA "OCEAN1.PLD"
' # 94
DATA "OCEAN2.PLD"
' # 95
DATA "OCEAN3.PLD"
' # 96
DATA "BOULDER.PLD"
' # 97
DATA "DESERT8.PLD"
' # 98
DATA "DESERT9.PLD"
' # 99
DATA "DESERT6.PLD"
' # 100
DATA "DESERT7.PLD"
' # 101
DATA "DESERT5.PLD"
' # 102
DATA "DESERT2.PLD"
' # 103
DATA "DESERT4.PLD"
' # 104
DATA "DESERT3.PLD"
' # 105
DATA "DESERT1.PLD"
' # 106
DATA "HARBOR1.PLD"
' # 241
DATA "HARBOR2.PLD"
' # 242
DATA "HARBOR3.PLD"
' # 243
DATA "CAVE1.PLD"
' # 244
DATA "CAVE2.PLD"
' # 245
DATA "CAVE3.PLD"
' # 246
DATA "CASTLE1.PLD"
' # 247
DATA "CASTLE2.PLD"
' # 248
DATA "CASTLE3.PLD"
' # 249
DATA "CASTLE4.PLD"
' # 250
DATA "HUT1.PLD"
' # 251
DATA "TOWN1.PLD"
' # 252
DATA "TOWN2.PLD"
' # 253
DATA "TOWN3.PLD"
' # 254
DATA "TOWN4.PLD"
' # 255

neworder:
DATA 1,2                                  
'road/river-bridge
DATA 61,63,60,62                          
'rivbegin
DATA 33,28,30,29,32,31,36,35,37,34,110,116
'rivers
DATA 38,39,40,41,42,43,64,65,66,67,109,115
'road
DATA 46,47,44,45,53,51,52,48,54,50,55,49  
'shores
DATA 22,23,25,24,103,104,106,107,108,105  
'mouths/bridges
DATA 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
'mountains                                                                                                      2,13,14,15,16,17,18,19,20,21      'mountains
DATA 4,3,5,59,56,57                       
'forests/trees
DATA 83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98
'walls
DATA 27,117,118                           
'plains
DATA 26,119,120                           
'oceans
DATA 121                                  
'boulder
DATA 81,82,79,80                          
'deserts
DATA 78,  75,  77,  76                    
'deserts
DATA 74                                   
'deserts

DATA -1

'the next one would be # 241
DATA 71,72,73                           
'harbors
DATA 68,69,70                             
'caves
DATA 111,112,113,114                      
'castle
DATA 58                                   
'huts
DATA 99,100,101,102

SUB loadpics (filename$())
num = 1
FOR f = 1 TO plds
LOCATE 2, 1: PRINT "Opening "; filename$(f); "     "
LOCATE 3, 1: PRINT USING "###%"; CINT(f / plds * 100)
OPEN filename$(f) FOR BINARY AS num
FOR i = 0 TO 101
GET #num, , number&
picture&(i, f) = number&
NEXT
CLOSE num
NEXT


END SUB

