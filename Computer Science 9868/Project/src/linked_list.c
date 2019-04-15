/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* linked_list.c
*
******************************************************************************/

#include "linked_list.h"

linked_list_t* init_linked_list()
{
	linked_list_t *l = (linked_list_t*)malloc(sizeof(linked_list_t));

	l->size = 0;
	l->head = l->tail = NULL;

	return l;
}

void enqueue(linked_list_t *l, void *value)
{
	struct node *node = (struct node*)malloc(sizeof(struct node));

	node->value = value;
	node->prev = node->next = NULL;

	if (l->size == 0)
	{
		l->head = l->tail = node;
	}

	else 
	{
		l->tail->next = node;
		node->prev = l->tail;
		l->tail = node;
	}

	l->size++;
}

void circular_enqueue(linked_list_t *l, void* value)
{
	enqueue(l, value);
	l->tail->next = l->head;
	l->head->prev = l->tail;
}

void insert(linked_list_t *l, struct node *n, void *value)
{
	struct node *node = (struct node*)malloc(sizeof(struct node));

	node->value = value;
	node->prev = n;
	node->next = n->next;

	n->next->prev = node;
	n->next = node;

	if (l->tail == n) l->tail = node;
	l->size++;

}
#include <stdio.h>
void erase(linked_list_t *l,  struct node *n)
{
	if (n == l->tail) l->tail = n->prev;
	if (n == l->head) l->head = n->next;

	if (n->prev != NULL) n->prev->next = n->next;
	if (n->next != NULL) n->next->prev = n->prev;
	
	l->size--;

	free(n);
}
