#include "main.h"

int main() {
	int width = 10, height = 10;
	unsigned char **image = (unsigned char**)malloc(height * sizeof(unsigned char*));

	for (int i = 0; i < height; ++i) {
		image[i] = (unsigned char*)malloc(width * sizeof(unsigned char));
		for (int j = 0; j < width; ++j)
			image[i][j] = (j % 2 == 0 ? j : 0);
	}

	struct PGM_Image pgm = {
		.width = width,
		.height = height,
		.maxGrayValue = 9,
		.image = image
	};

	int non_zeros;
	long int *frequencies = generate_pixel_frequency(&pgm, &non_zeros);

	generate_Huffman_nodes(frequencies, 9, non_zeros);

	// printf("%d\n", non_zeros);
	// for (int i = 0; i <= 9; ++i)
	// 	printf("%ld\n", frequencies[i]);

	return 0;
}

long int* generate_pixel_frequency(struct PGM_Image *pgm, int *non_zeros) {
	int max = pgm->maxGrayValue, i;
	long int *frequencies = (long int*)calloc(max + 1, sizeof(long int));

	unsigned char **image = pgm->image;
	for (i = 0; i < pgm->width; ++i)
		for (int j = 0; j < pgm->height; ++j)
			frequencies[image[i][j]]++;

	for (*non_zeros = 0, i = 0; i <= max; ++i)
		if (frequencies[i]) ++*non_zeros;

	return frequencies;
}

struct node* generate_Huffman_nodes(long int *frequencies, int max, int non_zeros) {

	int i = 0;
	bst_node_t *root = (bst_node_t*)malloc(sizeof(bst_node_t));

	root->left = root->right = NULL;
	for (; i <= max; ++i)
		if (frequencies[i]) {
			root->value = i;
			root->frequency = frequencies[i];
			break;
		}

	int frequency;
	for (++i; i <= max; ++i) {
		frequency = frequencies[i];
		if (frequency) insert(root, i, frequencies[i]);
	}

	int value = root->value;
	while(value == root->value) {
		i = pop(NULL, root) + pop(NULL, root);
		insert(root, i, frequency);
	}

	return NULL;
}