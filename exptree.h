#ifndef EXPTREE_H
#define EXPTREE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Structure for symbol table
typedef struct SymbolTable
{
    //Guarda Variables
    char *name;
    char *type; 
    struct SymbolTable *next;
} SymbolTable;

// Methods for Symbol Table
extern SymbolTable *head; // Head of the Symbol Table
SymbolTable *getSymbol(char *name);
SymbolTable *putSymbol(char *name, char *type);
void printSymbol();
void deleteFromSymbolTable();
void deleteSymbolTable();

// Structure for a node in the AST
typedef struct TreeNode
{
    //Guarda Instrucciones 
    char *data;
    char *type; 
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

// Create a new node for the AST
TreeNode *createNode(char *data);
// Function to print the AST in prefix notation
void printAST(TreeNode *root);

// Function to free the memory of the AST
void freeAST(TreeNode *root);

/*Creacion Codigo Intermedio*/
typedef struct IntermedioCode
{
    char *op;
    char *arg1;
    char *arg2;
    char *res; 
    struct IntermedioCode *next;
} IntermedioCode;
#endif // EXPTREE_H
