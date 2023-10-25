%{
#include "parser.tab.h"

%}

%option reentrant bison-bridge noyywrap

id     [a-zA-Z][a-zA-Z_0-9]*
float  [0-9]+\.[0-9]+
int    [0-9]+
string \"[^\"\n]*\"

%%  
\}	 {return (RBRACK);}
\{ {return (LBRACK);}
\,   {return (COMMA);}
\;  {return (SEMICOLON);}
\+   { yylval->OPERADORES_MATEMATICOS = yytext;return (OPERADORES_MATEMATICOS);}
\-   {yylval->OPERADORES_MATEMATICOS = yytext; return (OPERADORES_MATEMATICOS);}
\*   {yylval->OPERADORES_MATEMATICOS = yytext; return (OPERADORES_MATEMATICOS);}
\/   {yylval->OPERADORES_MATEMATICOS = yytext; return (OPERADORES_MATEMATICOS);}
\^   {yylval->OPERADORES_MATEMATICOS = yytext; return (OPERADORES_MATEMATICOS);}
\%	 {yylval->OPERADORES_MATEMATICOS = yytext; return (OPERADORES_MATEMATICOS);}

\== {yylval->OPERADORES_RELACIONALES = yytext; return (OPERADORES_RELACIONALES);}
\!= {yylval->OPERADORES_RELACIONALES = yytext; return (OPERADORES_RELACIONALES);}
\< {yylval->OPERADORES_RELACIONALES = yytext; return (OPERADORES_RELACIONALES);}
\> {yylval->OPERADORES_RELACIONALES = yytext; return (OPERADORES_RELACIONALES);}
\<\= {yylval->OPERADORES_RELACIONALES = yytext; return (OPERADORES_RELACIONALES);}
\>\= {yylval->OPERADORES_RELACIONALES = yytext; return (OPERADORES_RELACIONALES);}

\=	 {return (ASSIGN);}

while	 {return (WHILE);}
write	 {return (WRITE);}
read	 {return (READ);}
if	    {return (IF);}

string  {yylval->TYPE = yytext; return (TIPO_DATO);}
int     {yylval->TYPE = yytext;return (TIPO_DATO);}
float	 {yylval->TYPE = yytext;return (TIPO_DATO);}

\(        return LPAR;
\)        return RPAR;

{int}      { yylval->ival = atol(yytext); return NUM; }

{id}       { yylval->sval = yytext; return ID; }
{string}   { yylval->sval = yytext; return TEXTO; }
{float}     {yylval-> fval = atof(yytext); return DECIMAL;}

\n {}
[ \t]+ {/*ignore*/}
<<EOF>>    return TOK_EOF;
%%