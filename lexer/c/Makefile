CC=gcc
CFLAGS=-I. -O3 -W -Wall -pedantic -ansi -std=c17
DEPS = file_readall.h lexer.h
OBJ = lexer.o file_readall.o zscript.o

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

zscript: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	rm -f zscript $(OBJ)
