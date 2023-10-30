#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "exptree.h"

// Structure for symbol table
typedef struct SymbolTable{
    char* name;
    char* type;
    struct SymbolTable* next;
} SymbolTable;
// Structure for a node in the AST
typedef struct TreeNode {
    char* data;
    char* type;
    struct TreeNode* left;
    struct TreeNode* right;
} TreeNode;
//Methods for Symbol Table
SymbolTable *head = NULL; // Head of the Symbol Table
bool contextcheck(char* name){ //Check if variable is already declared
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
SymbolTable* getsymbol(char* name){ //Get the variable from the Symbol Table
    SymbolTable *temp = head;
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0){
            return temp;
        }
        temp = temp->next;
    }
    return NULL;
}

bool checktype(char* value, char* type){
    if(strcmp(value,type) == 0){
        return true; //If the type of the value is the same as the type of the variable
    }
    else{
        return false; //If the type of the value is not the same as the type of the variable
    }
}
void putSymbol(char* name, char* type){ //Insert variable in the Symbol Table
    if(contextcheck(name)){ // Check if the variable is already declared
        return;
    }
    else{
        SymbolTable *temp = (SymbolTable*)malloc(sizeof(SymbolTable));
        temp->name = strdup(name);
        temp->type = type;
        temp->next = head;
        head = temp;
    }
}
void print(){ // Print the Symbol Table
    SymbolTable *temp = head;
    while(temp != NULL){
        printf("%s = %d\n", temp->name, temp->type);
        temp = temp->next;
    }
}
//Delete a variable from the Symbol Table
void deleteFromSymbolTable(){
    if(head == NULL){
        return;
    }
    else{
        SymbolTable *temp = head;
        head = head->next;
        free(temp);
    }
}
//Delete the whole Symbol Table
void deleteSymbolTable(){
    while(head != NULL){
        deleteFromSymbolTable();
    }
}

// Create a new node for the AST
TreeNode* createNode(char* data, char* type) {
    TreeNode* newNode = (TreeNode*) malloc(sizeof(TreeNode)); // Allocate memory for the new node
    if (newNode) {// Initialize the new node
        newNode->data = strdup(data);
        newNode->left = NULL;
        newNode->right = NULL;
    }
    return newNode;
}

// Function to print the AST in prefix notation
void printAST(TreeNode* root) {
    if (root) {
        printf("%s ", root->data);
        printf("%s ", root->type);
        printAST(root->left);
        printAST(root->right);
    }
}
// Function to free the memory of the AST
void freeAST(TreeNode* root) {
    if (root) {
        freeAST(root->left);
        freeAST(root->right);
        free(root->data);
        free(root->type);
        free(root);
    }
}

