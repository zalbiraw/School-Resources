CC = gcc -std=c99
CFLAGS = -c
LFLAGS = -I./lib -L./lib -lpnm

UNAME = $(shell uname)
BIN = /usr/ccs/bin

ifeq ($(UNAME), Darwin)
	BIN = /usr/bin
endif

all: encode decode clean.o

clean: clean.o
	rm -rf encode decode

clean.o:
	rm -rf *.o

encode: encode.o helpers.o dpcm.o
	$(CC) -o $@ $^ $(LFLAGS)

decode: decode.o helpers.o dpcm.o
	$(CC) -o $@ $^ $(LFLAGS)

encode.o: encode.c encode.h
	$(CC) $(CFLAGS) -o $@ $<

decode.o: decode.c decode.h
	$(CC) $(CFLAGS) -o $@ $<

helpers.o: helpers.c helpers.h
	$(CC) $(CFLAGS) -o $@ $<

dpcm.o: dpcm.c dpcm.h
	$(CC) $(CFLAGS) -o $@ $<

libpnm: libpnm.o
	$(BIN)/ar rc ./lib/libpnm.a libpnm.o
	rm libpnm.o

libpnm.o: lib/libpnm.c
	$(CC) $(CFLAGS) -o $@ $^
