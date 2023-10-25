#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct SymbolTable{
    char* name;
    int value;
    struct SymbolTable* next;
} SymbolTable;
SymbolTable *head = NULL;
bool contextcheck(char* name){
    SymbolTable *temp = head;
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0){
            printf("Variable %s is already declared\n", name);
            return true;
        }
        temp = temp->next;
    }
    return false;
}
void insert(char* name, int value){
    if(contextcheck(name)){
        return;
    }
    else{
        SymbolTable *temp = (SymbolTable*)malloc(sizeof(SymbolTable));
        temp->name = strdup(name);
        temp->value = value;
        temp->next = head;
        head = temp;
    }
}
int lookup(char* name){
    SymbolTable *temp = head;
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0){
            return temp->value;
        }
        temp = temp->next;
    }
    printf("Variable %s is not declared\n", name);
    return -1;
}
void print(){
    SymbolTable *temp = head;
    while(temp != NULL){
        printf("%s = %d\n", temp->name, temp->value);
        temp = temp->next;
    }
}
void deleteFromSymbolTable(){
    SymbolTable *temp = head;
    head = head->next;
    free(temp);
}
void deleteSymbolTable(){
    while(head != NULL){
        deleteFromSymbolTable();
    }
}
// Estructura para representar un nodo del AST
typedef struct TreeNode {
    char* data;
    struct TreeNode* left;
    struct TreeNode* right;
} TreeNode;

// Función para crear un nuevo nodo del AST
TreeNode* createNode(const char* data) {
    TreeNode* newNode = (TreeNode*)malloc(sizeof(TreeNode));
    if (newNode) {
        newNode->data = strdup(data);
        newNode->left = NULL;
        newNode->right = NULL;
    }
    return newNode;
}

// Función para imprimir el AST en notación de paréntesis
void printAST(TreeNode* root) {
    if (root) {
        printf("(%s", root->data);
        if (root->left || root->right) {
            printf(" ");
            printAST(root->left);
            if (root->right) {
                printf(" ");
                printAST(root->right);
            }
        }
        printf(")");
    }
}

// Función para liberar la memoria utilizada por el AST
void freeAST(TreeNode* root) {
    if (root) {
        freeAST(root->left);
        freeAST(root->right);
        free(root->data);
        free(root);
    }
}

int main() {
    // Construir un ejemplo de AST
    TreeNode* root = createNode("+");
    root->left = createNode("a");
    root->right = createNode("*");
    root->right->left = createNode("b");
    root->right->right = createNode("c");

    // Imprimir el AST
    printAST(root);
    printf("\n");

    // Liberar la memoria del AST
    freeAST(root);

    return 0;
}
