lexer grammar EuporiaLexer;

MARGIN_IN: '[MARGIN-IN]';
MARGIN_OUT: '[MARGIN-OUT]';
MARGIN_UP: '[MARGIN-UP]';
MARGIN_LOW: '[MARGIN-LOW]';

OPEN_FIG: '[FIGURE: ID ''(';
OPEN_ORNAM: '[ORNAMENTATION: ID ''(';
OPEN_MUSIC: '[MUSIC: ID ''(';
ZONE_CLOSE: ')'']''\n';

EXERCISE: '#EXERCISE:';
LESSON: '#LESSON:';
MARGIN: '#MARGIN:';
TITLE: '#TITLE:';
HASH: '#';
OPEN_IL_ADDITION: '\\''+''{';
OPEN_IL_PENCIL_ADDITION: '\\''+''!''{';
OPEN_IL_CORRECTION: '\\''=''{';
OPEN_IL_PENCIL_CORRECTION: '\\''=''!''{';
OPEN_ADDITION: '+''{';
OPEN_PENCIL_ADDITION: '+''!''{';
OPEN_DELETION: '-''{';
OPEN_PENCIL_DELETION: '-''!''{';

NUM: [0-9]+;
ALPHASEQ: [a-zA-ZäöüÄÖÜáàéèíìóòúùß]+DASH?(DOT|COLON|SCOLON|COMMA|EMARK|QMARK)*;
SLASH: '/';
BKSLASH: '\\'; 
COLON: ':';
SCOLON: ';';
COMMA: ',';
EMARK: '!';
QMARK: '?';
EQ: '=';
TILDE: '~';
DOT: '.';
DOTS: '...';
DASHBAR: '-|';
DASH: '-';
LPAR: '(';
RPAR: ')';
LBRAK: '[';
RBRAK: ']';
LCURL: '{';
RCURL: '}';
NL: '\n';
WS: (' '|'\t')->skip;
