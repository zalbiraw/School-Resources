CC=gcc -std=c99
CFLAGS= -c

UNAME = $(shell uname)
BIN = /usr/ccs/bin

ifeq ($(UNAME), Darwin)
	BIN = /usr/bin
endif 

all: main clean

clean:
	rm -rf *.o

main: main.o bst.o
	$(CC) -o $@ $^

main.o: main.c main.h
	$(CC) $(CFLAGS) -o $@ $< -I. -L. -lpnm

bst.o: bst.c bst.h
	$(CC) $(CFLAGS) -o $@ $<

libpnm: libpnm.o
	$(BIN)/ar rc libpnm.a libpnm.o
	$(BIN)/ranlib libpnm.a
	rm libpnm.o

libpnm.o: lib/libpnm.c
	$(CC) $(CFLAGS) -o $@ $<