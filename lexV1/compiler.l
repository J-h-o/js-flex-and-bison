/* ===[STATMENTS BLOCK]=== */

%{

#include "compiler.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>

int lineNo=1;       //line counter
int lineInit=-1;   //multiline comments
int errorCount=0;  //error counter

char strBuf[MAX_STR_CONST];
char*  strBuf_ptr;

extern int yylval;

void yyerror(char *message, int type);
void TPRINT(int token_id);
void NPRINT(int token_id,int base);
void FPRINT(int token_id,int base);
void CPRINT();

int HexToInt(char* str);
int OctToInt(char* str);
int BinToInt(char* str);
float HexToFloat(char* str);
float OctToFloat(char* str);
float BinToFloat(char* str);

%}

%option noyywrap

%option case-insensitive

%x STATE_COMMENT
%x STATE_INLINE_COMMENT
%x STATE_STRING

LETTER      [a-zA-Z]
DIGIT       [0-9]
BINDIGIT    [01]
OCTDIGIT    [0-7]
HEXDIGIT    [0-9A-F]
NZDIGIT     [1-9]{DIGIT}*
EXPONENT    E[+-]?(0|{NZDIGIT})
ALPHANUM    ({LETTER}|{DIGIT})
ALPHANUM_   ({ALPHANUM}|_)
ASCII       [ !"#$%&'()*+,-./:;<=>?@\[\\\]^_`{|}~]
WHITESPACE  [ \t]
ID          \_*{LETTER}{ALPHANUM}*(_{ALPHANUM}+)*_?

/* END STATEMENT BLOCK */

%%

"BREAK" {TPRINT(T_BREAK); return T_BREAK;}                            
"CASE" {TPRINT(T_CASE); return T_CASE;}                              
"CATCH" {TPRINT(T_CATCH); return T_CATCH;}                                
"CLASS" {TPRINT(T_CLASS); return T_CLASS;}                                 
"CONST" {TPRINT(T_CONST); return T_CONST;}                                 
"CONTINUE" {TPRINT(T_CONTINUE); return T_CONTINUE;}                              
"DEBUGGER" {TPRINT(T_DEBUGGER); return T_DEBUGGER;}                              
"DEFAULT" {TPRINT(T_DEFAULT); return T_DEFAULT;}                               
"DELETE" {TPRINT(T_DELETE); return T_DELETE;}                                
"DO" {TPRINT(T_DO); return T_DO;}                                   
"ELSE" {TPRINT(T_ELSE); return T_ELSE;}                                 
"EXPORT" {TPRINT(T_EXPORT); return T_EXPORT;}                               
"EXTENDS" {TPRINT(T_EXTENDS); return T_EXTENDS;}                             
"FINALLY" {TPRINT(T_FINALLY); return T_FINALLY;}                              
"FOR" {TPRINT(T_FOR); return T_FOR;}                                  
"FUNCTION" {TPRINT(T_FUNCTION); return T_FUNCTION;}                             
"IF" {TPRINT(T_IF); return T_IF;}                                   
"IMPORT" {TPRINT(T_IMPORT); return T_IMPORT;}                               
"IN" {TPRINT(T_IN); return T_IN;}                                   
"INSTANCEOF" {TPRINT(T_INSTANCEOF); return T_INSTANCEOF;}                           
"NEW" {TPRINT(T_NEW); return T_NEW;}                                  
"RETURN" {TPRINT(T_RETURN); return T_RETURN;}                               
"SUPER" {TPRINT(T_SUPER); return T_SUPER;}                                
"SWITCH" {TPRINT(T_SWITCH); return T_SWITCH;}                               
"THIS" {TPRINT(T_THIS); return T_THIS;}  
"THROW" {TPRINT(T_THROW); return T_THROW;} 
"TRY" {TPRINT(T_TRY); return T_TRY;}   
"TYPEOF" {TPRINT(T_TYPEOF); return T_TYPEOF;}    
"VAR" {TPRINT(T_VAR); return T_VAR;}   
"VOID" {TPRINT(T_VOID); return T_VOID;}  
"WHILE" {TPRINT(T_WHILE); return T_WHILE;} 
"WITH" {TPRINT(T_WITH); return T_WITH;}  
"YIELD" {TPRINT(T_YIELD); return T_YIELD;}     
"ENUM" {TPRINT(T_ENUM); return T_ENUM;}  
"IMPLEMENTS" {TPRINT(T_IMPLEMENTS); return T_IMPLEMENTS;}    
"INTERFACE" {TPRINT(T_INTERFACE); return T_INTERFACE;} 
"LET" {TPRINT(T_LET); return T_LET;}   
"PACKAGE" {TPRINT(T_PACKAGE); return T_PACKAGE;}   
"PRIVATE" {TPRINT(T_PRIVATE); return T_PRIVATE;}   
"PROTECTED" {TPRINT(T_PROTECTED); return T_PROTECTED;} 
"PUBLIC" {TPRINT(T_PUBLIC); return T_PUBLIC;}    
"STATIC" {TPRINT(T_STATIC); return T_STATIC;}    
"AWAIT" {TPRINT(T_AWAIT); return T_AWAIT;} 
"ABSTRACT" {TPRINT(T_ABSTRACT); return T_ABSTRACT;}  
"BOOLEAN" {TPRINT(T_BOOLEAN); return T_BOOLEAN;}   
"BYTE" {TPRINT(T_BYTE); return T_BYTE;}  
"CHAR" {TPRINT(T_CHAR); return T_CHAR;}  
"DOUBLE" {TPRINT(T_DOUBLE); return T_DOUBLE;}    
"FINAL" {TPRINT(T_FINAL); return T_FINAL;} 
"FLOAT" {TPRINT(T_FLOAT); return T_FLOAT;} 
"GOTO" {TPRINT(T_GOTO); return T_GOTO;}  
"INT" {TPRINT(T_INT); return T_INT;}   
"LONG" {TPRINT(T_LONG); return T_LONG;}  
"NATIVE" {TPRINT(T_NATIVE); return T_NATIVE;}    
"SHORT" {TPRINT(T_SHORT); return T_SHORT;} 
"SYNCHRONISED" {TPRINT(T_SYNCHRONISED); return T_SYNCHRONISED;}  
"THROWS" {TPRINT(T_THROWS); return T_THROWS;}    
"TRANSIENT" {TPRINT(T_TRANSIENT); return T_TRANSIENT;} 
"VOLATILE" {TPRINT(T_VOLATILE); return T_VOLATILE;}  
"NULL" {TPRINT(T_NULL); return T_NULL;}      
"TRUE" {TPRINT(T_TRUE); return T_TRUE;}      
"FALSE" {TPRINT(T_FALSE); return T_FALSE;}     
"ARGUMENTS" {TPRINT(T_ARGUMENTS); return T_ARGUMENTS;}  
"GET" {TPRINT(T_GET); return T_GET;}       
"SET" {TPRINT(T_SET); return T_SET;}         
"MODULE" {TPRINT(T_MODULE); return T_MODULE;}

{ID} {TPRINT(T_ID); return T_ID;}


(0X)([1-9A-F]{HEXDIGIT}*)?\.(0*[1-9A-F]+{HEXDIGIT}*|0)  {FPRINT(T_FCONST, 16); return T_FCONST;}
 /* FLOAT OCT CONSTANT */
(0O)([1-7]{OCTDIGIT}*)?\.(0*[1-7]+{OCTDIGIT}*|0)        {FPRINT(T_FCONST, 8); return T_FCONST;}   
 /* FLOAT BIN CONSTANT */
(0B)(1{BINDIGIT}*)?\.(0*1+{BINDIGIT}*|0)                {FPRINT(T_FCONST, 2); return T_FCONST;}
                                                            
 /* FLOAT DECIMAL CONSTANT */
(0|{NZDIGIT})?(\.)(0*[1-9]+{DIGIT}*|0){EXPONENT}        {FPRINT(T_FCONST, 10); return T_FCONST;}
(0|{NZDIGIT})?(\.)(0*[1-9]+{DIGIT}*|0)                  {FPRINT(T_FCONST, 10); return T_FCONST;}
(0|{NZDIGIT}){EXPONENT}                                 {FPRINT(T_FCONST, 10); return T_FCONST;}
                                                            
 /* HEX CONSTANT */
0X[1-9A-F]{HEXDIGIT}*                                   {NPRINT(T_ICONST, 16); return T_ICONST;}
 /* OCT CONSTANT */
0O[1-7]{OCTDIGIT}*                                      {NPRINT(T_ICONST, 8); return T_ICONST;}
 /* BIN CONSTANT */
0B1{BINDIGIT}*                                          {NPRINT(T_ICONST, 2); return T_ICONST;}
 /* DECIMAL CONSTANT */
0|{NZDIGIT}                                             {NPRINT(T_ICONST, 10); return T_ICONST;}
                                                                                                                
                                                            
 /* Character Constants */
\'\\n\'                                                 {TPRINT(T_CCONST); return T_CCONST;}
\'\\f\'                                                 {TPRINT(T_CCONST); return T_CCONST;}
\'\\t\'                                                 {TPRINT(T_CCONST); return T_CCONST;}
\'\\r\'                                                 {TPRINT(T_CCONST); return T_CCONST;}
\'\\b\'                                                 {TPRINT(T_CCONST); return T_CCONST;}
\'\\v\'                                                 {TPRINT(T_CCONST); return T_CCONST;}   
    
    
\'{ASCII}\'                                             {TPRINT(T_CCONST); return T_CCONST;}
\'{ALPHANUM}\'                                          {TPRINT(T_CCONST); return T_CCONST;}
                        
<INITIAL><<EOF>>                                        {TPRINT(T_EOF); return T_EOF;}

 /* Other Lexical Tokens */
"("                                                     {TPRINT(T_LPAREN); return T_LPAREN;} 
")"                                                     {TPRINT(T_RPAREN); return T_RPAREN;} 
";"                                                     {TPRINT(T_SEMI); return T_SEMI;} 
"."                                                     {TPRINT(T_DOT); return T_DOT;} 
","                                                     {TPRINT(T_COMMA); return T_COMMA;} 
"="                                                     {TPRINT(T_ASSIGN); return T_ASSIGN;}
"::"                                                    {TPRINT(T_METH); return T_METH;}  
":"                                                     {TPRINT(T_COLON); return T_COLON;} 
"["                                                     {TPRINT(T_LBRACK); return T_LBRACK;} 
"]"                                                     {TPRINT(T_RBRACK); return T_RBRACK;} 
"&"                                                     {TPRINT(T_REFER); return T_REFER;} 
"{"                                                     {TPRINT(T_LBRACE); return T_LBRACE;} 
"}"                                                     {TPRINT(T_RBRACE); return T_RBRACE;} 

"+=" {TPRINT(T_ADDITIONASSIGNMENTOP ); return T_ADDITIONASSIGNMENTOP ;}
"+ " {TPRINT( T_ADDITIONOP    ); return T_ADDITIONOP    ;}
"--" {TPRINT( T_DECREMENTOP   ); return T_DECREMENTOP   ;}
"++" {TPRINT( T_INCREMENTOP   ); return T_INCREMENTOP   ;}
"/" {TPRINT( T_DIVISIONOP    ); return T_DIVISIONOP    ;}
"/=" {TPRINT( T_DIVISIONASSIGNMENTOP  ); return T_DIVISIONASSIGNMENTOP  ;}
"`==`" {TPRINT( T_EQUALITYOP    ); return T_EQUALITYOP    ;}
"**" {TPRINT( T_EXPONENTIATIONOP  ); return T_EXPONENTIATIONOP  ;}
"**=" {TPRINT( T_EXPONENTIATIONASSIGNMENTOP    ); return T_EXPONENTIATIONASSIGNMENTOP    ;}
"!=" {TPRINT( T_INEQUALITYOP  ); return T_INEQUALITYOP  ;}
">" {TPRINT( T_GREATEROP ); return T_GREATEROP ;}
">=" {TPRINT( T_GREATEREQOP   ); return T_GREATEREQOP   ;}
"<" {TPRINT( T_LESSOP    ); return T_LESSOP    ;}
"<=" {TPRINT( T_LESSEQOP  ); return T_LESSEQOP  ;}
"&&" {TPRINT( T_ANDOP ); return T_ANDOP ;}
"&&=" {TPRINT( T_ANDOPASSIGNMENTOP ); return T_ANDOPASSIGNMENTOP ;}
"!" {TPRINT( T_NOTOP ); return T_NOTOP ;}
"||" {TPRINT( T_OROP  ); return T_OROP  ;}
"||=" {TPRINT( T_OROPASSIGNMENTOP  ); return T_OROPASSIGNMENTOP  ;}
"-" {TPRINT( T_SUBTRACTIONOP ); return T_SUBTRACTIONOP ;}
"`===`" {TPRINT( T_STRICTEQOP    ); return T_STRICTEQOP    ;}
"`!==`" {TPRINT( T_STRICTINEQOP  ); return T_STRICTINEQOP  ;}
"*" {TPRINT( T_MULTIPLICATIONOP  ); return T_MULTIPLICATIONOP  ;}
"*=" {TPRINT( T_MULTIPLICATIONASSIGNMENTOP    ); return T_MULTIPLICATIONASSIGNMENTOP    ;}



"/*"                                                    {BEGIN(STATE_COMMENT);  strBuf_ptr =  strBuf;lineInit=0;}
<STATE_COMMENT>"*"+"/"                                  {BEGIN(INITIAL); * strBuf_ptr = '\0';
                                                            CPRINT();
                                                            lineInit=-1;}
<STATE_COMMENT>"\n"                                     { lineNo++;lineInit++;}
<STATE_COMMENT>[^*\n]*                                  {char *yptr = yytext; 
                                                            while ( *yptr ) * strBuf_ptr++ = *yptr++;}
<STATE_COMMENT>[*]*                                     {}
<STATE_COMMENT><<EOF>>                                  {yyerror("Unterminated comment", 1); return 0;}


"//"                                                    {BEGIN(STATE_INLINE_COMMENT);  strBuf_ptr =  strBuf;}
<STATE_INLINE_COMMENT>.                                 {}
<STATE_INLINE_COMMENT>[^\\\n\"]+                        {char *yptr = yytext; 
                                                            while ( *yptr ) * strBuf_ptr++ = *yptr++;}
<STATE_INLINE_COMMENT>"\n"                              {BEGIN(INITIAL);
                                                            * strBuf_ptr = '\0';
                                                            CPRINT();
                                                             lineNo++;}
 /* Strings */
\"                                                      {BEGIN(STATE_STRING);  strBuf_ptr =  strBuf;}
<STATE_STRING>\"                                        {BEGIN(INITIAL); * strBuf_ptr = '\0';
                                                            if(FLEX_DEBUG && SHOW_STRINGS)
                                                                printf("STRING FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n",  strBuf, T_STRING,  lineNo);
                                                            return T_STRING;}
<STATE_STRING>\n                                        {yyerror("Illegal input in string", 1); return 0;}
<STATE_STRING>\\n                                       {* strBuf_ptr++ = '\n';}
<STATE_STRING>\\f                                       {* strBuf_ptr++ = '\f';}
<STATE_STRING>\\t                                       {* strBuf_ptr++ = '\t';}
<STATE_STRING>\\r                                       {* strBuf_ptr++ = '\r';}
<STATE_STRING>\\b                                       {* strBuf_ptr++ = '\b';}
<STATE_STRING>\\v                                       {* strBuf_ptr++ = '\v';}
<STATE_STRING>\\\\                                      {* strBuf_ptr++ = '\\';}
<STATE_STRING>\\\"                                      {* strBuf_ptr++ = '"';}
<STATE_STRING>\\\n                                      { lineNo++;}
<STATE_STRING>\\{ALPHANUM_}?                            {* strBuf_ptr++ = yytext[1];}
<STATE_STRING>[^\\\n\"]+                                {char *yptr = yytext; 
                                                            while ( *yptr ) * strBuf_ptr++ = *yptr++;}
<STATE_STRING><<EOF>>                                   {yyerror("Unterminated string", 1); return 0;}
{WHITESPACE}                                            {}
\n                                                      { lineNo++;}
 /* Catch the rest */
.                                                       {yyerror("Illegal character", 0);yyless(1);}
 /* ====[END RULES BLOCK]==== */ 

%%

int main(int argc, char *argv[]){
    int token;
    
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            perror ("Error opening file"); return -1;
        }
    }
    
    do{
		token = yylex();
    }while(token != T_EOF);
    
    if(errorCount > 0){
        printf("Failed to analyze the program due to %d errors\n", errorCount);
    }else{
        printf("Program analyzed successfully\n");
    }
    fclose(yyin);
    yyterminate();
}
void yyerror(char *message, int type)
{
    errorCount++;
    
    if(type==0){
		printf("-> ERROR at line %d caused by %s: %s\n",  lineNo, yytext, message);
    }else if(type==1){
		* strBuf_ptr = '\0'; // String or Comment Error. Cleanup old chars stored in buffer.
		printf("-> ERROR at line %d near \"%s\": %s\n",  lineNo,  strBuf, message);
	}
    if(MAX_ERRORS <= 0) return;
    if(errorCount == MAX_ERRORS){
        printf("Max errors detected\n");
        exit(-1);
    }
}

void TPRINT(int token_id){
    if(FLEX_DEBUG && SHOW_TOKENS){
        printf("TOKEN FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n", yytext, token_id,  lineNo);
    }    
}

void NPRINT(int token_id, int base){
    if(FLEX_DEBUG && SHOW_NUMERIC){
        int number;
        if(base == 2) number = BinToInt(yytext);
        else if(base == 8) number = OctToInt(yytext);
        else if(base == 16) number = HexToInt(yytext);
        else number = atoi(yytext);
        printf("NUMBER FOUND: %d (%s) | FROM BASE: %d | TOKEN NUMBER: %d | LINE: %d\n", number, yytext, base, token_id,  lineNo);
    }
}

void FPRINT(int token_id, int base){
    if(FLEX_DEBUG && SHOW_NUMERIC){
        float number;
        if(base == 2) number = BinToFloat(yytext);
        else if(base == 8) number = OctToFloat(yytext);
        else if(base == 16) number = HexToFloat(yytext);
        else number = atof(yytext);
        printf("FLOAT FOUND: %lf (%s) | FROM BASE: %d | TOKEN NUMBER: %d | LINE: %d\n", number, yytext, base, token_id,  lineNo);
    }
}

void CPRINT(){
    if(FLEX_DEBUG && SHOW_COMMENTS){
        int line = lineInit > 0 ?  lineNo-lineInit :  lineNo;
        printf("COMMENT FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n",  strBuf, T_STRING, line);
    }
}

int HexToInt(char *str){
    return (int) strtol(&str[2], NULL, 16);
}

int OctToInt(char *str){
    return (int) strtol(&str[2], NULL, 8);
}

int BinToInt(char *str){
    return (int) strtol(&str[2], NULL, 2);
}

float BinToFloat(char* str){
    float number = 0.0;
    int i,length_real;
    char *character;
    character = strchr(str,'.');
    length_real = strlen(character)-1;
    number = (int)strtol(&str[2],&character,2);
    for(i=1;i<length_real;i++){
        number += (character[i] - '0') * (1/pow(2,i));
    }
    return number;
}

float OctToFloat(char* str){
    float number = 0.0;
    int i,length_real;
    char *character;
    character = strchr(str,'.');
    length_real = strlen(character)-1;
    number = (int)strtol(&str[2],&character,8);
    for(i=1;i<=length_real;i++){
        number += (character[i] - '0') * (1/pow(8,i));
    }
    return number;
}

float HexToFloat(char*str){
    float number = 0.0;
    int i,length_real;
    char *character;
    character = strchr(str,'.');
    length_real = strlen(character)-1;
    number = (int)strtol(&str[2],&character,16);
    for(i=1;i<=length_real;i++){
        if(character[i] <= '9')
			number += (character[i] - '0') * (1/pow(16,i));
		else
			number += (character[i] + 10 - 'A') * (1/pow(16,i)); /** TODO: CASE SENSITIVE **/
	}
    return number;
}