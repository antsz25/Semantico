%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "g.tab.h"
extern int line_count;
int line_count = 1;
%}
%option noyywrap
%option noinput
%option nounput
letra [a-zA-Z]
digito [0-9]
identificador {letra}({letra}|{digito}|\_)*
%%
\.	 {return (ACCESO_MODIFICADORES);}
\#.+	 {return (COMENTARIOS);}
\"	 {return (COMILLA_DOBLE);}
\'	 {return (COMILLA_SIMPLE);}
\]	 {return (CORCHETEDER);}
\[	 {return (CORCHETEIZQ);}
\}	 {return (LLAVEDER);}
\{ {return (LLAVEIZQ);}
\)	 {return (PARENTDER);}
\(	 {return (PARENTIZQ);}
\,   {return (COMA);}
\_   {return (GUION_BAJO);}
\n {line_count++;}
\=	 {return (ASIGNACION);}
\:   {return (DOSPUNTOS);}
\&\&|\?|\|\||\!|test	 {return (OPERADOR_LOGICO);}
\+|\-|\/|\*|\^|\%	 {return (OPERADORES_MATEMATICOS);}
\=\=|\!\=|\<|\>|\||\<\=|\>\=|\<\>	 {return (OPERADORES_RELACIONALES);}
[0-9]+  {return (NUM);}
while	 {return (CICLOWHILE);}
write	 {return (DESPLEGAR_CARACTERES);}
read	 {return (ENTRADA);}
if	 {return (IF_CONDICIONAL);}
char|String|string|byte|int|float|double	 {return (TIPO_DATO);}
{identificador} {return (ID);}
\"([^\"\\]|\\.)*\"|\'([^\"\\]|\\.)*\' {return (TEXTO);}
[ \t]+ {}
%%