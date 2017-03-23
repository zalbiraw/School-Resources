#include "bst.h"

void insert(bst_node_t *parent, int value, int frequency) {
	
	bst_node_t *left = parent->left, *right = parent->right;

	if (value < parent->value) {

		if (!left) insert_helper(parent, value, frequency, LEFT);
		else insert(left, value, frequency);

	} else {

		if (!right) insert_helper(parent, value, frequency, RIGHT);
		else insert(right, value, frequency);

	}
}

void insert_helper(bst_node_t *parent, int value, int frequency, short int child) {
	
	bst_node_t *node = (bst_node_t*)malloc(sizeof(bst_node_t));

	node->value = value;
	node->frequency = frequency;
	node->left = node->right = NULL;

	if (child == LEFT) parent->left = node;
	else parent->right = node;

}

insert_helper pop(bst_node_t *parent, bst_node_t *node) {
	
	bst_node_t *left = node->left;

	if (!left) {

		int value = node->value;
		bst_node_t *right = node->right;

		if (right) {

			node->value = right->value;
			node->right = right->right;

			node = right;

		} else if (parent) parent->left = NULL;

		return value;
	}

	return pop(node, left);

}