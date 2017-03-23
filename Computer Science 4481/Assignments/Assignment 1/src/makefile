CC=gcc -std=c99
CFLAGS=-Wall -c
LFLAGS=-Wall

all: rectangles clean-o

clean: clean-o
	rm -rf rectangles

clean-o:
	rm -rf *.o

rectangles: rectangles.o helpers.o validator.o pbm.o pgm.o ppm.o
	$(CC) $(LFLAGS) -o $@ $^

rectangles.o: rectangles.c rectangles.h
	$(CC) $(CFLAGS) -o $@ $<

helpers.o: helpers.c helpers.h
	$(CC) $(CFLAGS) -o $@ $<

validator.o: validator.c validator.h
	$(CC) $(CFLAGS) -o $@ $<

pbm.o: pbm.c pbm.h
	$(CC) $(CFLAGS) -o $@ $<

pgm.o: pgm.c pgm.h
	$(CC) $(CFLAGS) -o $@ $<

ppm.o: ppm.c ppm.h
	$(CC) $(CFLAGS) -o $@ $<