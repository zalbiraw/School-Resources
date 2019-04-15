/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* printer.h 
*
******************************************************************************/

#ifndef PRINTER_H
#define PRINTER_H

#include <stdio.h>
#include <math.h>

#include "network.h"
#include "processor.h"
#include "helper.h"

void print_keys(linked_list_t*);
void print_processors(linked_list_t*);
void print_info(network_t*);

#endif