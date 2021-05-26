%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
"main"                  return T_MAIN; 
"{"                     return T_OB;
"}"                     return T_CB;
"const"                 return T_CONST;
"int"                   return T_INT;
"printf"                return T_PRINTF;
"+"                     return T_PLUS;
"-"                     return T_MOINS;
"/"                     return T_DIV;
"*"                     return T_MUL;
"="                     return T_EQUAL;
"("                     return T_OP;
")"                     return T_CP;
","                     return T_VIRG;
";"                     return T_PV;
[0-9]+[Ee]?[-+]?[0-9]*  { yylval.nombre = atoi(yytext); return T_NB; }
">"                     return T_SUP;
"<"                     return T_INF;
"if ("                  return T_IF_OP;
"if"					return T_IF;
"else"                  return T_ELSE;
"!="                    return T_DIFF;
"=="                    return T_CMP_EQU;
"while"                 return T_WHILE;
[a-z][A-Za-z0-9_]*     {
                         yylval.vari= malloc(yyleng);
						strcpy(yylval.vari, yytext);  return T_VAR; }
[ ]+					;
[\t]+                	;
[\n]+					;

%%
int yywrap()
{  
return 1;
}


