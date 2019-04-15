/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* processor.h 
*
******************************************************************************/

#ifndef PROCESSOR_H
#define PROCESSOR_H

#include "linked_list.h"

typedef struct
{
	short id;
	int n, active;
	struct node *keys;
	linked_list_t *fingers;
} processor_t;

#endif