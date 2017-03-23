CC=$(HOME)/cilkplus-install/bin/gcc -std=c99
CFLAGS=-Wall -c

all: clean pascal pascal_non_parallel

clean:
	rm -rf *.o pascal pascal_non_parallel

pascal: pascal.o
	$(CC) -o $@ $^  -fcilkplus -lcilkrts -lm

pascal_non_parallel: pascal_non_parallel.o
	$(CC) -o $@ $^ -lm

pascal.o: pascal.c pascal.h
	$(CC) $(CFLAGS) -o $@ $< -fcilkplus -lcilkrts -lm

pascal_non_parallel.o: pascal_non_parallel.c pascal.h
	$(CC) $(CFLAGS) -o $@ $< -lm