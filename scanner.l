%{
#include "parser.tab.h"
int line_count = 1;
%}

%option bison-bridge noyywrap

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
\+          { yylval->op_math = yytext;return (OP_MATH);}
\-          {yylval->op_math = yytext; return (OP_MATH);}
\*          {yylval->op_math = yytext; return (OP_MATH);}
\/          {yylval->op_math = yytext; return (OP_MATH);}
\^          {yylval->op_math = yytext; return (OP_MATH);}
\%	        {yylval->op_math = yytext; return (OP_MATH);}

\==         {yylval->op_rel = yytext; return (OP_REL);}
\!=         {yylval->op_rel = yytext; return (OP_REL);}
\<          {yylval->op_rel = yytext; return (OP_REL);}
\>          {yylval->op_rel = yytext; return (OP_REL);}
\<\=        {yylval->op_rel = yytext; return (OP_REL);}
\>\=        {yylval->op_rel = yytext; return (OP_REL);}

\=	        {return (ASSIGN);}

while	    {return (WHILE);}
write	    {return (WRITE);}
read	    {return (READ);}
if	        {return (IF);}

string      {yylval->type = yytext; return (TIPO_DATO);}
int         {yylval->type = yytext; printf(yytext);return (TIPO_DATO);}
float	    {yylval->type = yytext;return (TIPO_DATO);}

{typeint}       { yylval->ival = atol(yytext); return NUM; }
{id}        { yylval->sval = yytext; return ID; }
{typestring}    { yylval->sval = yytext; return TEXTO; }
{typefloat}     {yylval-> fval = atof(yytext); return DECIMAL;}

\n {line_count++;}
[ \t]+      {/*ignore*/}
<<EOF>>     {return (TOK_EOF);}
%%