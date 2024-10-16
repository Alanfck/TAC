
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INTEGER = 258,
     VARIABLE = 259,
     WHILE = 260,
     FOR = 261,
     TO = 262,
     IF = 263,
     PRINT = 264,
     AND = 265,
     OR = 266,
     NOR = 267,
     XOR = 268,
     NAND = 269,
     NOT = 270,
     IS = 271,
     FIRST = 272,
     LAST = 273,
     CONSTANT = 274,
     THEN = 275,
     FUNCTION = 276,
     VAR = 277,
     COLON = 278,
     LPAREN = 279,
     RPAREN = 280,
     DOT = 281,
     COMMA = 282,
     LBRACK = 283,
     RBRACK = 284,
     LBRACE = 285,
     RBRACE = 286,
     ASSING = 287,
     INCREMENT = 288,
     DECREMENT = 289,
     IFX = 290,
     ELSE = 291,
     LT = 292,
     GT = 293,
     NEQ = 294,
     EQ = 295,
     LE = 296,
     GE = 297,
     MINUS = 298,
     PLUS = 299,
     DIVIDE = 300,
     TIMES = 301,
     ROOT = 302,
     POW = 303,
     UMINUS = 304
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 27 "Pynthera.y"

    int iValue;                 /* Valor entero */
    /*int sIndex;*/                /* Índice de la tabla de símbolos */
    char name[50];              /*Nombre de la variable*/
    nodeType *nPtr;             /* Apuntador a nodo */



/* Line 1676 of yacc.c  */
#line 110 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


