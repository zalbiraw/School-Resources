/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* add.h 
*
******************************************************************************/

#ifndef ADD_H
#define ADD_H

#include <stdlib.h>

#include "network.h"
#include "processor.h"
#include "linked_list.h"
#include "find.h"
#include "memory.h"
#include "helper.h"

#define PROCESSOR_EXISTS -1
#define PROCESSOR_ID_TOO_LARGE -2

int add(network_t*, int, int);

#endif