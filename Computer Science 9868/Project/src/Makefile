CC=gcc
CFLAGS=-c
CMATH=-lm

all: clean simulator 

simulator: simulator.o find.o add.o end.o crash.o printer.o memory.o linked_list.o helper.o
	$(CC) -o $@ $^ $(CMATH) $(PFLAG)

simulator.o: simulator.c simulator.h
	$(CC) $(CFLAGS) -o $@ $<

find.o: find.c find.h
	$(CC) $(CFLAGS) -o $@ $<

add.o: add.c add.h
	$(CC) $(CFLAGS) -o $@ $<

end.o: end.c end.h
	$(CC) $(CFLAGS) -o $@ $<

crash.o: crash.c crash.h
	$(CC) $(CFLAGS) -o $@ $<

printer.o: printer.c printer.h
	$(CC) $(CFLAGS) -o $@ $<

memory.o: memory.c memory.h
	$(CC) $(CFLAGS) -o $@ $<

linked_list.o: linked_list.c linked_list.h
	$(CC) $(CFLAGS) -o $@ $<

helper.o: helper.c helper.h
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f *.o simulator