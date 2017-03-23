/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* tokenize.h
*
******************************************************************************/


#ifndef TOKENIZE_H
#define TOKENIZE_H

#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <syslog.h>

#include "linked_list.h"
#include "helper.h"

#define TRUE 1
#define FALSE 0

char*** tokenize(char*, int);

#endif