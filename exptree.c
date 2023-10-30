#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "exptree.h"

//Methods for Symbol Table
SymbolTable* getSymbol(char* name){ //Get the variable from the Symbol Table
    SymbolTable *temp = head;
    while(temp != NULL){
        if(strcmp(temp->name, name) == 0){
            return temp;
        }
        temp = temp->next;
    }
    return NULL;
}
void putSymbol(char* name, char* type){ //Insert variable in the Symbol Table
    SymbolTable *temp = head;
    temp = getSymbol(name);
    if(temp != NULL){ // Check if the variable is already declared
        return;
    }
    else{
        temp = (SymbolTable*)malloc(sizeof(SymbolTable));
        temp->name = (char*)malloc(sizeof(name)+1);
        if(temp->name != NULL){
            strcpy(temp->name, name);
            temp->type = type;
            temp->next = head;
            head = temp;
        }
    }
}
void printSymbol(){ // Print the Symbol Table
    SymbolTable *temp = head;
    while(temp != NULL){
        printf("%s = %s\n", temp->name, temp->type);
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
// Create a new node for the AST without Type
TreeNode* createNode(char* data) {
    TreeNode* newNode = (TreeNode*) malloc(sizeof(TreeNode)); // Allocate memory for the new node
    if (newNode) {// Initialize the new node
        newNode->data = (char*) malloc(sizeof(data)+1);
        if(newNode->data != NULL){
            strcpy(newNode->data, data);
            newNode->type = NULL;
            newNode->left = NULL;
            newNode->right = NULL;
        }
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

