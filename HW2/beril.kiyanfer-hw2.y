%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
void yyerror(const char *s);;

%}

%union {
    char* str;
}

%token <str> tIDENTIFIER
%token tINPUT tOUTPUT tNODE tEVALUATE tAND tOR tXOR tNOT tTRUE tFALSE tLPR tRPR tASSIGN tCOMMA

/* Operator precedence */
%right tASSIGN
%left tOR tXOR
%left tAND
%right tNOT
%left tLPR tRPR

%%

Program: DeclarationsBlock CircuitDesignBlock EvaluationsBlock
       ;

DeclarationsBlock: Declaration DeclarationsBlock 
                 | /* empty */
                 ;

Declaration: tINPUT IdentifierList 
           | tOUTPUT IdentifierList 
           | tNODE IdentifierList
           ;

IdentifierList: tIDENTIFIER 
              | tIDENTIFIER tCOMMA IdentifierList
              ;

CircuitDesignBlock: Assignment CircuitDesignBlock 
                 | 
                 ;

Assignment: tIDENTIFIER tASSIGN Expression
          ;

Expression: tIDENTIFIER 
          | tNOT Expression 
          | Expression tAND Expression
          | Expression tOR Expression
          | Expression tXOR Expression
          | tLPR Expression tRPR
          | tTRUE 
          | tFALSE
          ;

EvaluationsBlock: Evaluation EvaluationsBlock 
                | 
                ;

Evaluation: tEVALUATE tIDENTIFIER tLPR InputInitList tRPR
          ;

InputInitList: InputInit 
             | InputInit tCOMMA InputInitList
             ;

InputInit: tIDENTIFIER tASSIGN tTRUE
         | tIDENTIFIER tASSIGN tFALSE
         ;

%%

int main ()
{
    if (yyparse())
    {
        printf("ERROR\n");
        return 1;
    }
    else
    {
        printf("OK\n");
        return 0;
    }
}

void yyerror(const char *msg) {
    
}
