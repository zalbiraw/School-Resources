/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* linked_list.h
*
******************************************************************************/

#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include <stdlib.h>

struct node
{
	void *value;
	struct node *prev, *next;
};

typedef struct
{
	struct node *head, *tail;
	int size;
} linked_list_t;

linked_list_t* init_linked_list();
void enqueue(linked_list_t*, void*);
void circular_enqueue(linked_list_t*, void*);
void insert(linked_list_t*, struct node*, void*);
void erase(linked_list_t*,  struct node*);

#endif