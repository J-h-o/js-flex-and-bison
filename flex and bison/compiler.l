/* ===[STATMENTS BLOCK]=== */

%{

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>
#include "settings.h"
#include "bison.tab.h"

extern int flag_err_type;
extern void yyerror(char *message);

int lineNo=1;       //line counter
int lineInit=-1;   //multiline comments

char strBuf[MAX_STR_CONST];
char*  strBuf_ptr;

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
NEWLINE     [\n]
ID          \_*{LETTER}{ALPHANUM}*(_{ALPHANUM}+)*_?

/* END STATEMENT BLOCK */
/** ====[RULES BLOCK]==== **/
%%


 /* Keywords */
"CHAR"                                                  {TPRINT(T_CHAR); yylval.strval = strdup(yytext);
                                                            return T_CHAR;}
"INT"                                                   {TPRINT(T_INT); yylval.strval = strdup(yytext);
                                                            return T_INT;}
"FLOAT"                                                 {TPRINT(T_FLOAT); yylval.strval = strdup(yytext);
                                                            return T_FLOAT;}
"STRING"                                                {TPRINT(T_STRING); yylval.strval = strdup(yytext);
                                                            return T_STRING;}
"CLASS"                                                 {TPRINT(T_CLASS); yylval.strval = strdup(yytext);
                                                            return T_CLASS;}
"PRIVATE"                                               {TPRINT(T_PRIVATE); yylval.strval = strdup(yytext);
                                                            return T_PRIVATE;}
"PROTECTED"                                             {TPRINT(T_PROTECTED); yylval.strval = strdup(yytext);
                                                            return T_PROTECTED;}
"PUBLIC"                                                {TPRINT(T_PUBLIC); yylval.strval = strdup(yytext);
                                                            return T_PUBLIC;}
"VOID"                                                  {TPRINT(T_VOID); yylval.strval = strdup(yytext);
                                                            return T_VOID;}
"STATIC"                                                {TPRINT(T_STATIC); yylval.strval = strdup(yytext);
                                                            return T_STATIC;}
"ENUM"                                                  {TPRINT(T_ENUM); yylval.strval = strdup(yytext);
                                                            return T_ENUM;}
"CONTINUE"                                              {TPRINT(T_CONTINUE); yylval.strval = strdup(yytext);
                                                            return T_CONTINUE;}
"BREAK"                                                 {TPRINT(T_BREAK); yylval.strval = strdup(yytext);
                                                            return T_BREAK;}
"IF"                                                    {TPRINT(T_IF); yylval.strval = strdup(yytext);
                                                            return T_IF;}
"ELSE"                                                  {TPRINT(T_ELSE); yylval.strval = strdup(yytext);
                                                            return T_ELSE;}
"WHILE"                                                 {TPRINT(T_WHILE); yylval.strval = strdup(yytext);
                                                            return T_WHILE;}
"FOR"                                                   {TPRINT(T_FOR); yylval.strval = strdup(yytext);
                                                            return T_FOR;}
"SWITCH"                                                {TPRINT(T_SWITCH); yylval.strval = strdup(yytext);
                                                            return T_SWITCH;}
"CASE"                                                  {TPRINT(T_CASE); yylval.strval = strdup(yytext);
                                                            return T_CASE;}
"DEFAULT"                                               {TPRINT(T_DEFAULT); yylval.strval = strdup(yytext);
                                                            return T_DEFAULT;}
"RETURN"                                                {TPRINT(T_RETURN); yylval.strval = strdup(yytext);
                                                            return T_RETURN;}
"NEW"                                                   {TPRINT(T_NEW); yylval.strval = strdup(yytext);
                                                            return T_NEW;}
"THIS"                                                  {TPRINT(T_THIS); yylval.strval = strdup(yytext);
                                                            return T_THIS;}
"SIZEOF"                                                {TPRINT(T_SIZEOP); yylval.strval = strdup(yytext);
                                                            return T_SIZEOP;}  
"FUNCTION" {TPRINT(T_FUNCTION); yylval.strval = strdup(yytext); return T_FUNCTION;}
"LET" {TPRINT(T_LET); yylval.strval = strdup(yytext); return T_LET;} 

 /* List Items TODO: Check for \b with Dimitriou/Floro */
C(AD*|D+)R                                              {TPRINT(T_LISTFUNC); yylval.strval = strdup(yytext);
                                                            return T_LISTFUNC;}  
                                                            
                                                            
 /* ID */
{ID}                                                    {TPRINT(T_ID); yylval.strval = strdup(yytext);
                                                            return T_ID;}                                                       
 /* FLOAT HEX CONSTANT */
(0X)([1-9A-F]{HEXDIGIT}*)?\.(0*[1-9A-F]+{HEXDIGIT}*|0)  {FPRINT(T_FCONST, 16); yylval.doubleval = HexToFloat(yytext);
                                                            return T_FCONST;}
 /* FLOAT OCT CONSTANT */
(0O)([1-7]{OCTDIGIT}*)?\.(0*[1-7]+{OCTDIGIT}*|0)        {FPRINT(T_FCONST, 8); yylval.doubleval = OctToFloat(yytext);
                                                            return T_FCONST;}   
 /* FLOAT BIN CONSTANT */
(0B)(1{BINDIGIT}*)?\.(0*1+{BINDIGIT}*|0)                {FPRINT(T_FCONST, 2); yylval.doubleval = BinToFloat(yytext);
                                                            return T_FCONST;}
                                                            
 /* FLOAT DECIMAL CONSTANT */
(0|{NZDIGIT})?(\.)(0*[1-9]+{DIGIT}*|0){EXPONENT}        {FPRINT(T_FCONST, 10); yylval.doubleval = atof(yytext);
                                                            return T_FCONST;}
(0|{NZDIGIT})?(\.)(0*[1-9]+{DIGIT}*|0)                  {FPRINT(T_FCONST, 10); yylval.doubleval = atof(yytext);
                                                            return T_FCONST;}
(0|{NZDIGIT}){EXPONENT}                                 {FPRINT(T_FCONST, 10); yylval.doubleval = atof(yytext);
                                                            return T_FCONST;}
                                                            
 /* HEX CONSTANT */
0X[1-9A-F]{HEXDIGIT}*                                   {NPRINT(T_ICONST, 16); yylval.intval = HexToInt(yytext);
                                                            return T_ICONST;}
 /* OCT CONSTANT */
0O[1-7]{OCTDIGIT}*                                      {NPRINT(T_ICONST, 8);  yylval.intval = OctToInt(yytext);
                                                            return T_ICONST;}
 /* BIN CONSTANT */
0B1{BINDIGIT}*                                          {NPRINT(T_ICONST, 2);  yylval.intval = BinToInt(yytext);
                                                            return T_ICONST;}
 /* DECIMAL CONSTANT */
0|{NZDIGIT}                                             {NPRINT(T_ICONST, 10); yylval.intval = atoi(yytext);
                                                            return T_ICONST;}
                                                            
                                                            
                                                            
 /* Character Constants */
\'\\n\'                                                 {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}
\'\\f\'                                                 {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}
\'\\t\'                                                 {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}
\'\\r\'                                                 {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}
\'\\b\'                                                 {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}
\'\\v\'                                                 {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}   
    
    
    
    
    
\'{ASCII}\'                                             {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}
\'{ALPHANUM}\'                                          {TPRINT(T_CCONST); yylval.strval = strdup(yytext);
                                                            return T_CCONST;}

                        

                        
                                                            
 /* Operators */    
"||"                                                    {TPRINT(T_OROP); yylval.strval = strdup(yytext);
                                                            return T_OROP;}  
"&&"                                                    {TPRINT(T_ANDOP); yylval.strval = strdup(yytext);
                                                            return T_ANDOP;}  
"=="|"!="                                               {TPRINT(T_EQUOP); yylval.strval = strdup(yytext);
                                                            return T_EQUOP;}  
">="|"<="|">"|"<"                                       {TPRINT(T_RELOP); yylval.strval = strdup(yytext);
                                                            return T_RELOP;}
"++"|"--"                                               {TPRINT(T_INCDEC); yylval.strval = strdup(yytext);
                                                            return T_INCDEC;}                                                           
"+"|"-"                                                 {TPRINT(T_ADDOP); yylval.strval = strdup(yytext);
                                                            return T_ADDOP;}  
"*"|"/"|"%"                                             {TPRINT(T_MULOP); yylval.strval = strdup(yytext);
                                                            return T_MULOP;}  
"!"                                                     {TPRINT(T_NOTOP); yylval.strval = strdup(yytext);
                                                            return T_NOTOP;}  
                                                            

                                                            
 /* Other Lexical Tokens */
"("                                                     {TPRINT(T_LPAREN); yylval.strval = strdup(yytext);
                                                            return T_LPAREN;} 
")"                                                     {TPRINT(T_RPAREN); yylval.strval = strdup(yytext);
                                                            return T_RPAREN;} 
";"                                                     {TPRINT(T_SEMI); yylval.strval = strdup(yytext);
                                                           return T_SEMI;} 
"."                                                     {TPRINT(T_DOT); yylval.strval = strdup(yytext);
                                                            return T_DOT;} 
","                                                     {TPRINT(T_COMMA); yylval.strval = strdup(yytext);
                                                            return T_COMMA;} 
"="                                                     {TPRINT(T_ASSIGN); yylval.strval = strdup(yytext);
                                                            return T_ASSIGN;}
"::"                                                    {TPRINT(T_METH); yylval.strval = strdup(yytext);
                                                            return T_METH;}                                                             
":"                                                     {TPRINT(T_COLON); yylval.strval = strdup(yytext);
                                                            return T_COLON;} 
"["                                                     {TPRINT(T_LBRACK); yylval.strval = strdup(yytext);
                                                            return T_LBRACK;} 
"]"                                                     {TPRINT(T_RBRACK); yylval.strval = strdup(yytext);
                                                            return T_RBRACK;} 
"&"                                                     {TPRINT(T_REFER); yylval.strval = strdup(yytext);
                                                            return T_REFER;} 
"{"                                                     {TPRINT(T_LBRACE); yylval.strval = strdup(yytext);
                                                            return T_LBRACE;} 
"}"                                                     {TPRINT(T_RBRACE); yylval.strval = strdup(yytext);
                                                            return T_RBRACE;} 
">>"                                                    {TPRINT(T_INP); yylval.strval = strdup(yytext);
                                                            return T_INP;} 
"<<"                                                    {TPRINT(T_OUT); yylval.strval = strdup(yytext);
                                                            return T_OUT;} 
<INITIAL><<EOF>>                                        {TPRINT(T_EOF); yylval.strval = strdup(yytext);
                                                            return T_EOF;}
                                                            
                                                            
 /* Comments */
"/*"                                                    {BEGIN(STATE_COMMENT); strBuf_ptr = strBuf;lineInit=0;}
<STATE_COMMENT>"*"+"/"                                  {BEGIN(INITIAL); *strBuf_ptr = '\0';
                                                            CPRINT();
                                                            lineInit=-1;}
<STATE_COMMENT>"\n"                                     {lineNo++;lineInit++;}
<STATE_COMMENT>[^*\n]*                                  {char *yptr = yytext; 
                                                            while ( *yptr ) *strBuf_ptr++ = *yptr++;}
<STATE_COMMENT>[*]*                                     {}
<STATE_COMMENT><<EOF>>                                  {flag_err_type=1;yyerror("Unterminated comment"); return 0;}


"//"                                                    {BEGIN(STATE_INLINE_COMMENT); strBuf_ptr = strBuf;}
<STATE_INLINE_COMMENT>.                                 {}
<STATE_INLINE_COMMENT>[^\\\n\"]+                        {char *yptr = yytext; 
                                                            while ( *yptr ) *strBuf_ptr++ = *yptr++;}
<STATE_INLINE_COMMENT>"\n"                              {BEGIN(INITIAL);
                                                            *strBuf_ptr = '\0';
                                                            CPRINT();
                                                            lineNo++;}

                                                            
 /* Strings */
\"                                                      {BEGIN(STATE_STRING); strBuf_ptr = strBuf;}
<STATE_STRING>\"                                        {BEGIN(INITIAL); *strBuf_ptr = '\0';
                                                            yylval.strval = strdup(strBuf);
                                                            if(FLEX_DEBUG && FLEX_SHOW_STRINGS)
                                                                printf("STRING FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n", strBuf, T_SCONST, lineNo);
                                                            return T_SCONST;}
<STATE_STRING>\n                                        {flag_err_type=1;yyerror("Illegal input in string"); return 0;}
<STATE_STRING>\\n                                       {*strBuf_ptr++ = '\n';}
<STATE_STRING>\\f                                       {*strBuf_ptr++ = '\f';}
<STATE_STRING>\\t                                       {*strBuf_ptr++ = '\t';}
<STATE_STRING>\\r                                       {*strBuf_ptr++ = '\r';}
<STATE_STRING>\\b                                       {*strBuf_ptr++ = '\b';}
<STATE_STRING>\\v                                       {*strBuf_ptr++ = '\v';}
<STATE_STRING>\\\\                                      {*strBuf_ptr++ = '\\';}
<STATE_STRING>\\\"                                      {*strBuf_ptr++ = '"';}
<STATE_STRING>\\\n                                      {lineNo++;}
<STATE_STRING>\\{ALPHANUM_}?                            {*strBuf_ptr++ = yytext[1];}
<STATE_STRING>[^\\\n\"]+                                {char *yptr = yytext; 
                                                            while ( *yptr ) *strBuf_ptr++ = *yptr++;}
<STATE_STRING><<EOF>>                                   {flag_err_type=1;yyerror("Unterminated string"); return 0;}

{WHITESPACE}                                            {}
{NEWLINE}                                               {lineNo++;}

 /* Catch the rest */
.                                                       {yyerror("Illegal character");/**yyless(1);**/}
 /* ====[END RULES BLOCK]==== */ 

%%

/* ====[USER FUNCTIONS BLOCK]==== */


/* ====[END USER FUNCTIONS BLOCK]==== */

void TPRINT(int token_id){
    if(FLEX_DEBUG && FLEX_SHOW_TOKENS){
        printf("TOKEN FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n", yytext, token_id, lineNo);
    }    
}

void NPRINT(int token_id, int base){
    if(FLEX_DEBUG && FLEX_SHOW_NUMERIC){
        int number;
        if(base == 2) number = BinToInt(yytext);
        else if(base == 8) number = OctToInt(yytext);
        else if(base == 16) number = HexToInt(yytext);
        else number = atoi(yytext);
        printf("NUMBER FOUND: %d (%s) | FROM BASE: %d | TOKEN NUMBER: %d | LINE: %d\n", number, yytext, base, token_id, lineNo);
    }
}

void FPRINT(int token_id, int base){
    if(FLEX_DEBUG && FLEX_SHOW_NUMERIC){
        float number;
        if(base == 2) number = BinToFloat(yytext);
        else if(base == 8) number = OctToFloat(yytext);
        else if(base == 16) number = HexToFloat(yytext);
        else number = atof(yytext);
        printf("FLOAT FOUND: %lf (%s) | FROM BASE: %d | TOKEN NUMBER: %d | LINE: %d\n", number, yytext, base, token_id, lineNo);
    }
}

void CPRINT(){
    if(FLEX_DEBUG && FLEX_SHOW_COMMENTS){
        int line = lineInit > 0 ? lineNo-lineInit : lineNo;
        printf("COMMENT FOUND: %s | TOKEN NUMBER: %d | LINE: %d\n", strBuf, T_STRING, line);
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
