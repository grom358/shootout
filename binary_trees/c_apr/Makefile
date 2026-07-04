CC=gcc
CFLAGS=-O3 -W -Wall -pedantic -std=c17 $(shell pkg-config --cflags --libs apr-1)

binarytree: binarytree.c
	$(CC) -o $@ binarytree.c $(CFLAGS)

clean:
	rm -f binarytree $(OBJ)
