/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* helper.h 
*
******************************************************************************/

#ifndef HELPER_H
#define HELPER_H

#define FAILURE 1
#define SUCCESS 0

#define FALSE 0
#define TRUE 1

#include <stdlib.h>
#include <stdio.h>

#include "processor.h"
#include "printer.h"
#include "linked_list.h"

#define READ "r"

network_t* initilize_network(char*);
void distribute_keys(linked_list_t*, linked_list_t*, int);
void build_finger_tables(linked_list_t*, int);

#endif