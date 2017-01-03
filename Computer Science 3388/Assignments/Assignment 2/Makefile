CC=gcc -std=c99
CFLAGS=-Wall -g -c -Wno-deprecated
LFLAGS=-Wall -g
BFLAGS=-framework OpenGL -framework GLUT

all: clean vase

clean:
	rm -rf *.o vase

vase: vase.o mesh.o
	$(CC) $(LFLAGS) $(BFLAGS) -lm -o $@ $^

vase.o: vase.c vase.h
	$(CC) $(CFLAGS) -o $@ $<

mesh.o: mesh.c mesh.h
	$(CC) $(CFLAGS) -o $@ $<