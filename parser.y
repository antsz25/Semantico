%{
#include <stdio.h>
#include <stdlib.h>
#include "exptree.c"
#include "exptree.h"	
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
      char* type;
      OP_REL op_rel;
      OP_MATH op_math;
      struct TreeNode* node;
}
%token LLAVEDER
%token LLAVEIZQ
%token LPAR
%token RPAR
%token ASIGNACION
%token CICLOWHILE
%token DESPLEGAR_CARACTERES
%token ENTRADA
%token IF_CONDICIONAL
%token TOK_EOF
%token <op_math> OP_MATH
%token <op_rel> OP_REL
%token <type> TIPO_DATO
%token <ival> NUM
%token <fval> DECIMAL
%token <sval> ID
%token <sval> TEXTO
%left op_math
%left op_rel

%type <node> valor
%type <node> instruccion
%type <node> bloque_codigo
%type <node> ecuaciones
%type <node> defvar
%type <node> inicioaux
%type <node> valor_ecuaciones
%type <node> condicion
%type <node> instrucciones
%type <node> pregunton
%type <node> imprimirdatos
%type <node> cicloswhile
%type <node> leerdatos
%type <node> asignavalor

/*Simbolos no terminales*/
%start instrucciones
%%
instrucciones   : instruccion inicioaux {printf("Instruccion\n");}
                ;
inicioaux   : 
            | instrucciones {printf("Instrucciones\n");}
            ;
instruccion : defvar {printf("Definicion de variable\n");}
            | ecuaciones {printf("Ecuaciones\n");}
            | cicloswhile {printf("Ciclo While\n");}
            | pregunton {printf("Pregunton\n");}
            | imprimirdatos {printf("Imprimir datos\n");}
            | leerdatos {printf("Leer datos\n");}
            ;
pregunton   : IF_CONDICIONAL condicion bloque_codigo {}
            ;
defvar  : TIPO_DATO ID asignavalor {
            if(!contextcheck($2)){
                char* type = $1;
                char* id = $2;
            }
            else{
                yyerror("Variable ya declarada");
            }
        }
        | ID asignavalor {
            if(!contextcheck($1)){
                yyerror("Variable no declarada");
            }
            else{
                char* id = $1;
            }
        }
        ;
asignavalor : ASIGNACION valor {
                char* op = $1;
            }
            | 
            ; 
valor   : NUM { 
            if(checktype(type,"int")){
                putSymbol(id,type);
                $$ = createNode(op);
                $$->left = createNode(id);
                $$->right = createNode($1);
            }
            else{
                yyerror("Tipos de datos incompatibles");
            }
        }
        | ID {            
            Symboltable* sym = getSymbol($1);
            if(sym != NULL){
                if(checktype(type,sym->type)){
                    putSymbol(id,type);
                    $$ = createNode(op);
                    $$->left = createNode(id);
                    $$->right = createNode($1);
                }
                else{
                    yyerror("Tipos de datos incompatibles");
                }
            }
            else{
                yyerror("Variable no declarada");
            }
        }
        | TEXTO {            
            if(checktype(type,"string")){
                putSymbol(id,type);
                $$ = createNode(op);
                $$->left = createNode(id);
                $$->right = createNode($1);
            }
            else{
                yyerror("Tipos de datos incompatibles");
            }
        }
        | DECIMAL {            
            if(checktype(type,"float")){
                putSymbol(id,type);
                $$ = createNode(op);
                $$->left = createNode(id);
                $$->right = createNode($1);    
            }
            else{
                yyerror("Tipos de datos incompatibles");
            }
        }
        ;
ecuaciones  : ID ASIGNACION valor_ecuaciones op_math valor_ecuaciones {}
            ;
valor_ecuaciones    : NUM {}
                    | DECIMAL {}
                    | ID {}
                    ;
cicloswhile : CICLOWHILE condicion bloque_codigo {}
            ;
bloque_codigo   : LLAVEIZQ inicioaux LLAVEDER {}
                ;
condicion   : valor op_rel valor {}
            ;
imprimirdatos   : DESPLEGAR_CARACTERES valor {}
                ;
leerdatos       : ENTRADA valor {}
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
    fclose(archivo);//Cerradura de archivo
    return 0;
}