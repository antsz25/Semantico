#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "exptree.h"

SymbolTable *head = NULL;

// Methods for Symbol Table
SymbolTable *getSymbol(char *name)
{
    SymbolTable *ptr;
    for (ptr = head; ptr != (SymbolTable *)0; ptr = (SymbolTable *)ptr->next)
    {
        if (strcmp(ptr->name, name) == 0)
        {
            return ptr;
        }
    }
    return (SymbolTable *)0;
}
SymbolTable *putSymbol(char *name, char *type)
{
    SymbolTable *nuevo = malloc(sizeof(SymbolTable));
    nuevo->name = name;
    nuevo->type = type;
    nuevo->next = NULL;
    if (head == NULL)
    {
        head = nuevo;
        return head;
    }
    else
    {
        SymbolTable *tmp = head;
        while (tmp->next != NULL)
        {
            tmp = tmp->next;
        }

        // insertar al final
        tmp->next = nuevo;
        return tmp->next;
    }
}
void printSymbol()
{ // Print the Symbol Table
    SymbolTable *temp = head;
    while (temp != NULL)
    {
        printf("%s = %s\n", temp->name, temp->type);
        temp = temp->next;
    }
}
// Delete a variable from the Symbol Table
void deleteFromSymbolTable()
{
    if (head == NULL)
    {
        return;
    }
    else
    {
        SymbolTable *temp = head;
        head = head->next;
        free(temp);
    }
}
// Delete the whole Symbol Table
void deleteSymbolTable()
{
    while (head != NULL)
    {
        deleteFromSymbolTable();
    }
}
// Create a new node for the AST without Type
TreeNode *createNode(char *data)
{
    TreeNode *newNode = (TreeNode *)malloc(sizeof(TreeNode)); // Allocate memory for the new node
    if (newNode)
    { // Initialize the new node
        newNode->data = (char *)malloc(sizeof(data) + 1);
        if (newNode->data != NULL)
        {
            strcpy(newNode->data, data);
            newNode->type = NULL;
            newNode->left = NULL;
            newNode->right = NULL;
        }
    }
    return newNode;
}
// Function to print the AST in prefix notation
void printAST(TreeNode *root)
{
    if (root != NULL)
    {
        printf("%s ", root->data);
        printAST(root->left);
        printAST(root->right);
    }
}
// Function to free the memory of the AST
void freeAST(TreeNode *root)
{
    if (root != NULL)
    {
        freeAST(root->left);
        freeAST(root->right);
        free(root->data);
        free(root->type);
        free(root);
    }
}

// Function to convert AST to intermediate code
void generateIntermediateCode(TreeNode *root)
{
    if (root != NULL)
    {
        if (strcmp(root->data, "+") == 0)
        {
            generateIntermediateCode(root->left);
            generateIntermediateCode(root->right);
            printf("ADD\n");
        }
        else if (strcmp(root->data, "-") == 0)
        {
            generateIntermediateCode(root->left);
            generateIntermediateCode(root->right);
            printf("SUB\n");
        }
        else if (strcmp(root->data, "*") == 0)
        {
            generateIntermediateCode(root->left);
            generateIntermediateCode(root->right);
            printf("MUL\n");
        }
        else if (strcmp(root->data, "/") == 0)
        {
            generateIntermediateCode(root->left);
            generateIntermediateCode(root->right);
            printf("DIV\n");
        }
        else
        {
            printf("PUSH %s\n", root->data);
        }
    }
}
