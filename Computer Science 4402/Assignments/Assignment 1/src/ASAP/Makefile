CC=$(HOME)/cilkplus-install/bin/gcc -std=c99
CFLAGS=-Wall -c

all: clean ASAP

clean:
	rm -rf *.o ASAP

ASAP: ASAP.o
	$(CC) -o $@ $^  -fcilkplus -lcilkrts -lm

ASAP.o: ASAP.c ASAP.h
	$(CC) $(CFLAGS) -o $@ $< -fcilkplus -lcilkrts -lm