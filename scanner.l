%{
#include "parser.tab.h"
int line_count = 1;
%}

%option noyywrap

/*Structure for the tokens*/
id     [a-zA-Z][a-zA-Z_0-9]*
typefloat  [0-9]+\.[0-9]+
typeint    [0-9]+
typestring \"[^\"\n]*\"


%%  
\}          {return (RBRACK);}
\{          {return (LBRACK);}
\(          {return (LPAR);}
\)          {return (RPAR);}
\+          {yylval.op_math =strdup(yytext);return (OP_MATH);}
\-          {yylval.op_math = strdup(yytext); return (OP_MATH);}
\*          {yylval.op_math = strdup(yytext); return (OP_MATH);}
\/          {yylval.op_math = strdup(yytext); return (OP_MATH);}
\^          {yylval.op_math = strdup(yytext); return (OP_MATH);}
\%	        {yylval.op_math = strdup(yytext); return (OP_MATH);}

\==         {yylval.op_rel = strdup(yytext); return (OP_REL);}
\!=         {yylval.op_rel = strdup(yytext); return (OP_REL);}
\<          {yylval.op_rel = strdup(yytext); return (OP_REL);}
\>          {yylval.op_rel = strdup(yytext); return (OP_REL);}
\<\=        {yylval.op_rel = strdup(yytext); return (OP_REL);}
\>\=        {yylval.op_rel = strdup(yytext); return (OP_REL);}

\=	        {yylval.ASSIGN = strdup(yytext); return (ASSIGN);}

while	    {return (WHILE);}
write	    {return (WRITE);}
read	    {return (READ);}
if	        {return (IF);}

string      {yylval.type = strdup(yytext); return (TIPO_DATO);}
int         {yylval.type = strdup(yytext); return (TIPO_DATO);}
float	    {yylval.type = strdup(yytext);return (TIPO_DATO);}

{typeint}       { yylval.ival = atoi(yytext); return NUM; }
{id}        { yylval.sval = strdup(yytext); return ID; }
{typestring}    { yylval.sval = strdup(yytext); return TEXTO; }
{typefloat}     {yylval. fval = atof(yytext); return DECIMAL;}

\n {line_count++;}
[ \t]+      {/*ignore*/}
<<EOF>>     {return TOK_EOF;}
%%