%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char* message);
int yylex();
extern FILE* yyin;
extern char* yytext;
extern int line_count;
%}
/*Simbolos Terminales*/
%union{
      char* string;
      int ival;
      char* sval;
      float fval;
      char* TYPE;
      OPERADORES_RELACIONALES operadores_relacionales;
      OPERADORES_MATEMATICOS operadores_matematicos;
      struct TreeNode* node;
      struct TreeNode* nodeleft;
      struct TreeNode* noderight;
}
%token ACCESO_MODIFICADORES
%token COMENTARIOS
%token COMILLA_DOBLE
%token COMILLA_SIMPLE
%token CORCHETEDER
%token CORCHETEIZQ
%token LLAVEDER
%token LLAVEIZQ
%token PARENTDER
%token PARENTIZQ
%token COMA
%token GUION_BAJO
%token ASIGNACION
%token DOSPUNTOS
%token OPERADOR_LOGICO
%token <operadores_matematicos> OPERADORES_MATEMATICOS
%token <operadores_relacionales> OPERADORES_RELACIONALES
%token CICLOWHILE
%token DESPLEGAR_CARACTERES
%token ENTRADA
%token IF_CONDICIONAL
%token <TYPE> TIPO_DATO
%token <ival> NUM
%token <fval> DECIMAL
%token <sval> ID
%token <sval> TEXTO
%left OPERADORES_MATEMATICOS
%left OPERADORES_RELACIONALES

/*Simbolos no terminales*/
%start instrucciones
%%
instrucciones   : instruccion inicioaux
                ;
inicioaux   : 
            | instrucciones
            ;
instruccion     : defvar
                | ecuaciones
                | ciclos
                | pregunton_comodijoerasmo
                | imprimirdatos
                | leerdatos
                ;
pregunton_comodijoerasmo    : IF_CONDICIONAL condicion bloque_codigo
                            ;
defvar  : TIPO_DATO ID asignavalor 
        | ID asignavalor 
        ;
asignavalor : ASIGNACION valor
            |
            ; 
valor   : NUM
        | ID
        | TEXTO
        | DECIMAL
        ;
ecuaciones  : ID ASIGNACION valor_ecuaciones OPERADORES_MATEMATICOS valor_ecuaciones 
            ;
valor_ecuaciones        : NUM
                        | DECIMAL
                        | ID
                        ;
ciclos  : CICLOWHILE condicion bloque_codigo
        ;
bloque_codigo   : LLAVEIZQ inicioaux LLAVEDER
                ;
condicion       : valor OPERADORES_RELACIONALES valor
                ;
imprimirdatos   : DESPLEGAR_CARACTERES valor
                ;
leerdatos       : ID ENTRADA valor
                ;
%%
void yyerror(const char* message) {
    fprintf(stderr, "Error en la línea %d: %s -> %s\n", line_count, message, yytext);
}
int main(int argc, char *argv[]){
    if (argc < 2) { //Utilizacion de archivo de entrada
        printf("Uso: %s archivo_de_entrada\n", argv[0]);
    }
    FILE *archivo = fopen(argv[1], "r");//Inicializacion de archivo de entrada
    if (archivo == NULL) {//Verificacion de apertura correcta de archivo
        printf("Error: no se pudo abrir el archivo de entrada.\n");
        return 1;
    }
    yyin = archivo; // Archivo a escanear
    yyparse();
    printf("Analisis Sintactico correcto \n");
    fclose(archivo);//Cerradura de archivo
    return 0;
}