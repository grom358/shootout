CC=gcc
CFLAGS=-O3 -W -Wall -pedantic -std=c17 -I/usr/include/apr-1 -lapr-1

binarytree: binarytree.c
	$(CC) -o $@ binarytree.c $(CFLAGS)

clean:
	rm -f binarytree $(OBJ)
