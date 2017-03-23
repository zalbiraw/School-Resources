/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* linked_doubly_list.h hold the definition of the d_node struct and d_linked_t
* typedef
*
******************************************************************************/

#ifndef LINKED_DOUBLY_LIST_H
#define LINKED_DOUBLY_LIST_H

struct d_node
{
	struct d_node* prev;
   	char* string;
   	struct d_node* next;
};

typedef struct d_linked_t
{
	struct d_node* d_head;
	struct d_node* d_tail;
	int len;
} d_linked_t;

#endif