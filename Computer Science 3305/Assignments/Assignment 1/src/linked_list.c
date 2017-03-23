/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* linked_list.c contins some helper functions for the linked_list structs
*
******************************************************************************/

#include "linked_list.h"

struct s_linked* s_init_next(struct s_linked* node)
{
	return node->next = (struct s_linked*)malloc(sizeof(struct s_linked));
}

struct i_linked* i_init_next(struct i_linked* node)
{
	return node->next = (struct i_linked*)malloc(sizeof(struct i_linked));
}