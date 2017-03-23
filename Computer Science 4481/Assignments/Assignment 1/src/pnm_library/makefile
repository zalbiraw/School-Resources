CC=gcc
CFLAGS=-Wall -c
LFLAGS=-Wall

all: ppm_to_pgm

clean: clean-o
	rm -rf ppm_to_pgm *.o

ppm_to_pgm: ppm_to_pgm.o libpnm.o
	$(CC) $(LFLAGS) -o $@ $^

ppm_to_pgm.o: ppm_to_pgm.c
	$(CC) $(CFLAGS) -o $@ $<

libpnm.o: libpnm.c libpnm.h
	$(CC) $(CFLAGS) -o $@ $<