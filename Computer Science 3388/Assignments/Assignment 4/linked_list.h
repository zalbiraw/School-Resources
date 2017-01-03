/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains linked list definition and operations.
*/

#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include <stdlib.h>

typedef struct node {
    void *element;
    struct node *next;
} node_t;

typedef struct {
    node_t *head, *tail;
} linked_t;

void add(linked_t*, void*);
void* pop(linked_t*);

#endif