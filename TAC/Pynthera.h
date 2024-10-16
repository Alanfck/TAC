#include <stdio.h>
#include <map>
#include <string>

using namespace std;

typedef enum { typeCon, typeId, typeOpr} nodeEnum;

/* constants */
typedef struct {
   nodeEnum type;
   int value;                  /* value of constant */
} conNodeType;

/* identifiers */
typedef struct {
   nodeEnum type;
   //int i;               /* índice en tabla de símbolos */
   char name[50];                 
} idNodeType;

/* operators */
typedef struct {
   nodeEnum type;
   int oper;                   /* operator */
   int nops;                   /* number of operands */
   union nodeTypeTag *op[1];  /* operands (expandable) */
} oprNodeType;

typedef union nodeTypeTag {
   nodeEnum type;              /* type of node */

   conNodeType con;        /* constants */
   idNodeType id;          /* identifiers */
   oprNodeType opr;        /* operators */
} nodeType;

//extern int sym[26];

extern map<string,int> sym;