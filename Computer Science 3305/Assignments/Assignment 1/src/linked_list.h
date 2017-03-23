/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* linked_list.h cotains the defenitions for the s_linked and i_linked structs
*
******************************************************************************/

#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include "stdlib.h"

struct s_linked
{
   	char* string;
   	struct s_linked* next;
};

struct i_linked
{
   	int value;
   	struct i_linked* next;
};

struct s_linked* s_init_next(struct s_linked*);
struct i_linked* i_init_next(struct i_linked*);

#endif