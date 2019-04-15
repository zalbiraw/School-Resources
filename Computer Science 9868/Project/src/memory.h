/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* memory.h 
*
******************************************************************************/

#ifndef MEMORY_H
#define MEMORY_H

#include "network.h"
#include "processor.h"
#include "linked_list.h"

void free_network(network_t*);
void free_fingers(linked_list_t*);

#endif