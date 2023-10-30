%{
#include <stdio.h>
#include <stdlib.h>
#include "exptree.h"	
void yyerror(const char* message);
int yylex();
extern FILE* yyin;
extern char* yytext;
extern int line_count;
extern SymbolTable *symbolTable;
symbolTable* = NULL;
%}
/*Simbolos Terminales*/
%union{
      char* string;
      int ival;
      char* sval;
      float fval;
      char* type;
      char* op_math;
      char* op_rel;
      char* ASSIGN;
      struct TreeNode* node;
}
%token RBRACK
%token LBRACK
%token LPAR
%token RPAR
%token WHILE
%token WRITE
%token READ
%token IF
%token TOK_EOF
%token <ASSIGN> ASSIGN
%token <op_math> OP_MATH
%token <op_rel> OP_REL
%token <type> TIPO_DATO
%token <ival> NUM
%token <fval> DECIMAL
%token <sval> ID
%token <sval> TEXTO
%left op_math
%left op_rel

%type <node> instruccion
%type <node> bloque_codigo
%type <node> ecuaciones
%type <node> defvar
%type <node> inicioaux
%type <node> valor_ecuaciones
%type <node> valor
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
instrucciones   : instruccion inicioaux {
                    $$ = createNode("Instrucciones"); 
                    $$->left = $1; 
                    $$->right = $2;
                }
                ;
inicioaux   : TOK_EOF {
                printf("Fin de archivo\n");
                $$ = createNode($1);
            }
            | instrucciones {
                printf("Instrucciones\n");
                $$ = createNode($1);
            }
            ;
instruccion : defvar {printf("Definicion de variable\n");}
            | ecuaciones {printf("Ecuaciones\n");}
            | cicloswhile {printf("Ciclo While\n");}
            | pregunton {printf("Pregunton\n");}
            | imprimirdatos {printf("Imprimir datos\n");}
            | leerdatos {printf("Leer datos\n");}
            ;
pregunton   : IF condicion bloque_codigo {}
            ;
defvar  : TIPO_DATO ID asignavalor {
            symboltable = getSymbol($2);
            if(symboltable != NULL){

            }
            else{
                yyerror("Variable ya declarada");
            }
        }
        | ID asignavalor {
            symboltable = getSymbol($2);
            if(symboltable != NULL){
                yyerror("Variable no declarada");
            }
            else{

            }
        }
        ;
asignavalor : ASSIGN valor {
                $$ = createNode($1);
                $$->right = createNode($2);
            }
            ; 
valor   : NUM { 
            $$ = createNode($1);
            $$->type = "int";
        }
        | ID {            
            symboltable = getSymbol($1);
            if(symboltable != NULL){
                $$ = createNode($1);
                $$->type = symboltable->type;
            }
            else{
                yyerror("Variable no declarada");
            }
        }
        | TEXTO {            
            $$ = createNode($1);
            $$->type = "string";
        }
        | DECIMAL {            
            $$ = createNode($1);
            $$->type = "float";
        }
        | ecuaciones
        ;
ecuaciones  : valor_ecuaciones OP_MATH valor_ecuaciones {
                if($1->type == $3->type){
                    $$ = createNode($2);
                    $$->left = createNode($1);
                    $$->right = createNode($3);
                    print("Ecuacion: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n\t Nodo Derecho: %s \n",$$->value,$$->left->value,$$->right->value);
                }
                else{
                    yyerror("Tipos de datos incompatibles en ecuacion");
                }
            }
            ;
valor_ecuaciones    : NUM {
                        $$=createNode($1);
                        $$->type = "int";
                    }
                    | DECIMAL {
                        $$=createNode($1);
                        $$->type = "float";
                    }
                    | ID {
                        symboltable = getSymbol($1);
                        if(symboltable != NULL){
                            $$=createNode($1);
                            $$->type = symboltable->type;
                        }
                        else{
                            yyerror("Variable no declarada");
                        }
                    }
                    ;
cicloswhile : WHILE condicion bloque_codigo {}
            ;
bloque_codigo   : LBRACK inicioaux RBRACK {}
                ;
condicion   : valor op_rel valor {}
            ;
imprimirdatos   : WRITE valor {}
                ;
leerdatos       : READ valor {}
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