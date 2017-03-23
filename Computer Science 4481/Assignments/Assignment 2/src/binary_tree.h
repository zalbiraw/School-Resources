#ifndef BINARY_TREE_H
#define BINARY_TREE_H

#include <stdlib.h>

typedef struct bi_node_t {
	int value;
	bi_node_t *left, *right;
} bi_node_t;

#endif