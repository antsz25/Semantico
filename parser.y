%{
#include <stdio.h>
#include <stdlib.h>
#include "exptree.h"	
void yyerror(const char* message);
int yylex();
extern FILE* yyin;
extern char* yytext;
extern int line_count;
extern SymbolTable* head;
extern TreeNode* root;
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
%left OP_MATH
%left OP_REL

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
%type <node> root

/*Simbolos no terminales*/
%start root
%%
root :  instrucciones {
            $$ = createNode("root"); 
            $$->type = "void";
            $$->left = $1; 
            $$->right = NULL;
            root = $$;
        }
        ;
instrucciones   : instruccion inicioaux {
                    $$ = createNode("Instrucciones");
                    $$->type = "void";
                    $$->left = $1;
                    $$->right = $2;         
                }
                ;
inicioaux   : TOK_EOF {
                printf("Fin de archivo\n");
                printAST(root);
            }
            | instrucciones {
                printf("Instrucciones\n");
                $$ = $1;
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
            head = getSymbol($2);
            if(head != NULL){
                yyerror("Variable ya declarada");
            }
            else{
                putSymbol($2,$1);
                head = getSymbol($2);
                if(head->type == $3->right->type){
                    $$ = $3;
                    $$->type = head->type;
                    $$->left = createNode($2);
                    $$->left->type = head->type;
                    $$->right = $3->right;
                }
                else{
                    yyerror("Tipos de datos incompatibles en asignacion");
                }
            }
        }
        | ID asignavalor {
            head = getSymbol($1);
            if(head != NULL){
                if(head->type == $2->right->type){
                    $$ = $2;
                    $$->type = head->type;
                    $$->left = createNode($1);
                    $$->left->type = head->type;
                    $$->right = $2->right;
                }
                else{
                    yyerror("Tipos de datos incompatibles en asignacion");
                }
            }
            else{
                yyerror("Variable no declarada");
            }
        }
        ;
asignavalor : ASSIGN valor {
                $$ = createNode($1);
                $$->right = $2;
            }
            ; 
valor   : NUM { 
            char typestr[20];
            sprintf(typestr, "%d", $1);
            $$=createNode(typestr);
            $$->type = "int";
        }
        | ID {            
            head = getSymbol($1);
            if(head != NULL){
                $$ = createNode($1);
                $$->type = head->type;
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
            char typestr[20];
            sprintf(typestr, "%.2f", $1);
            $$=createNode(typestr);
            $$->type = "float";
        }
        | ecuaciones {
            $$ = $1;
            $$->type = $1->type;
        }
        ;
ecuaciones  : valor_ecuaciones OP_MATH valor_ecuaciones {
                if($1->type == $3->type || 
                    $1->type == "float" && $3->type == "int" || 
                    $1->type == "int" && $3->type == "float")
                    {
                    $$ = createNode($2);
                    $$->type = $1->type;
                    $$->left = $1;
                    $$->right = $3;
                    printf("Ecuacion: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n\t Nodo Derecho: %s \n",$$->data,$$->left->data,$$->right->data);
                }
                else{
                    yyerror("Tipos de datos incompatibles en ecuacion");
                }
            }
            ;
valor_ecuaciones    : NUM {
                        char typestr[20];
                        sprintf(typestr, "%d", $1);
                        $$=createNode(typestr);
                        $$->type = "int";
                    }
                    | DECIMAL {
                        char typestr[20];
                        sprintf(typestr, "%.2f", $1);
                        $$=createNode(typestr);
                        $$->type = "float";
                    }
                    | ID {
                        head = getSymbol($1);
                        if(head != NULL){
                            $$=createNode($1);
                            $$->type = head->type;
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
condicion   : valor OP_REL valor {}
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