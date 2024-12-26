grammar Euporia;
options { tokenVocab=EuporiaLexer; }
start: pageNumber? (numbZone|mainZone|mrgTextZoneIn|mrgTextZoneOut|mrgTextZoneUp|mrgTextZoneLow|graphZoneFig|graphZoneOrnam|musicZone)+;

pageNumber: EQ EQ EQ num EQ EQ EQ NL+; //PageNumber ===NN===

numbZone: LBRAK LBRAK num RBRAK RBRAK NL+; //NumberingZone [[NN]]
mainZone: line+; //MainZone
mrgTextZoneIn: MARGIN_IN line+; //MarginTextZone:inner [MARGIN-IN]
mrgTextZoneOut: MARGIN_OUT line+; //MarginTextZone:outer [MARGIN-OUT]
mrgTextZoneUp: MARGIN_UP line+; //MarginTextZone:upper [MARGIN-UP]
mrgTextZoneLow: MARGIN_LOW line+; //MarginTextZone:lower [MARGIN-LOW]
graphZoneFig: OPEN_FIG figId ZONE_CLOSE; //GraphicZone:figure [FIGURE: ID (...)]
graphZoneOrnam: OPEN_ORNAM ornamId ZONE_CLOSE; //GraphicZone:ornamentation [ORNAMENTATION: ID (…)]
musicZone: OPEN_MUSIC musicId ZONE_CLOSE; //MusicZone [MUSIC: ID (...)]

line: numRef (dfSegment|hdLineExerc|hdLineLesson|hdLineMargin|hdLinePart1|hdLinePart2|hdLinePart3|hdLineSect|hdLineTitle|addition|pencilAddition|deletion|pencilDeletion|interlinearAddition|interlinearPencilAddition|interlinearCorrection|interlinearPencilCorrection)+ NL+;

num: NUM+;
numRef: num DOT;
figId: NUM+;
ornamId: NUM+;
musicId: NUM+;

textSeq: (ALPHASEQ|NUM)+; 

dfSegment: textSeq; //DefaultSegment 
hdLineExerc: EXERCISE textSeq; //HeadingLine:exercise #EXERCISE: …
hdLineLesson: LESSON textSeq;  //HeadingLine:lesson #LESSON: …
hdLineMargin: MARGIN textSeq;  //HeadingLine:margin #MARGIN …
hdLinePart1: HASH textSeq; //HeadingLine:part#1 # …
hdLinePart2: HASH HASH textSeq; //HeadingLine:part#2 ## …
hdLinePart3: HASH HASH HASH textSeq; //HeadingLine:part#3 ### …
hdLineSect: HASH HASH HASH HASH textSeq; //HeadingLine:section #### … 
hdLineTitle: TITLE textSeq; //HeadingLine:title #TITLE: …
addition: OPEN_ADDITION textSeq RCURL; //CustomLine:addition +{...}
pencilAddition: OPEN_PENCIL_ADDITION textSeq RCURL; //CustomLine:addition#pencil +!{...} 
deletion: OPEN_DELETION textSeq RCURL; //CustomLine:deletion –{...}
pencilDeletion: OPEN_PENCIL_DELETION textSeq RCURL; //CustomLine:deletion#pencil –!{...}
interlinearAddition: OPEN_IL_ADDITION textSeq RCURL; //InterlinearLine:addition \+{...}
interlinearPencilAddition: OPEN_IL_PENCIL_ADDITION textSeq RCURL; //InterlinearLine:addition#pencil \+!{...}
interlinearCorrection: OPEN_IL_CORRECTION textSeq RCURL; //InterlinearLine:correction \={...}
interlinearPencilCorrection: OPEN_IL_PENCIL_CORRECTION textSeq RCURL; //InterlinearLine:correction#pencil \=!{...}
