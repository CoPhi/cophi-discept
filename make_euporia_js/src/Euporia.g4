grammar Euporia;
options { tokenVocab=EuporiaLexer; }

start: page+ apparatoFigure*;

page: facsimile (numbZone| mainZone | mrgTextZoneIn | mrgTextZoneOut | mrgTextZoneUp | mrgTextZoneLow | graphZoneFig | graphZoneParagraph | musicZone)*;

facsimile: FAC num RBRAK NL+;
numbZone: NUMB_ZONE (num|textSeq|operation) RBRAK RBRAK NL+; //NumberingZone [[NN]]
mainZone: (sectionHeading | hdLineMargin| openPar| line | placeholder | reference | expl)+;

hdLineMargin: level MARGIN LBRAK line+ RBRAK;
sectionHeading: level sectionType line;
level: HASH+;
sectionType: seg;

openPar: NEW_PARAGRAPH;

mrgTextZoneIn: MARGIN_IN line+ RBRAK NL*; //MarginTextZone:inner [MARGIN-IN]
mrgTextZoneOut: MARGIN_OUT (sectionHeading | openPar| line|placeholder|reference|expl)+ RBRAK  NL*; //MarginTextZone:outer [MARGIN-OUT]
mrgTextZoneUp: MARGIN_UP (sectionHeading | openPar| line|placeholder|reference|expl)+ RBRAK NL*; //MarginTextZone:upper [MARGIN-UP]
mrgTextZoneLow: MARGIN_LOW (sectionHeading | openPar| line|placeholder|reference|expl)+ RBRAK NL*; //MarginTextZone:lower [MARGIN-LOW]
graphZoneFig: OPEN_FIG figId ZONE_CLOSE NL*?; //GraphicZone:figure [FIGURE: ID (...)]
graphZoneParagraph: OPEN_PARAGRAPHISM paragraphId ZONE_CLOSE NL*; 
musicZone: OPEN_MUSIC musicId ZONE_CLOSE NL*; //MusicZone [MUSIC: ID (...)]

line: (textSeq|num|operation| underlined| ASTERISK)+ NL*;
underlined: UNDERSCORE (textSeq|num|operation)+ UNDERSCORE;
pencilUnderlined: EMARK UNDERSCORE (textSeq|num|operation)+ UNDERSCORE;

textSeq: (seg | punct)+;
num: NUM+;
numRef: num DOT;
figId: NUM+ UNDERSCORE NUM+;
paragraphId: NUM+ UNDERSCORE NUM+;
musicId: NUM+ UNDERSCORE NUM+;
seg: (ALPHASEQ | NUM) DASH? | (prefix operation)|(operation suffix)|(prefix operation suffix)|(operation infix operation);
prefix: (ALPHASEQ|NUM) DASH? CARET;
suffix: CARET (ALPHASEQ|NUM) DASH?;
infix:  CARET (ALPHASEQ|NUM) DASH? CARET;
punct: (DOT|DOTS|COMMA|COLON|SCOLON|EMARK|QMARK|SLASH|LPAR|RPAR|QUOTE_MARK|LOW_QUOTE_MARK|EQ|ASTERISK);

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


placeholder: INTERPRETATION (textSeq | operation) INTERPRETATION;
reference: OPEN_REFERENCE line+ INTERPRETATION NL*;
expl: OPEN_EXPLICATION line PIPE line+ INTERPRETATION NL*; //explication ||*expl … | ... ||

phiSub: phiDelete phiReplace;
phiDelete: OPEN_PHI_DEL textSeq;
phiReplace: DOUBLESLASH textSeq DOUBLESLASH;
phiDel: (OPEN_PHI_DEL textSeq DOUBLESLASH);
phiAdd: (OPEN_PHI_ADD textSeq DOUBLESLASH);

apparatoFigure: APPARATO_FIGURE_START apparatoFigureItem* APPARATO_FIGURE_END;
apparatoFigureItem: figId COLON label? textinfig? keyword* NL+;
keyword: TYPE;
label: LBRAK labeltext RBRAK;
labeltext: LPAR? line_app? DOT? refSeries DOT? RPAR? ;

refSeries: refItem (refSep refItem)* ;

refSep: SLASH | COMMA | DASH | ALPHASEQ ;

refItem: NUMSUFFIX  | NUM;
textinfig: LPAR line_app+ (PIPE line_app+)* RPAR;
line_app: (textSeqinfig| operation_app )+ NL*;
textSeqinfig: (seginfig | punctinfig)+;
seginfig: (ALPHASEQ | NUM) DASH? | (prefix_app operation_app)|(operation_app suffix_app)|(prefix_app operation_app suffix_app)|(operation_app infix_app operation_app);

prefix_app: (ALPHASEQ|NUM) DASH? CARET;
suffix_app: CARET (ALPHASEQ|NUM) DASH?;
infix_app:  CARET (ALPHASEQ|NUM) DASH? CARET;

operation_app: (substitution_app|pencil_app|addition_app|pencilAddition_app|subspencilAddition_app|deletion_app|pencilDeletion_app|subspencilDeletion_app|phiAdd_app|phiDel_app|phiSub_app| underlined_app);
substitution_app: (deletion_app|pencilDeletion_app|subspencilDeletion_app) (replace_app|addition_app|pencilAddition_app|subspencilAddition_app);
replace_app: SLASH LCURL (textSeqinfig |num| deletion_app |pencilDeletion_app|subspencilDeletion_app)+ RCURL;

pencil_app: OPEN_PENCIL textSeqinfig RCURL;
addition_app: OPEN_ADDITION (textSeqinfig |num| deletion_app |pencilDeletion_app|subspencilDeletion_app|phiAdd_app|phiDel_app|phiSub_app)+ RCURL; //CustomLine:addition +{...}
pencilAddition_app: OPEN_PENCIL_ADDITION (textSeqinfig |num| deletion_app |pencilDeletion_app|subspencilDeletion_app|phiAdd_app|phiDel_app|phiSub_app)+ RCURL; //CustomLine:addition#pencil +!{...}
subspencilAddition_app: OPEN_SUCCESSIVE_PENCIL_ADDITION (textSeqinfig |num| deletion_app |pencilDeletion_app|subspencilDeletion_app|phiAdd_app|phiDel_app|phiSub_app)+ RCURL; //CustomLine:addition#pencil/subs +!s{...}

deletion_app: OPEN_DELETION textSeqinfig RCURL; 
pencilDeletion_app: OPEN_PENCIL_DELETION textSeqinfig RCURL;
subspencilDeletion_app: OPEN_SUCCESSIVE_PENCIL_DELETION textSeqinfig RCURL; 

phiSub_app: phiDelete_app phiReplace_app;
phiDelete_app: OPEN_PHI_DEL textSeqinfig;
phiReplace_app: DOUBLESLASH textSeqinfig DOUBLESLASH;
phiDel_app: (OPEN_PHI_DEL textSeqinfig DOUBLESLASH);
phiAdd_app: (OPEN_PHI_ADD textSeqinfig DOUBLESLASH);

underlined_app: UNDERSCORE textSeqinfig UNDERSCORE; 



punctinfig: (DOT|DOTS|COMMA|COLON|SCOLON|EMARK|QMARK|SLASH|LPAR|RPAR|QUOTE_MARK|LOW_QUOTE_MARK|EQ|ASTERISK);