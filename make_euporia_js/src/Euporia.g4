grammar Euporia;
options { tokenVocab=EuporiaLexer; }

start: page+; 

page: facsimile (numbZone| mainZone | mrgTextZoneIn | mrgTextZoneOut | mrgTextZoneUp | mrgTextZoneLow | graphZoneFig | graphZoneOrnam | musicZone)*;

facsimile: FAC num RBRAK NL+;
numbZone: LBRAK LBRAK (num|textSeq|operation) RBRAK RBRAK NL+; //NumberingZone [[NN]]
mainZone: (sectionHeading | openPar| line | placeholder | reference | expl)+;

sectionHeading: level sectionType line;
level: HASH+;
sectionType: seg;

openPar: NEW_PARAGRAPH;

mrgTextZoneIn: MARGIN_IN line+ RBRAK NL*; //MarginTextZone:inner [MARGIN-IN]
mrgTextZoneOut: MARGIN_OUT (line|placeholder|reference|expl)+ RBRAK  NL*; //MarginTextZone:outer [MARGIN-OUT]
mrgTextZoneUp: MARGIN_UP (line|placeholder|reference|expl)+ RBRAK NL*; //MarginTextZone:upper [MARGIN-UP]
mrgTextZoneLow: MARGIN_LOW (line|placeholder|reference|expl)+ RBRAK NL*; //MarginTextZone:lower [MARGIN-LOW]
graphZoneFig: OPEN_FIG figId ZONE_CLOSE NL*; //GraphicZone:figure [FIGURE: ID (...)]
graphZoneOrnam: OPEN_ORNAM ornamId ZONE_CLOSE NL*; //GraphicZone:ornamentation [ORNAMENTATION: ID (…)]
musicZone: OPEN_MUSIC musicId ZONE_CLOSE NL*; //MusicZone [MUSIC: ID (...)]

line: (textSeq|num|operation| underlined)+ NL*;
underlined: UNDERSCORE (textSeq|num|operation)+ UNDERSCORE;
pencilUnderlined: EMARK UNDERSCORE (textSeq|num|operation)+ UNDERSCORE;

textSeq: (seg | punct)+;
num: NUM+;
numRef: num DOT;
figId: NUM+;
ornamId: NUM+;
musicId: NUM+;
seg: (ALPHASEQ | NUM) DASH? | (prefix operation)|(operation suffix)|(prefix operation suffix)|(operation infix operation);
prefix: (ALPHASEQ|NUM) DASH? CARET;
suffix: CARET (ALPHASEQ|NUM) DASH?;
infix:  CARET (ALPHASEQ|NUM) DASH? CARET;
punct: (DOT|DOTS|COMMA|COLON|SCOLON|EMARK|QMARK|SLASH|LPAR|RPAR|QUOTE_MARK|LOW_QUOTE_MARK|EQ);

operation: (substitution|pencil|addition|pencilAddition|subspencilAddition|deletion|pencilDeletion|subspencilDeletion|phiAdd|phiDel|phiSub);
substitution: (deletion|pencilDeletion|subspencilDeletion) (replace|addition|pencilAddition|subspencilAddition);
replace: SLASH LCURL (textSeq |num| deletion |pencilDeletion|subspencilDeletion)+ RCURL;

pencil: OPEN_PENCIL textSeq RCURL;
addition: OPEN_ADDITION (textSeq |num| deletion |pencilDeletion|subspencilDeletion|phiAdd|phiDel|phiSub)+ RCURL; //CustomLine:addition +{...}
pencilAddition: OPEN_PENCIL_ADDITION (textSeq |num| deletion |pencilDeletion|subspencilDeletion|phiAdd|phiDel|phiSub)+ RCURL; //CustomLine:addition#pencil +!{...}
subspencilAddition: OPEN_SUCCESSIVE_PENCIL_ADDITION (textSeq |num| deletion |pencilDeletion|subspencilDeletion|phiAdd|phiDel|phiSub)+ RCURL; //CustomLine:addition#pencil/subs +!s{...}

deletion: OPEN_DELETION textSeq RCURL; //CustomLine:deletion –{...}
pencilDeletion: OPEN_PENCIL_DELETION textSeq RCURL; //CustomLine:deletion#pencil –!{...}
subspencilDeletion: OPEN_SUCCESSIVE_PENCIL_DELETION textSeq RCURL; //CustomLine:deletion#pencil/subs -!s{...}


placeholder: OPEN_INTERPRETATION INTERPRETATION_CLOSE;
reference: OPEN_REFERENCE line+ INTERPRETATION_CLOSE NL*;
expl: OPEN_EXPLICATION line PIPE line+ INTERPRETATION_CLOSE; //explication ||*expl … | ... ||

phiSub: phiDelete phiReplace;
phiDelete: OPEN_PHI_DEL textSeq;
phiReplace: DOUBLESLASH textSeq DOUBLESLASH;
phiDel: (OPEN_PHI_DEL textSeq DOUBLESLASH);
phiAdd: (OPEN_PHI_ADD textSeq DOUBLESLASH);
