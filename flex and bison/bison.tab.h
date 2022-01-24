/* A Bison parser, made by GNU Bison 3.7.6.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_BISON_TAB_H_INCLUDED
# define YY_YY_BISON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    T_EOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    T_BREAK = 258,                 /* "break"  */
    T_CASE = 259,                  /* "case"  */
    T_CATCH = 260,                 /* "catch"  */
    T_CLASS = 261,                 /* "class"  */
    T_CONST = 262,                 /* "constant"  */
    T_CONTINUE = 263,              /* "continue"  */
    T_DEBUGGER = 264,              /* "debugger"  */
    T_DEFAULT = 265,               /* "default"  */
    T_DELETE = 266,                /* "delete"  */
    T_DO = 267,                    /* "do"  */
    T_ELSE = 268,                  /* "else"  */
    T_EXPORT = 269,                /* "export"  */
    T_EXTENDS = 270,               /* "extends"  */
    T_FINALLY = 271,               /* "finally"  */
    T_FOR = 272,                   /* "for"  */
    T_FUNCTION = 273,              /* "function"  */
    T_IF = 274,                    /* "if"  */
    T_IMPORT = 275,                /* "import"  */
    T_IN = 276,                    /* "in"  */
    T_INSTANCEOF = 277,            /* "instanceof"  */
    T_NEW = 278,                   /* "new"  */
    T_RETURN = 279,                /* "return"  */
    T_SUPER = 280,                 /* "super"  */
    T_SWITCH = 281,                /* "swich"  */
    T_THIS = 282,                  /* "this"  */
    T_THROW = 283,                 /* "throw"  */
    T_TRY = 284,                   /* "try"  */
    T_TYPEOF = 285,                /* "typeof"  */
    T_VAR = 286,                   /* "var"  */
    T_VOID = 287,                  /* "void"  */
    T_WHILE = 288,                 /* "while"  */
    T_WITH = 289,                  /* "with"  */
    T_YIELD = 290,                 /* "yield"  */
    T_ENUM = 291,                  /* "enum"  */
    T_IMPLEMENTS = 292,            /* "implements"  */
    T_INTERFACE = 293,             /* "interface"  */
    T_LET = 294,                   /* "let"  */
    T_PACKAGE = 295,               /* "package"  */
    T_PRIVATE = 296,               /* "private"  */
    T_PROTECTED = 297,             /* "protected"  */
    T_PUBLIC = 298,                /* "public"  */
    T_STATIC = 299,                /* "static"  */
    T_AWAIT = 300,                 /* "await"  */
    T_ABSTRACT = 301,              /* "abstract"  */
    T_BOOLEAN = 302,               /* "boolean"  */
    T_BYTE = 303,                  /* "byte"  */
    T_CHAR = 304,                  /* "char"  */
    T_DOUBLE = 305,                /* "double"  */
    T_FINAL = 306,                 /* "final"  */
    T_FLOAT = 307,                 /* "float"  */
    T_GOTO = 308,                  /* "goto"  */
    T_INT = 309,                   /* "int"  */
    T_LONG = 310,                  /* "long"  */
    T_NATIVE = 311,                /* "native"  */
    T_SHORT = 312,                 /* "short"  */
    T_SYNCHRONISED = 313,          /* "synchronised"  */
    T_THROWS = 314,                /* "throws"  */
    T_TRANSIENT = 315,             /* "transient"  */
    T_VOLATILE = 316,              /* "volatile"  */
    T_NULL = 317,                  /* "null"  */
    T_TRUE = 318,                  /* "true"  */
    T_FALSE = 319,                 /* "false"  */
    T_ARGUMENTS = 320,             /* "arguments"  */
    T_GET = 321,                   /* "get"  */
    T_SET = 322,                   /* "set"  */
    T_MODULE = 323,                /* "module"  */
    T_STRING = 324,                /* "string literal"  */
    T_ID = 325,                    /* "id"  */
    T_OROP = 326,                  /* "||"  */
    T_ANDOP = 327,                 /* "&&"  */
    T_EQUOP = 328,                 /* "== or !="  */
    T_ADDOP = 329,                 /* "+ or -"  */
    T_MULOP = 330,                 /* "* or / or %"  */
    T_INCDEC = 331,                /* "-- or ++"  */
    T_SIZEOP = 332,                /* "sizeof"  */
    T_LISTFUNC = 333,              /* "listfunc"  */
    T_LPAREN = 334,                /* "("  */
    T_RPAREN = 335,                /* ")"  */
    T_SEMI = 336,                  /* ";"  */
    T_DOT = 337,                   /* "."  */
    T_COMMA = 338,                 /* ","  */
    T_COLON = 339,                 /* ":"  */
    T_LBRACK = 340,                /* "["  */
    T_RBRACK = 341,                /* "]"  */
    T_REFER = 342,                 /* "&"  */
    T_LBRACE = 343,                /* "{"  */
    T_RBRACE = 344,                /* "}"  */
    T_METH = 345,                  /* "::"  */
    T_INP = 346,                   /* "<<"  */
    T_OUT = 347,                   /* ">>"  */
    T_ASSIGN = 348,                /* "="  */
    T_CCONST = 349,                /* "char const"  */
    T_FCONST = 350,                /* "float const"  */
    T_ICONST = 351,                /* "int const"  */
    T_SCONST = 352,                /* "string const"  */
    T_NOTOP = 353,                 /* "!"  */
    T_RELOP = 354,                 /* "> or >= or < or <="  */
    UMINUS = 355                   /* UMINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 31 "bison.y"

    int intval;
    double doubleval;
    char *strval;

#line 170 "bison.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_BISON_TAB_H_INCLUDED  */
