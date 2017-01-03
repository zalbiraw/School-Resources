CC=gcc -std=c99
CFLAGS=-Wall -g -c -Wno-deprecated
LFLAGS=-Wall -g
BFLAGS=-framework Carbon -framework OpenGL -framework GLUT

all: clean rectangles

clean:
	rm -rf *.o rectangles

rectangles: rectangles.o
	$(CC) $(LFLAGS) $(BFLAGS) -o $@ $^

rectangles.o: rectangles.c rectangles.h
	$(CC) $(CFLAGS) -o $@ $<