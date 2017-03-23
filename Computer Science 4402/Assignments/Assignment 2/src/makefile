GCC = gcc -std=c99
CFLAGS = -c
NVCC = nvcc
NVCCFLAGS = -c -O2 --compiler-bindir /usr/bin
LIB = -lm

all: serial parallel clean-o

clean: clean-o
	rm -rf serial parallel

clean-o:
	rm -rf *.o

serial: serial.o
	$(GCC) -o $@ $^ $(LIB)

parallel: parallel.o
	$(NVCC) -o $@ $^ $(LIB)

serial.o: serial.c serial.h
	$(GCC) $(CFLAGS) -o $@ $<

parallel.o: parallel.cu parallel.h
	$(NVCC) $(NVCCFLAGS) -o $@ $<
