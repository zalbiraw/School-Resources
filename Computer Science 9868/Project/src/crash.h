/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* add.h 
*
******************************************************************************/

#ifndef CRASH_H
#define CRASH_H

#include <stdio.h>
#include <math.h>

#include "network.h"
#include "processor.h"
#include "linked_list.h"
#include "find.h"
#include "memory.h"
#include "helper.h"

int crash(network_t*, int);
void recover();

#endif