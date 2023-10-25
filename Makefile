CC = gcc
CFLAGS = -Wall -g
LEX = flex
YACC = bison
YFLAGS = -d

# List of source files
SRCS = lexer.l parser.y main.c

# Generate corresponding object file names
OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.l=.c)
OBJS := $(OBJS:.y=.c)

# The final executable
TARGET = my_compiler

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ -ll -ly

%.c: lexer.l
	$(LEX) -o $@ $<

%.c: parser.y
	$(YACC) $(YFLAGS) -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET) lex.yy.c y.tab.c y.tab.h

.PHONY: all clean