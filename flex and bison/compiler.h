// KEYWORDS
#define T_BREAK                                 1
#define T_CASE                                  2
#define T_CATCH                                 3
#define T_CLASS                                 4
#define T_CONST                                 5
#define T_CONTINUE                              6
#define T_DEBUGGER                              7
#define T_DEFAULT                               8
#define T_DELETE                                9
#define T_DO                                   10
#define T_ELSE                                 11
#define T_EXPORT                               12
#define T_EXTENDS                              13
#define T_FINALLY                              14
#define T_FOR                                  15
#define T_FUNCTION                             16
#define T_IF                                   17
#define T_IMPORT                               18
#define T_IN                                   19
#define T_INSTANCEOF                           20
#define T_NEW                                  21
#define T_RETURN                               22
#define T_SUPER                                23
#define T_SWITCH                               24
#define T_THIS  25
#define T_THROW 26
#define T_TRY   27
#define T_TYPEOF    28
#define T_VAR   29
#define T_VOID  30
#define T_WHILE 31
#define T_WITH  32
#define T_YIELD     33
#define T_ENUM  34
#define T_IMPLEMENTS    35
#define T_INTERFACE 36
#define T_LET   37
#define T_PACKAGE   38
#define T_PRIVATE   39
#define T_PROTECTED 40
#define T_PUBLIC    41
#define T_STATIC    42
#define T_AWAIT 43
#define T_ABSTRACT  44
#define T_BOOLEAN   45
#define T_BYTE  46
#define T_CHAR  47
#define T_DOUBLE    48
#define T_FINAL 49
#define T_FLOAT 50
#define T_GOTO  51
#define T_INT   52
#define T_LONG  53
#define T_NATIVE    54
#define T_SHORT 55
#define T_SYNCHRONISED  56
#define T_THROWS    57
#define T_TRANSIENT 58
#define T_VOLATILE  59
#define T_NULL      60
#define T_TRUE      61
#define T_FALSE     62
#define T_ARGUMENTS 63
#define T_GET       64
#define T_SET       65
#define T_MODULE    68

// OPERATORS 

#define T_ADDITIONASSIGNMENTOP  69
#define T_ADDITIONOP    70
#define T_ASSIGNMENTOP  71
#define T_COMMAOP       72
#define T_DECREMENTOP   73
#define T_INCREMENTOP   74
#define T_DIVISIONOP    75
#define T_DIVISIONASSIGNMENTOP  76
#define T_EQUALITYOP    77
#define T_EXPONENTIATIONOP  78
#define T_EXPONENTIATIONASSIGNMENTOP    79
#define T_INEQUALITYOP  80
#define T_GREATEROP 81
#define T_GREATEREQOP   82
#define T_LESSOP    83
#define T_LESSEQOP  84
#define T_ANDOP 85
#define T_ANDOPASSIGNMENTOP 86
#define T_NOTOP 87
#define T_OROP  88
#define T_OROPASSIGNMENTOP  89
#define T_SUBTRACTIONOP 90
#define T_STRICTEQOP    91
#define T_STRICTINEQOP  92
#define T_MULTIPLICATIONOP  93
#define T_MULTIPLICATIONASSIGNMENTOP    94

// OTHER TOKENS

#define T_LPAREN    95
#define T_RPAREN    96
#define T_SEMI  97
#define T_DOT   98
#define T_COMMA 99
#define T_ASSIGN    100
#define T_COLON     101
#define T_LBRACK    102
#define T_RBRACK    103
#define T_LBRACE    104
#define T_RBRACE    105                           
#define T_METH  106
#define T_ID    107
#define T_REFER 111

//CONST
#define T_FCONST    108
#define T_ICONST    109
#define T_CCONST    110

#define T_STRING    112

#define T_EOF                                   0 

#define MAX_ERRORS          0
#define MAX_STR_CONST     256

#ifndef FLEX_DEBUG
#define FLEX_DEBUG          1
#define SHOW_TOKENS         1
#define SHOW_COMMENTS       1
#define SHOW_NUMERIC        1
#define SHOW_STRINGS        1
#endif