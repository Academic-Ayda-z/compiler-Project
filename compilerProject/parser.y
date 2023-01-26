%{
void yyerror (char *s);
int yylex();
#include <stdio.h>
#include <math.h>    
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
int indexT=1;
char string[20];
char t[2];
int lastT=0;
char lastTvalue[1000];
void printResult(char *x,char sign,char *y);
void tostring(char str[], int num);
void constructLastT(char *x,char* sign,char *y);
%}

%union{
    char id[20];
    char num[20];
    char nonTerminal[20];
    } 

%start assignment

%token <num> NUMBER
%token <id> IDENTFIRE

%type <nonTerminal> assignment expr term factor 

/* Precedence Operator */

%right '='
%right  '-' '+'
%right  '*' '/'
%left  UMINUS 

%%

/* descriptions of expected inputs     corresponding actions (in C) */

assignment  : IDENTFIRE '=' expr    {printf("%s = %s ;\n",$1,$3);}
            ;


expr    :  term '+' expr      {tostring(string,indexT);strcpy(t,"t");strcat(t,string);strcpy($$,t);
                                    if(lastT)printResult($3,'+',$1);
                                    else {constructLastT($3,"+",$1);strcpy($$,lastTvalue);} }

        |  term '-' expr      {tostring(string,indexT);strcpy(t,"t");strcat(t,string);strcpy($$,t);                        
                                    if(lastT)printResult($3,'-',$1);
                                    else {constructLastT($3,"-",$1);strcpy($$,lastTvalue);} }
        |  term               {strcpy($$,$1);}
        ;


term    :  factor '*' term    {tostring(string,indexT);strcpy(t,"t");strcat(t,string);printf("t%d = %s * %s;\n", indexT++, $3, $1);strcpy($$,t);}
        |  factor '/' term    {tostring(string,indexT);strcpy(t,"t");strcat(t,string);printf("t%d = %s / %s;\n", indexT++, $3, $1);strcpy($$,t);}
        |  factor             {strcpy($$,$1);}
        ;


factor  : '(' expr ')'    {strcpy($$, $2);}
        | IDENTFIRE       {strcpy($$, $1); }
        | NUMBER          {strcpy($$, $1); }
        ;


%%
void printResult(char *x,char sign,char *y){
    printf("t%d= %s %c %s;\n",indexT++ , x,sign,y);
}

void constructLastT(char *x, char* sign,char *y){
    strcpy(lastTvalue,x);strcat(lastTvalue,sign);strcat(lastTvalue,y);

}
void tostring(char str[], int num)
{
    int i, rem, len = 0, n;
 
    n = num;
    while (n != 0)
    {
        len++;
        n /= 10;
    }
    for (i = 0; i < len; i++)
    {
        rem = num % 10;
        num = num / 10;
        str[len - (i + 1)] = rem + '0';
    }
    str[len] = '\0';
}
 

void yyerror(char *msg) {
    fprintf(stderr,"error %s\n",msg);
    exit(1);
}


int yywrap() {
    return 1;
}

int main() {
   yyparse();
}