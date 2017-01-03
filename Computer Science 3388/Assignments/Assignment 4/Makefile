CC=gcc -std=c99
CFLAGS=-Wall -c -Wno-deprecated
LFLAGS=-Wall
GLFLAG=-framework Carbon -framework OpenGL -framework GLUT
MFLAG=-lm
TAR_FILE=raytrace.tar.gz
PFLAG=-pthread

all: clean raytracer

clean:
	rm -rf *.o *.tar.gz raytracer

raytracer: main.o raytracer.o world.o world_objects.o vector.o linked_list.o logger.o
	$(CC) $(LFLAGS) -lm -o $@ $^ $(GLFLAG) $(PFLAG) $(MFLAG)

main.o: main.c main.h
	$(CC) $(CFLAGS) -o $@ $<

raytracer.o: raytracer.c raytracer.h
	$(CC) $(CFLAGS) -o $@ $<

world.o: world.c world.h
	$(CC) $(CFLAGS) -o $@ $<

world_objects.o: world_objects.c world_objects.h
	$(CC) $(CFLAGS) -o $@ $<	

vector.o: vector.c vector.h
	$(CC) $(CFLAGS) -o $@ $<

linked_list.o: linked_list.c linked_list.h
	$(CC) $(CFLAGS) -o $@ $<

logger.o: logger.c logger.h
	$(CC) $(CFLAGS) -o $@ $<

tar:
	tar -zcv -f $(TAR_FILE) {m,M}akefile .
