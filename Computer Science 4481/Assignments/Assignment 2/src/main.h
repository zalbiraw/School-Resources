#ifndef MAIN_H
#define MAIN_H

#include <stdlib.h>

#include "lib/libpnm.h"
#include "bst.h"

long int *generate_pixel_frequency(struct PGM_Image*, int*);
struct node *generate_Huffman_nodes(long int*, int, int);

#endif