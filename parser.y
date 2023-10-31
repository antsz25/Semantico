%{
#include <stdio.h>
#include <stdlib.h>
#include "exptree.h"	
void yyerror(const char* message);
int yylex();
extern FILE* yyin;
extern char* yytext;
extern int line_count;
SymbolTable* head;
TreeNode* root;
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
      char* WHILE;
      char* IF;
      struct TreeNode* node;
}
%token RBRACK
%token LBRACK
%token LPAR
%token RPAR
%token <sval> WRITE
%token <sval> READ
%token <IF> IF
%token TOK_EOF
%token <WHILE> WHILE
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
root :  instrucciones{
            if($1 != NULL){
                $$ = createNode("root"); 
                $$->type = "void";
                $$->left = $1; 
                $$->right = NULL;
                root = $$;
                printAST(root);
                freeAST(root);
            }
            else{
                yyerror("Instrucciones nulas");
            }
        }
        | TOK_EOF{
            printAST($$);
        }
        ;
instrucciones   : instruccion instrucciones {
                    if($1 != NULL && $2 != NULL){
                        $$ = $1;
                    }
                    else{
                        yyerror("Instrucciones nulas");
                    }
                }
                | %empty{
                    return;
                }
                ;
instruccion : defvar {
                if($1 != NULL){ 
                    $$=$1;
                }
                else{
                    yyerror("Instrucciones nulas");
                }
            }
            | cicloswhile {
                if($1 != NULL){
                    $$ = $1;
                }
                else{
                    yyerror("Instrucciones nulas");
                }
            }
            | pregunton {
                if($1 != NULL){
                    $$ = $1;
                }
                else{
                    yyerror("Instrucciones nulas");
                }
            }
            | imprimirdatos {
                if($1 != NULL){
                    $$ = $1;
                }
                else{
                    yyerror("Instrucciones nulas");
                }
            }
            | leerdatos {
                if($1 != NULL){
                    $$ = $1;
                }
                else{
                    yyerror("Instrucciones nulas");
                }
            }
            ;
pregunton   : IF condicion bloque_codigo {
                $$ = createNode($1);
                $$->right = $2;
                $$->left = $3;
                printf("Pregunton: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n\t Nodo Derecho: %s \n",$$->data,$$->left->data,$$->right->data);
            }
            ;
defvar  : TIPO_DATO ID asignavalor {
            head = getSymbol($2);
            if(head != NULL){
                yyerror("Variable ya declarada");
            }
            else{
                head = putSymbol($2,$1);
                if(head != NULL){
                    if(strcmp(head->type,$3->right->type) == 0){
                        $$ = $3;
                        $$->type = head->type;
                        $$->left = createNode($2);
                        $$->left->type = head->type;
                        $$->right = $3->right;
                        printf("Definicion de variable: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n\t Nodo Derecho: %s \n",$$->data,$$->left->data,$$->right->data);
                    }
                    else{
                        yyerror("Tipos de datos incompatibles en asignacion");
                    }
                }
                else{
                    yyerror("Error en definicion de variable");
                }
            }
        }
        | ID asignavalor {
            head = getSymbol($1);
            if(head != NULL){
                if(head->type !=NULL && $2->right->type !=NULL){
                    if(strcmp(head->type,$2->right->type) == 0){
                        $$ = $2;
                        $$->type = head->type;
                        $$->left = createNode($1);
                        $$->left->type = head->type;
                        $$->right = $2->right;
                        printf("Asignacion de variable: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n\t Nodo Derecho: %s \n",$$->data,$$->left->data,$$->right->data);
                    }
                    else{
                        yyerror("Tipos de datos incompatibles en asignacion");
                    }
                }
                else{
                    yyerror("Valores nulos en asignacion");
                }
            }
            else{
                yyerror("Variable no declarada");
            }
        }
        ;
asignavalor : ASSIGN valor {
                if($2 != NULL){
                    $$ = createNode($1);
                    $$->right = $2;
                }
                else{
                    yyerror("Valor nulo");
                }
            }
            ; 
valor   : NUM { 
            char typestr[20];
            sprintf(typestr, "%d", $1);
            if(typestr!=NULL){
                $$=createNode(typestr);
                $$->type = "int";
            }
            else{
                printf("Valor nulo\n");
                yyerror("Valor nulo");
            }
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
            if($1!=NULL){
                $$ = createNode($1);
                $$->type = "string";
            }
        }
        | DECIMAL {            
            char typestr[20];
            sprintf(typestr, "%.2f", $1);
            if(typestr!=NULL){
                $$=createNode(typestr);
                $$->type = "float";
            }
            else{
                printf("Valor nulo\n");
                yyerror("Valor nulo");
            }
        }
        | ecuaciones {
            if($1 != NULL){
                $$ = $1;
                $$->type = $1->type;
            }
            else{
                yyerror("Valor nulo");
            }
        }
        ;
ecuaciones  : valor_ecuaciones OP_MATH valor_ecuaciones {
                if($1 != NULL && $3 != NULL){
                    if((strcmp($1->type,$3->type) == 0) || 
                        (strcmp($1->type, "float") ==0 && strcmp($3->type, "int") ==0) || 
                        (strcmp($1->type,"int") == 0 && strcmp($3->type,"float") ==0))
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
            }
            ;
valor_ecuaciones    : NUM {
                        char typestr[20];
                        sprintf(typestr, "%d", $1);
                        if(typestr!=NULL){
                            $$=createNode(typestr);
                            $$->type = "int";
                        }
                        else{
                            printf("Valor nulo\n");
                            yyerror("Valor nulo");
                        }
                    }
                    | DECIMAL {
                        char typestr[20];
                        sprintf(typestr, "%.2f", $1);
                        if(typestr!=NULL){
                            $$=createNode(typestr);
                            $$->type = "float";
                        }
                        else{
                            printf("Valor nulo\n");
                            yyerror("Valor nulo");
                        }
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
cicloswhile : WHILE condicion bloque_codigo {
                if($2 != NULL && $3 != NULL){
                    $$ = createNode($1);
                    $$->type = "while";
                    $$->left = $2;
                    $$->right = $3;
                    printf("Ciclo While: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n\t Nodo Derecho: %s \n",$$->data,$$->left->data,$$->right->data);
                }
            }
            ;
bloque_codigo   : LBRACK instrucciones RBRACK {
                    if($2 != NULL){
                        $$ = $2;
                    }
                    else{
                        yyerror("Bloque Vacio");
                    }
                }
                ;
condicion   : valor OP_REL valor {
                if($1 != NULL && $3 != NULL){
                    if((strcmp($1->type,$3->type) == 0) || 
                        (strcmp($1->type, "float") ==0 && strcmp($3->type, "int") ==0) || 
                        (strcmp($1->type,"int") == 0 && strcmp($3->type,"float") ==0))
                        {
                        $$ = createNode($2);
                        $$->type = "bool";
                        $$->left = $1;
                        $$->right = $3;
                        printf("Condicion: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n\t Nodo Derecho: %s \n",$$->data,$$->left->data,$$->right->data);
                    }
                    else{
                        yyerror("Tipos de datos incompatibles en condicion");
                    }
                }
                else{
                    yyerror("Error en condicion");
                }

            }
            ;
imprimirdatos   : WRITE valor {
                    if($2 != NULL){
                        $$ = createNode($1);
                        $$->type = "void";
                        $$->left = $2;
                        $$->right = NULL;
                        printf("Imprimir datos: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n",$$->data,$$->left->data);
                    }
                    else{
                        yyerror("Valor nulo");
                    }
                }
                ;
leerdatos       : READ valor {
                    if($2 != NULL){
                        $$ = createNode($1);
                        $$->type = "void";
                        $$->left = $2;
                        $$->right = NULL;
                        printf("Leer datos: \n\t Nodo Padre: %s \n\t Nodo Izquierdo: %s \n",$$->data,$$->left->data);
                    }
                    else{
                        yyerror("Valor nulo");
                    }
                }
                ;
%%
int main(int argc, char *argv[]){
    head = NULL;
    root = NULL;
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
void yyerror(const char* message) {
    fprintf(stderr, "Error en la línea %d: %s -> %s\n", line_count, message, yytext);
    exit(1);
}