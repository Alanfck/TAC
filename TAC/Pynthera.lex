%{
#include <string.h>
#include "y.tab.h"

int yyerror( char *s );
int yylex();

/*
# define ID         101

# define INT        102    //tipo de datos
# define FLOAT      103
# define BOOL       104

# define COMMA      105  
# define COLON      106          //puntuacion
# define SEMICOLON  107
# define LPAREN     108
# define RPAREN     109
# define LBRACK     110
# define RBRACK     111
# define LBRACE     112
# define RBRACE     113
# define DOT        114

# define PLUS       115
# define MINUS      116
# define TIMES      117       //aritmetica
# define DIVIDE     118
# define ROOT       119
# define POW        120
# define EQ         121
# define NEQ        122

# define AND        123        //operadores logicos
# define OR         124
# define NOR        125
# define XOR        126
# define NAND       127
# define NOT        151

# define LT         128
# define LE         129
# define GT         130
# define GE         131

# define ASSIGN     132
# define VECTOR     133

# define IF         134
# define THEN       135   //Condiciones
# define ELSE       136

# define WHILE      137  //ciclos
# define FOR        138

# define TO         139
# define DO         140 
# define LET        141
# define IN         142
# define END        143
# define OF         144
# define BREAK      145
# define NIL        146
# define FUNCTION   147
# define VAR        148
# define TYPE       149

# define IS         150
# define INCREMENT  151
# define DECREMENT  152
# define FIRST      153
# define LAST       154
# define CONSTANT   155  */



// typedef union  {
// 	int pos;
// 	int ival;
//     float fval;
//     /*bool bval;*/
// 	char* sval;
// } YYSTYPE;

// char* Cadena(char *s)
// {
//    char* p = (char*) malloc(strlen(s)+1);
//    strcpy(p,s);
//    return p;
// }

//YYSTYPE yylval;

%}

digits [0-9]+

%%

 /*[\r\t] {continue;}*/

 /* PALABRAS RESERVADAS */
[;] { return *yytext; }

"if"       { return IF;}
"then"     { return THEN;}
"else"     { return ELSE;}
"while"    { return WHILE;}
"for"  	    { return FOR;}
"def"      { return FUNCTION;}
"var"      { return VAR;}
"and"      { return AND;}
"or"       { return OR;} 
"nor"      { return NOR;}
"xor"      { return XOR;}
"nand"     { return NAND;}
"not"      { return NOT;}
"is"       { return IS;}
"first"    { return FIRST;}
"last"     { return LAST;}
"const"    { return CONSTANT;}
"print"    { return PRINT;}
"to"       {return TO;}

":"      { return COLON;}
"("      { return LPAREN;}
")"      { return RPAREN;}
"."      { return DOT;}
","      { return COMMA;}
"+"      { return PLUS;}
"-"      { return MINUS;}
"*"      { return TIMES;}
"/"      { return DIVIDE;}
"**"     { return POW;}
"^"      { return ROOT;}
"++"     { return INCREMENT;}
"--"     { return DECREMENT;}

"["      { return LBRACK;}
"]"      { return RBRACK;}
"{"      { return LBRACE;}
"}"      { return RBRACE;}

"=="     { return EQ;}
"!="     { return NEQ;}
"<"      { return LT;}
"<="     {return LE;}
">"      { return GT;}
">="     { return GE;} 
"="      { return ASSING;}

[ \t\n+]    ;       /* ignore whitespace */


    /* IDENTIFICADORES */

[a-zA-Z][a-zA-Z0-9]* {strcpy(yylval.name, yytext); return VARIABLE;}


    /* Enteros */

{digits}	 { yylval.iValue=atoi(yytext); return INTEGER;}


    /* Flotantes

{digits}"."{digits}	 { yylval.Fvalue=atof(yytext); return FLOAT;}*/


 /* BOOLEANOS */



   /* Cualquier otra cosa */
.	 yyerror("token no reconocido.");

%%

int yyerror( char *s ) { fprintf( stderr, "%s\n", s); }

int yywrap(void) {
    return 1;
}