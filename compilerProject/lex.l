%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
#include "y.tab.h"
%}

delim   [ \t\n]
ws      {delim}+
digit   [0-9]
number  {digit}+(\.{digit}+)?([eE][+\-]?{digit}+)?
letter  [A-Za-z]
id      {letter}({letter}|{digit})*

%%
{ws}                                    {;}
{number}  								{strcpy(yylval.num , yytext); return NUMBER;}
{id}                        			{strcpy(yylval.id , yytext);  return IDENTFIRE;}
"="                                     {return '=';}
":D:"                                   {return '/';}
":A:"                                   {return '+';}
":S:"                                   {return '-';}
":M:"                                   {return '*';}
"("                                     {return '(';}
")"                                     {return ')';}
.					        			{printf("Error lex ...\n");}
%%

