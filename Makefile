# Nombre del ejecutable
TARGET = run

# Compilador
CC = gcc

# Opciones del compilador
CFLAGS = -Wall

# Fuentes
LEX_FILE = scanner.l
YACC_FILE = parser.y
EXPTREE_FILE = exptree.c

# Objetos generados
LEX_C = lex.yy.c
YACC_C = parser.tab.c
YACC_H = parser.tab.h

# Bibliotecas necesarias para Flex
FLEX_LIB = -lfl

# Comandos
FLEX = flex
BISON = bison
VALGRIND = valgrind

all: $(TARGET)

$(TARGET): $(LEX_C) $(YACC_C) $(EXPTREE_FILE)
	$(CC) $(CFLAGS) -o $@ $(LEX_C) $(YACC_C) $(EXPTREE_FILE) $(FLEX_LIB)

$(LEX_C): $(LEX_FILE)
	$(FLEX) $<

$(YACC_C) $(YACC_H): $(YACC_FILE)
	$(BISON) -vd $<

valgrind: $(TARGET)
	$(VALGRIND) --leak-check=full -s --show-leak-kinds=all ./$(TARGET) input.txt

clean:
	rm -f $(TARGET) $(LEX_C) $(YACC_C) $(YACC_H)

.PHONY: all valgrind clean
