/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* find.h 
*
******************************************************************************/

#ifndef FIND_H
#define FIND_H

#include <stdlib.h>
#include <stdio.h>

#include "network.h"
#include "processor.h"
#include "crash.h"

#define PROCESSOR_NOT_FOUND -1
#define KEY_NOT_FOUND -2

int find(network_t*, int, int, int);
struct node* find_processor(network_t*, int);
int find_key(network_t*, struct node*, short, int, int, int);

#endif