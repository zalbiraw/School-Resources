CC=g++
CFLAGS=-Wall -g -c -Wno-deprecated
LFLAGS=-Wall -g
BFLAGS=-framework Carbon -framework OpenGL -framework GLUT

all: clean curves

clean:
	rm -rf *.o curves

curves: main.o curves.o pointcanvas.o
	$(CC) $(LFLAGS) $(BFLAGS) -lm -o $@ $^

main.o: main.cpp
	$(CC) $(CFLAGS) -o $@ $<

curves.o: curves.cpp curves.h
	$(CC) $(CFLAGS) -o $@ $<

pointcanvas.o: pointcanvas.cpp pointcanvas.h
	$(CC) $(CFLAGS) -o $@ $<