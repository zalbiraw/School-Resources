#ifndef VALIDATOR_H
#define VALIDATOR_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARG_NUM 6

#define TYPE_CODE 1
#define WIDTH 2
#define HEIGHT 3
#define OUTPUT 4
#define FORMAT 5

#define PBM '1'
#define PGM '2'
#define PPM '3'

#define PBM_PGM_WIDTH_DIVSOR 4
#define PPM_WIDTH_DIVSOR 6
#define HEIGHT_DIVSOR 4

#define ASCII '0'
#define RAW '1'

void validator(int, char const**, 
	char*, int*, int*, const char**, char*);
void validate_dimensions(char const*, int, int);

#endif