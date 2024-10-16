%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "Pynthera.h"
#include "lex.yy.c"
#include <map>
#include <string>

using namespace std;

/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(char* i);
nodeType *con(int value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int ex2(nodeType *p);
int exTAC(nodeType *p);
//int sym[26]; /* Tabla de símbolos */

map<string,int> sym;   /*mapa de símbolos*/

%}

/* Declaración de Yacc que generará una Unión en C */
%union {
    int iValue;                 /* Valor entero */
    /*int sIndex;*/                /* Índice de la tabla de símbolos */
    char name[50];              /*Nombre de la variable*/
    nodeType *nPtr;             /* Apuntador a nodo */
};

%token <iValue> INTEGER
%token <name> VARIABLE
%token WHILE FOR TO IF PRINT AND OR NOR XOR NAND NOT IS FIRST LAST  CONSTANT
%token THEN FUNCTION VAR COLON LPAREN RPAREN DOT COMMA LBRACK RBRACK LBRACE RBRACE ASSING INCREMENT DECREMENT
%nonassoc IFX
%nonassoc ELSE

%left AND OR
%left GE LE EQ NEQ GT LT
%left PLUS MINUS
%left TIMES DIVIDE '%'
%left POW ROOT
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list

%% 

program:
         function DOT      { exit(0) }
         ;

function:
         function stmt     { exTAC($2); freeNode($2) }
         | /* NULL */
         ;

stmt:
         expr { $$ = $1; }
         | PRINT expr { $$ = opr(PRINT, 1, $2); }
         | VARIABLE ASSING expr { $$ = opr(ASSING, 2, id($1), $3); }
         | WHILE LPAREN expr RPAREN COLON stmt { $$ = opr(WHILE, 2, $3, $6); }
         | IF LPAREN expr RPAREN COLON stmt { $$ = opr(IF, 2, $3, $6); }
         | IF LPAREN expr RPAREN COLON stmt ELSE stmt { $$ = opr(IF, 3, $3, $6, $8); }
         | FOR VARIABLE ASSING expr TO expr COLON stmt {$$ = opr(FOR, 4, id($2), $4, $6, $8);}
         | stmt_list { $$ = $1; }
         ;

stmt_list:
         stmt { $$ = $1; }
         | stmt_list stmt { $$ = opr('\n', 2, $1, $2); }
         ;


expr:
         INTEGER                 { $$ = con($1) }
         | VARIABLE              { $$ = id($1) }
         | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2) }
         | expr PLUS expr         { $$ = opr(PLUS, 2, $1, $3) }
         | expr MINUS expr        { $$ = opr(MINUS, 2, $1, $3) }
         | expr TIMES expr        { $$ = opr(TIMES, 2, $1, $3) }
         | expr DIVIDE expr       { $$ = opr(DIVIDE, 2, $1, $3) }
         | expr LT expr          { $$ = opr(LT, 2, $1, $3) }
         | expr GT expr          { $$ = opr(GT, 2, $1, $3) }
         | expr GE expr          { $$ = opr(GE, 2, $1, $3) }
         | expr LE expr          { $$ = opr(LE, 2, $1, $3) }
         | expr NEQ expr         { $$ = opr(NEQ, 2, $1, $3) }
         | expr EQ expr          { $$ = opr(EQ, 2, $1, $3) }
         | expr AND expr         { $$ = opr(AND, 2, $1, $3) }
         | expr OR expr          { $$ = opr(OR, 2, $1, $3) }
         | LPAREN expr RPAREN          { $$ = $2 }
         ;

%% 




nodeType *con(int value) {
   nodeType *p;

   /* allocate node */
   if ((p =(nodeType *) malloc(sizeof(conNodeType))) == NULL)
      yyerror("out of memory");

   /* copy information */
   p->type = typeCon;
   p->con.value = value;

   return p;
}

nodeType *id(char* i) {
   nodeType *p;

   /* allocate node */
   if ((p = (nodeType *) malloc(sizeof(idNodeType))) == NULL)
      yyerror("out of memory");

   /* copy information */
   p->type = typeId;
   //p->id.name = i;
   strcpy(p->id.name, i);

   return p;
}

nodeType *opr(int oper, int nops, ...) {
   va_list ap;          /*va_list es un tipo de dato para iterar los argumentos variables*/
   nodeType *p;
   size_t size;
   int i;

   /* allocate node */
   size = sizeof(oprNodeType) + (nops-1) * sizeof(nodeType*);
   if ((p =(nodeType *) malloc(size)) == NULL)
      yyerror("out of memory");

   /* copy information */
   p->type = typeOpr;
   p->opr.oper = oper;
   p->opr.nops = nops;
   va_start(ap, nops);
   for (i = 0; i < nops; i++)
      p->opr.op[i] = va_arg(ap, nodeType*);
   va_end(ap);
   return p;
}

void freeNode(nodeType *p) {
   int i;

   if (!p) return;
   if (p->type == typeOpr) {
      for (i = 0; i < p->opr.nops; i++)
         freeNode(p->opr.op[i]);
   }
   free (p);
}

int temp_var=0; //para llevar la cuenta de las variables temporales
int Ls = 0;

int exTAC(nodeType *p) {

    int temp1, temp2, temp3;  //son las temporales por cada instruccion
   
   if (!p) return 0;
   switch(p->type) {
      case typeCon:
        temp1 = temp_var++;
        printf("t%d = %d\n", temp1, p->con.value);
        return temp1;

      case typeId : 
        temp1 = temp_var++;
        printf("t%d = %s\n", temp1, p->id.name);
            return temp1; 

      case typeOpr: 
         switch(p->opr.oper) {
            case WHILE: 
                printf("\nL%d:\n", Ls);  //inicio de bucle
                temp1 = exTAC(p->opr.op[0]);
                printf("ifFalse t%d goto L%d\n", temp1, Ls + 1);  // Condición de fin del bucle
                exTAC(p->opr.op[1]); //stmt_list
                printf("goto L%d\n", Ls); // se regresa al incio
                printf("\nL%d:\n", Ls+1);  // literal el final del bucle
                Ls += 2;
                return 0;

            case FOR:{          //tuve que poner estos corchetes porque c++ no deja declarar variables dentro de un case


               int *var = &sym[p->opr.op[0]->id.name]; // Variable del bucle
               temp1 = exTAC(p->opr.op[1]); // Inicialización
               printf("%s = t%d\n", p->opr.op[0]->id.name, temp1);

               printf("L%d:\n", Ls); // Inicio del bucle
               temp2 = exTAC(p->opr.op[2]); // Condición
               printf("ifFalse t%d goto L%d\n", temp2, Ls + 1); // Salida del bucle

               exTAC(p->opr.op[3]); // Cuerpo del bucle
               printf("%s = %s + 1\n", p->opr.op[0]->id.name, p->opr.op[0]->id.name); // Incremento
               printf("goto L%d\n", Ls); // Volver al inicio
               printf("L%d:\n", Ls + 1); // Fin del bucle
               Ls += 2;

               return 0;
            }


            case IF: temp1 = exTAC(p->opr.op[0]);
                     printf("ifFalse t%d goto L%d\n", temp1, Ls);
                     exTAC(p->opr.op[1]); 
                     if (p->opr.nops > 2) {
                        printf("goto L%d\n", Ls + 1);
                        printf("L%d:\n", Ls);  //L del else
                        exTAC(p->opr.op[2]); 
                        printf("L%d:\n", Ls + 1);
                        Ls += 2;
                    } 
                    else {
                        printf("L%d:\n", Ls);
                        Ls++;
                    }
                    return 0;

            case PRINT: temp1 = exTAC(p->opr.op[0]);  // Valor a imprimir
                        printf("print t%d\n", temp1);
                        return 0;

             case ';':   exTAC(p->opr.op[0]);
               return exTAC(p->opr.op[1]);

            case ASSING:
                temp1 = exTAC(p->opr.op[1]);
                printf("%s = t%d\n", p->opr.op[0]->id.name, temp1);
                return temp1;

            // case UMINUS: return -ex2(p->opr.op[0]);
            case PLUS: 
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d + t%d\n", temp3, temp1, temp2);
                return temp3;
            case MINUS: 
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d - t%d\n", temp3, temp1, temp2);
                return temp3;
            case TIMES:
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d * t%d\n", temp3, temp1, temp2);
                return temp3;
            case DIVIDE: 
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d / t%d\n", temp3, temp1, temp2);
                return temp3;

            case LT:
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d < t%d\n", temp3, temp1, temp2);
               return temp3;
            case GT: 
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d > t%d\n", temp3, temp1, temp2);
                return temp3;
            case GE:
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d >= t%d\n", temp3, temp1, temp2);
               return temp3; 
            case LE:
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d <= t%d\n", temp3, temp1, temp2);
               return temp3; 
            case NEQ:
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d != t%d\n", temp3, temp1, temp2);
               return temp3; 
            case EQ: 
                temp1 = exTAC(p->opr.op[0]);
                temp2 = exTAC(p->opr.op[1]);
                temp3 = temp_var++;
                printf("t%d = t%d == t%d\n", temp3, temp1, temp2);
               return temp3;

            //case AND: //return ex2(p->opr.op[0]) && ex2(p->opr.op[1]);
            //case OR: //return ex2(p->opr.op[0]) || ex2(p->opr.op[1]);
        }
   }
}

int main(int argc, char **argv) {
   extern FILE* yyin;

   yyin = fopen(argv[1], "r");
   yyparse();

   return 0;
}