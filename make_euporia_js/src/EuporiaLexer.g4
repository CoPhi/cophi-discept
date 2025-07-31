lexer grammar EuporiaLexer;

MARGIN_IN: '[MARGIN-IN';
MARGIN_OUT: '[MARGIN-OUT';
MARGIN_UP: '[MARGIN-UP';
MARGIN_LOW: '[MARGIN-LOW';

OPEN_FIG: '[FIGURE: ID ''(';
OPEN_ORNAM: '[ORNAMENTATION: ID ''(';
OPEN_MUSIC: '[MUSIC: ID ''(';
ZONE_CLOSE: ')'']''\n';

HASH: '#';

OPEN_PENCIL: '!''{';
OPEN_ADDITION: '+''{';
OPEN_PENCIL_ADDITION: '+''!''{';
OPEN_DELETION: DASH '{';
OPEN_PENCIL_DELETION: DASH EMARK '{';
OPEN_SUCCESSIVE_PENCIL_DELETION: DASH EMARK 's''{';
OPEN_SUCCESSIVE_PENCIL_ADDITION: '+''!''s''{';

OPEN_INTERPRETATION: '||*';
OPEN_EXPLICATION: '||*expl';
OPEN_REFERENCE: '||*ref' ;
INTERPRETATION_CLOSE: '||';
OPEN_PHI_ADD: '+/';
OPEN_PHI_DEL: DASH SLASH;
FAC: '[fac';
NEW_PARAGRAPH: '§'; 


NUM: [0-9]+;
ALPHASEQ: [a-zA-ZäöüÄÖÜáàéèíìóòúùß]+ ( DASH [a-zA-ZäöüÄÖÜáàéèíìóòúùß]+ )? ;
SLASH: '/';
DOUBLESLASH: '//';
BKSLASH: '\\'; 
PIPE: '|';
COLON: ':';
SCOLON: ';';
COMMA: ',';
EMARK: '!';
QMARK: '?';
EQ: '=';
TILDE: '~';
DOT: '.';
DOTS: '...';
DASHBAR: '–|';
DASH: '–' | '-' | '—';
LPAR: '(';
RPAR: ')';
LBRAK: '[';
RBRAK: ']';
LCURL: '{';
RCURL: '}';
PLUS: '+';
UNDERSCORE: '_';
CARET: '^'; 
QUOTE_MARK: '“' | '"';
LOW_QUOTE_MARK: '„';
ASTERISK: '*';
WS: ' ' -> skip;
TAB: '\t' -> skip;
NL: '\n';
