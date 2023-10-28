#ifndef exptree.h
    #define exptree.h
    #include <stdbool.h>
    // Structure for symbol table
    typedef struct SymbolTable{
        char* name;
        char* type;
        struct SymbolTable* next;
    } SymbolTable;
    // Structure for a node in the AST
    typedef struct TreeNode {
        char* data;
        struct TreeNode* left;
        struct TreeNode* right;
    } TreeNode;
    //Methods for Symbol Table
    SymbolTable *head = NULL; // Head of the Symbol Table
    bool contextcheck(char* name); //Check if variable is already declared
    SymbolTable* getsymbol(char* name); //Get the variable from the Symbol Table
    bool checktype(char* value, char* type); //Check if the type of the value is the same as the type of the variable
    void putSymbol(char* name, char* type); //Insert variable in the Symbol Table
    void print(); // Print the Symbol Table
    void deleteFromSymbolTable();  //Delete a variable from the Symbol Table
    void deleteSymbolTable(); //Delete the Symbol Table
    TreeNode* createNode(const char* data); // Create a new node for the AST
    void printAST(TreeNode* root); // Function to print the AST in prefix notation
    void freeAST(TreeNode* root); // Function to free the memory of the AST
#endif