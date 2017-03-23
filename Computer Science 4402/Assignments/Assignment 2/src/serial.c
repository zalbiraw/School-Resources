#include "serial.h"

int main(int argc, const char **argv) {

	if (argc != 2) {
		printf("Please provide an array size, size = 2^n. Provide n as an argument to the program.\n");
		exit(EXIT_FAILURE);
	}

	int n = pow(2, atoi(argv[1])),
		A[n],
		B[MAX_VALUE] = {0},
		C[n];

	// initialize srand for randomizing values based on time.
	time_t time;
	srand((time)&time);

	// dump random values in array A.
	for (int i = 0; i < n; ++i)
		A[i] = rand() % MAX_VALUE;

	// call the sort function.
	sort(A, B, C, n);

	// print unsorted and sorted arrays.
	print_array("Original", A, n);
	print_array("Sorted  ", C, n);

	return EXIT_SUCCESS;

}

void sort(int *A, int *B, int *C, int n) {

	// count values.
	for (int i = 0; i < n; ++i)
		++B[A[i]];

	// fill array C will the final result.
	for (int i = 0, j = 0; i < MAX_VALUE; ++i)
		for (int k = 0; k < B[i]; ++k, ++j)
			C[j] = i;
}

void print_array(const char *name, int *array, int size) {

	printf("%s = [%d", name, array[0]);
	for (int i = 1; i < size; ++i) printf(", %d", array[i]);
	printf("]\n");

}
