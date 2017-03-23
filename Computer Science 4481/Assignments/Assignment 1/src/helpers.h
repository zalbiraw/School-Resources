#ifndef HELPERS_H
#define HELPERS_H

#include "validator.h"

#define EXT_LEN 4

FILE* open_file(char, char const*);
void write_headers(FILE*, char, int, int, char);

#endif