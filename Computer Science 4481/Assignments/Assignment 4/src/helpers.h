#ifndef HELPERS_H
#define HELPERS_H

#include <stdio.h>

#include "lib/libpnm.h"

#define READ "r"
#define WRITE "w"

void load_image(struct PGM_Image*, char*);
FILE* open_file(char*, const char*);

#endif
