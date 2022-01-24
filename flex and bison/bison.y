%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>
#include "settings.h"
#include "hashtbl.h"

extern int lineNo, lineInit;
extern char strBuf[MAX_STR_CONST];
extern char* strBuf_ptr;
extern int yylex();
extern char *yytext;
extern FILE *yyin;
extern void yyterminate();

/** BISON VAR **/
int error_count=0;
int flag_err_type=0;
int scope=0;

HASHTBL *hashtbl;

/** BISON FUN **/
void yyerror(const char *message);
%}

%error-verbose

%union{
    int intval;
    double doubleval;
    char *strval;
}

%token <strval> T_BREAK       "break"                                 
%token <strval> T_CASE        "case"                    
%token <strval> T_CATCH       "catch"                    
%token <strval> T_CLASS       "class"                   
%token <strval> T_CONST       "constant"                   
%token <strval> T_CONTINUE    "continue"                         
%token <strval> T_DEBUGGER "debugger"                              
%token <strval> T_DEFAULT     "default"                  
%token <strval> T_DELETE      "delete"                          
%token <strval> T_DO          "do"                         
%token <strval> T_ELSE        "else"                         
%token <strval> T_EXPORT      "export"                         
%token <strval> T_EXTENDS     "extends"                        
%token <strval> T_FINALLY     "finally"                         
%token <strval> T_FOR         "for"                         
%token <strval> T_FUNCTION    "function"                         
%token <strval> T_IF          "if"                         
%token <strval> T_IMPORT      "import"                         
%token <strval> T_IN          "in"                         
%token <strval> T_INSTANCEOF  "instanceof"                         
%token <strval> T_NEW         "new"                         
%token <strval> T_RETURN      "return"                         
%token <strval> T_SUPER       "super"                         
%token <strval> T_SWITCH      "swich"                        
%token <strval> T_THIS        "this"
%token <strval> T_THROW       "throw"
%token <strval> T_TRY         "try"
%token <strval> T_TYPEOF      "typeof"
%token <strval> T_VAR         "var"   
%token <strval> T_VOID        "void"
%token <strval> T_WHILE       "while"
%token <strval> T_WITH        "with"
%token <strval> T_YIELD       "yield"
%token <strval> T_ENUM        "enum"
%token <strval> T_IMPLEMENTS  "implements"
%token <strval> T_INTERFACE   "interface"
%token <strval> T_LET         "let"
%token <strval> T_PACKAGE     "package"
%token <strval> T_PRIVATE     "private"
%token <strval> T_PROTECTED   "protected"
%token <strval> T_PUBLIC      "public"
%token <strval> T_STATIC      "static"
%token <strval> T_AWAIT       "await"
%token <strval> T_ABSTRACT    "abstract"
%token <strval> T_BOOLEAN    "boolean"
%token <strval> T_BYTE        "byte"
%token <strval> T_CHAR        "char"
%token <doubleval> T_DOUBLE   "double"
%token <strval> T_FINAL       "final"
%token <doubleval> T_FLOAT    "float"
%token <strval> T_GOTO        "goto"
%token <intval> T_INT         "int"
%token <doubleval> T_LONG     "long"
%token <strval> T_NATIVE      "native"
%token <intval> T_SHORT       "short"
%token <strval> T_SYNCHRONISED "synchronised"
%token <strval> T_THROWS      "throws"
%token <strval> T_TRANSIENT   "transient"
%token <strval> T_VOLATILE    "volatile"
%token <strval> T_NULL        "null"
%token <strval> T_TRUE       "true"
%token <strval> T_FALSE      "false"
%token <strval> T_ARGUMENTS   "arguments"
%token <strval> T_GET         "get"
%token <strval> T_SET         "set"
%token <strval> T_MODULE      "module"
%token <strval> T_STRING      "string literal"
%token <strval> T_ID                "id"
%token <strval> T_OROP              "||"
%token <strval> T_ANDOP             "&&"
%token <strval> T_EQUOP             "== or !="
%token <strval> T_ADDOP             "+ or -"
%token <strval> T_MULOP             "* or / or %"
%token <strval> T_INCDEC            "-- or ++"
%token <strval> T_SIZEOP            "sizeof"
%token <strval> T_LISTFUNC          "listfunc"
%token <strval> T_LPAREN            "("
%token <strval> T_RPAREN            ")"
%token <strval> T_SEMI              ";"
%token <strval> T_DOT               "."
%token <strval> T_COMMA             ","
%token <strval> T_COLON             ":"
%token <strval> T_LBRACK            "["
%token <strval> T_RBRACK            "]"
%token <strval> T_REFER             "&"
%token <strval> T_LBRACE            "{"
%token <strval> T_RBRACE            "}"
%token <strval> T_METH              "::"
%token <strval> T_INP               "<<"
%token <strval> T_OUT               ">>"
%token <strval> T_ASSIGN            "="
%token <strval> T_CCONST            "char const"
%token <strval> T_FCONST            "float const"
%token <strval> T_ICONST            "int const"
%token <strval> T_SCONST            "string const"
%token <strval> T_NOTOP             "!"
%token <strval> T_RELOP             "> or >= or < or <="
%token <strval> T_EOF 0       "end of file"

%type <strval> program for_statement optexpr statement general_expression assignment variable expression
%type <strval> expression_list listexpression constant standard_type decltype statements
%type <strval> main_function global_declarations expression_statement


%left T_COMMA
%right T_ASSIGN 
%left T_OROP
%left T_ANDOP
%left T_EQUOP
%left T_RELOP
%left T_ADDOP
%left T_MULOP 
%left T_NOTOP T_REFER T_SIZEOP T_INCDEC UMINUS
%left T_LPAREN T_RPAREN T_LBRACK T_RBRACK T_DOT T_METH

%nonassoc T_ELSE

%start program

%%
program
    : global_declarations main_function
    ;
global_declarations
    : %empty {}
    ;
for_statement
    : T_FOR T_LPAREN {scope++;} 
        optexpr T_SEMI optexpr T_SEMI optexpr T_RPAREN T_LBRACE statement T_RBRACE {hashtbl_get(hashtbl, scope);scope--;}
    | %empty{}
    ;
optexpr
    : general_expression
    | %empty{}
    ;
general_expression
    :   general_expression T_COMMA general_expression
    |   assignment
    ;
assignment
    : variable T_ASSIGN assignment
    | expression
    ;
expression
    : expression T_OROP expression
    | expression T_ANDOP expression
    | expression T_EQUOP expression
    | expression T_RELOP expression
    | expression T_ADDOP expression
    | expression T_MULOP expression
    | T_NOTOP expression
    | T_ADDOP expression %prec UMINUS
    | T_SIZEOP expression
    | T_INCDEC variable
    | variable T_INCDEC
    | variable
    | variable T_LPAREN expression_list T_RPAREN
    | T_NEW T_LPAREN general_expression T_RPAREN
    | constant
    | T_LPAREN general_expression T_RPAREN
    | T_LPAREN standard_type T_RPAREN
    | listexpression
    ;
standard_type
    : T_CHAR 
    | T_INT 
    | T_FLOAT 
    | T_STRING 
    | T_VOID
    | T_LET
    | T_VAR
    ;
expression_list
    : general_expression
    | %empty {}
    ;
listexpression
    : T_LBRACK expression_list T_RBRACK
    ;
variable
    : variable T_LBRACK general_expression T_RBRACK
    | variable T_DOT T_ID                                               {hashtbl_insert(hashtbl, $3, NULL, scope);}
    | T_LISTFUNC T_LPAREN general_expression T_RPAREN
    | decltype T_ID                                                    {hashtbl_insert(hashtbl, $2, NULL, scope);}
    | decltype T_ICONST
    | T_THIS
    ;
decltype
    : T_LET
    | T_STATIC 
    | %empty {}
    ;
constant
    : T_CONST
    ;
statement
    : expression_statement
    | for_statement
    ;
expression_statement
    : general_expression T_SEMI
    | for_statement
    ;
decl_statements
    : for_statement
    | expression_statement
    | %empty {}
    ;
statements
    : statements statement
    | statement
    ;
main_function
    : main_header 
        T_LBRACE decl_statements T_RBRACE {hashtbl_get(hashtbl, scope);scope--;}
    ;
main_header
    : T_FUNCTION T_ID T_LPAREN T_RPAREN {scope++;}
    | error T_ID T_LPAREN T_RPAREN {yyerror("Bad function");yyerrok;}
    ;
%%

int main(int argc, char *argv[]){

    if(!(hashtbl = hashtbl_create(10, NULL))) {
        fprintf(stderr, "ERROR: hashtbl_create() failed!\n");
        exit(EXIT_FAILURE);
    }

    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if (yyin == NULL){
            perror ("ERROR OPENING FILE");
            return -1;
        }
    }

    yyparse();
    hashtbl_get(hashtbl, scope); 
    hashtbl_destroy(hashtbl);
    fclose(yyin);

    if(error_count > 0){
        printf("Syntax Analysis failed due to %d errors\n", error_count);
    }else{
        printf("Syntax Analysis was completed successfully.");
    }
    return 0;
}

void yyerror(const char *message)
{
    error_count++;

    if(flag_err_type==0){
        printf("-> ERROR at line %d caused by %s : %s\n", lineNo, yytext, message);
    }else if(flag_err_type==1){
        *strBuf_ptr= '\0';
        printf("-> ERROR at line %d near \"%s\" : %s\n",lineNo,strBuf,message);
    }
    flag_err_type=0;
    if(MAX_ERRORS <= 0) return;
    if(error_count == MAX_ERRORS){
        printf("Max errors (%d) detected. EXITING\n", MAX_ERRORS);
        exit(-1);
    }
}