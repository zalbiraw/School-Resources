/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* simulator.h 
*
******************************************************************************/

#ifndef SIMULATOR_H
#define SIMULATOR_H

#include <string.h>
#include <stdio.h>
#include <math.h>

#include "network.h"
#include "find.h"
#include "add.h"
#include "end.h"
#include "crash.h"
#include "printer.h"
#include "memory.h"
#include "helper.h"

#define INPUT "input"
#define CMD_LEN 6

#define FIND 1
#define ADD 2
#define END 3
#define CRASH 4
#define PRINT 5
#define EXIT 6

void simulate_find(network_t*, int);
void simulate_add(network_t*, int);
void simulate_end(network_t*, int);
void simulate_crash(network_t*);

#endif