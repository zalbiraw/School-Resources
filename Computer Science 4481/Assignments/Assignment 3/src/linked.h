#ifndef LINKED_H
#define LINKED_H

#include <stdlib.h>

typedef struct node_t {
	int index;
	struct node_t *next;
} node_t;

typedef struct {
	int len;
	node_t *head, *tail;
} linked_t;

linked_t* init();
void push(linked_t*, int);
void trim(linked_t*);
void trim_until(linked_t*, int);

#endif
