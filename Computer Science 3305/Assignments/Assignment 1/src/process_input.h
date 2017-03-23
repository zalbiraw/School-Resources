/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* process_input.h
*
******************************************************************************/

#ifndef PROCESS_INPUT_H
#define PROCESS_INPUT_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <stdbool.h>

#include "linked_list.h"
#include "linked_doubly_list.h"
#include "process_commands.h"
#include "tokenize.h"
#include "helper.h"

#define TRUE 1
#define FLASE 0

void process_input(int);
short process_line(char*, d_linked_t*);

#endif