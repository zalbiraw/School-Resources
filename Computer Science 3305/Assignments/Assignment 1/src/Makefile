CC=gcc
CFLAGS=-c
CMATH=-lm

all: clean shell

shell: shell.o process_input.o process_commands.o tokenize.o linked_list.o helper.o
	$(CC) -o $@ $^ $(CMATH)

shell.o: shell.c shell.h
	$(CC) $(CFLAGS) -o $@ $<

process_input.o: process_input.c process_input.h linked_doubly_list.h
	$(CC) $(CFLAGS) -o $@ $< 

process_commands.o: process_commands.c process_commands.h linked_doubly_list.h
	$(CC) $(CFLAGS) -o $@ $<

tokenize.o: tokenize.c tokenize.h
	$(CC) $(CFLAGS) -o $@ $<

linked_list.o: linked_list.c linked_list.h
	$(CC) $(CFLAGS) -o $@ $<

helper.o: helper.c helper.h 
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f *.o shell