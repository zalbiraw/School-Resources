#include "ASAP.h"

int main (int argc, const char** argv) {
  int n, **A;

  scanf("%d\n", &n);

  A = (int**)malloc(n * sizeof(int*));

  int k;
  for (int i = 0; i < n; ++i) {

    A[i] = (int*)malloc(n * sizeof(int));
    for (int j = 0; j < n; ++j) {
      scanf("%d ", &k);
      A[i][j] = (k == -1 ? INF : k);
    }
  }  

  A = asap(A, n, n);

  for (int i = 0; i < n; ++i) {

    for (int j = 0; j < n; ++j) {
      k = A[i][j];

      if (k == INF || k == -INF) {
        printf("inf\t");
      } else {
        printf("%d\t", k);
      }

    }

    printf("\n");
  }

  return EXIT_SUCCESS;
}

int** asap (int **A, int n, int level) {

  if (level == 1)
    return A;

  int **A1, **A2;

  A1 = cilk_spawn asap(A, n, ceil(level / 2));
  A2 = asap(A, n, level / 2);

  cilk_sync;

  return min_plus(A1, A2, n);

}

int** min_plus(int **A1, int **A2, int n) {

  int plus,
      **A = (int**)malloc(n * sizeof(int*));

  for (int i = 0; i < n; ++i) {

    A[i] = (int*)malloc(n * sizeof(int));
    for (int j = 0; j < n; ++j) {

      A[i][j] = INF;
      cilk_for (int k = 0; k < n; ++k) {
        plus = (A1[i][k] == INF || A2[k][j] == INF ? INF : A1[i][k] + A2[k][j]);
        A[i][j] = min(A[i][j], plus);
      }

    }

  }

  return A;

}

int min(int a, int b) {
  return (a < b ? a : b);
} 