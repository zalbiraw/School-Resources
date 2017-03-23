#ifndef BST_H
#define BST_H

#include <stdlib.h>

#define LEFT 0
#define RIGHT 1

typedef struct bst_node_t {
	int value;
	struct bst_node_t *left, *right;
} bst_node_t;

void insert(bst_node_t*, int);
void insert_helper(bst_node_t*, int, short int);
int pop(bst_node_t*, bst_node_t*);

#endif