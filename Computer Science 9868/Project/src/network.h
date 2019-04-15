/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* network.h 
*
******************************************************************************/

#ifndef NETWORK_H
#define NETWORK_H

#include "linked_list.h"

typedef struct
{
	int m;
	linked_list_t *processors, *keys;
} network_t;

#endif