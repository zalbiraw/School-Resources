#ifndef ENCODE_H
#define ENCODE_H

#include <stdio.h>
#include <string.h>

#include "linked.h"
#include "lib/libpnm.h"

#define ARGC 4

void Encode_Using_LZ77(const char*, unsigned int, const char*);

#endif
