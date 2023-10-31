#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "exptree.h"
extern SymbolTable* head; // Head of the Symbol Table
//Methods for Symbol Table
SymbolTable *getSymbol (char *name )
{
    SymbolTable *ptr;
    for (ptr = head; ptr != (SymbolTable *) 0;ptr = (SymbolTable *)ptr->next){
        if (strcmp (ptr->name,name) == 0){
            return ptr;
        }
    }
    return (SymbolTable *)0;
}
SymbolTable *putSymbol ( char* name, char* type)
{
    
    SymbolTable *ptr;
    ptr = (SymbolTable *) malloc (sizeof(SymbolTable));
    ptr->name = (char *) malloc (strlen(name)+1);
    strcpy (ptr->name,name);
    ptr->type = (char *) malloc(strlen(type)+1);
    strcpy(ptr->type,type);
    ptr->next = (struct SymbolTable *)head;
    if(head != NULL){
        return head->next = ptr;
    }
    else{
        head = ptr;
        return ptr;
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
    if (root != NULL) {
        printf("%s ", root->data);
        printAST(root->left);
        printAST(root->right);
    }
}
// Function to free the memory of the AST
void freeAST(TreeNode* root) {
    if (root != NULL) {
        freeAST(root->left);
        freeAST(root->right);
        free(root->data);
        free(root->type);
        free(root);
    }
}

