/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_G_TAB_H_INCLUDED
# define YY_YY_G_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ACCESO_MODIFICADORES = 258,    /* ACCESO_MODIFICADORES  */
    COMENTARIOS = 259,             /* COMENTARIOS  */
    COMILLA_DOBLE = 260,           /* COMILLA_DOBLE  */
    COMILLA_SIMPLE = 261,          /* COMILLA_SIMPLE  */
    CORCHETEDER = 262,             /* CORCHETEDER  */
    CORCHETEIZQ = 263,             /* CORCHETEIZQ  */
    LLAVEDER = 264,                /* LLAVEDER  */
    LLAVEIZQ = 265,                /* LLAVEIZQ  */
    PARENTDER = 266,               /* PARENTDER  */
    PARENTIZQ = 267,               /* PARENTIZQ  */
    COMA = 268,                    /* COMA  */
    GUION_BAJO = 269,              /* GUION_BAJO  */
    ASIGNACION = 270,              /* ASIGNACION  */
    DOSPUNTOS = 271,               /* DOSPUNTOS  */
    OPERADOR_LOGICO = 272,         /* OPERADOR_LOGICO  */
    OPERADORES_MATEMATICOS = 273,  /* OPERADORES_MATEMATICOS  */
    OPERADORES_RELACIONALES = 274, /* OPERADORES_RELACIONALES  */
    NUM = 275,                     /* NUM  */
    CICLOWHILE = 276,              /* CICLOWHILE  */
    DESPLEGAR_CARACTERES = 277,    /* DESPLEGAR_CARACTERES  */
    ENTRADA = 278,                 /* ENTRADA  */
    IF_CONDICIONAL = 279,          /* IF_CONDICIONAL  */
    TIPO_DATO = 280,               /* TIPO_DATO  */
    ID = 281,                      /* ID  */
    TEXTO = 282                    /* TEXTO  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_G_TAB_H_INCLUDED  */
