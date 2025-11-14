lexer grammar EuporiaLexer;

//===ZONES===
FAC: '[fac';
NUMB_ZONE: '[[';

MARGIN_IN: '[MARGIN-IN';
MARGIN_OUT: '[MARGIN-OUT';
MARGIN_UP: '[MARGIN-UP';
MARGIN_LOW: '[MARGIN-LOW';
MARGIN: 'MARGIN';

OPEN_FIG: '[FIGURE' [ \t]* LPAR;
OPEN_PARAGRAPHISM: '[PARAGRAPHISM ' [ \t]* LPAR;
OPEN_MUSIC: '[MUSIC ' [ \t]* LPAR;
ZONE_CLOSE: ')'']';
HASH: '#';

//===OPERATIONS===
OPEN_PENCIL: '!''{';
OPEN_ADDITION: '+''{';
OPEN_PENCIL_ADDITION: '+''!''{';
OPEN_SUCCESSIVE_PENCIL_ADDITION: '+''!''s''{';

OPEN_DELETION: DASH '{';
OPEN_PENCIL_DELETION: DASH EMARK '{';
OPEN_SUCCESSIVE_PENCIL_DELETION: DASH EMARK 's''{';


OPEN_EXPLICATION: '||*expl';
OPEN_REFERENCE: '||*ref' ;
INTERPRETATION: '||';
OPEN_PHI_ADD: '+/';
OPEN_PHI_DEL: DASH SLASH;
NEW_PARAGRAPH: '¶';

//===APPARATO_FIGURE===
APPARATO_FIGURE_START: '=====' NL* -> pushMode(APPARATO_FIGURE);

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
DOTS: '...';
DOT: '.';
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
// --- whitespace
WS : [ \t\u00A0\u2000-\u200B\u202F\u205F\u3000]+ -> skip ;  // spazi, TAB, NBSP, ecc.

// --- newline (se lo usi nel parser con NL+)
NL : '\r'? '\n' ;

mode APPARATO_FIGURE;
//===APPARATO_FIGURE===
APPARATO_FIGURE_END : '=====' -> popMode ;

// Aggiunte
OPEN_SUCCESSIVE_PENCIL_ADDITION_APP : '+''!''s''{' -> type(OPEN_SUCCESSIVE_PENCIL_ADDITION);
OPEN_PENCIL_ADDITION_APP            : '+''!''{'    -> type(OPEN_PENCIL_ADDITION);
OPEN_ADDITION_APP                   : '+''{'       -> type(OPEN_ADDITION);

// Cancellazioni (usa DASH come letterale '-')
OPEN_SUCCESSIVE_PENCIL_DELETION_APP : DASH EMARK 's' '{' -> type(OPEN_SUCCESSIVE_PENCIL_DELETION);
OPEN_PENCIL_DELETION_APP            : DASH '!'     '{' -> type(OPEN_PENCIL_DELETION);
OPEN_DELETION_APP                   : DASH        '{' -> type(OPEN_DELETION);

// Nota a matita
OPEN_PENCIL_APP                     : '!''{'       -> type(OPEN_PENCIL);

// Explication / Reference / Interpretazione (metti questi prima di '||')
OPEN_EXPLICATION_APP                : '||*expl' -> type(OPEN_EXPLICATION);
OPEN_REFERENCE_APP                  : '||*ref'     -> type(OPEN_REFERENCE);
INTERPRETATION_APP                  : '||'                     -> type(INTERPRETATION);

// Phi add/del (usa DASH come letterale '-')
OPEN_PHI_ADD_APP                    : '+''/'       -> type(OPEN_PHI_ADD);
OPEN_PHI_DEL_APP                    : DASH SLASH    -> type(OPEN_PHI_DEL);

LCURL_APP : '{' -> type(LCURL);
RCURL_APP : '}' -> type(RCURL);

NUMSUFFIX : NUM [A-Za-z] DOT? ;
APPF_INT   : [0-9]+ -> type(NUM) ;
APPF_US    : '_'    -> type(UNDERSCORE) ;
APPF_DOUBLESLASH : '//' -> type(DOUBLESLASH);
APPF_DASH : '–' -> type(DASH);
APPF_COLON : ':'    -> type(COLON) ;
APPF_LB    : '['    -> type(LBRAK) ;
APPF_RB    : ']'    -> type(RBRAK) ;
APPF_RP   : ')'    -> type(RPAR) ;
APPF_LP    : '('    -> type(LPAR) ;
APPF_SP   : '|'    -> type(PIPE) ;
APPF_DOTS : '...'      -> type(DOTS) ;
APPF_DOT    : '.'        -> type(DOT) ;
APPF_COMMA  : ','        -> type(COMMA) ;
APPF_SCOLON : ';'        -> type(SCOLON) ;
APPF_EMARK  : '!'        -> type(EMARK) ;
APPF_QMARK  : '?'        -> type(QMARK) ;
APPF_SLASH  : '/'        -> type(SLASH) ;
APPF_QUOTE  : '"'        -> type(QUOTE_MARK) ;
APPF_CARET: '^' -> type(CARET) ;

TYPE : '#'('A'..'Z'|'a'..'z'|'_')+;

// se usi un low quote diverso (es. „ o « »), mappalo:
APPF_LOWQ   : '„'        -> type(LOW_QUOTE_MARK) ;
APPF_EQ     : '='        -> type(EQ) ;
APPF_ALPHASEQ: [a-zA-ZäöüÄÖÜáàéèíìóòúùß]+ ( DASH [a-zA-ZäöüÄÖÜáàéèíìóòúùß]+ )?  -> type(ALPHASEQ) ;

APPF_NL : '\r'? '\n' -> type(NL) ;
APPF_WS : [ \t]+     -> skip ;