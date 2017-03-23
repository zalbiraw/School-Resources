#include "pascal.h"

int main (int argc, const char** argv) {

  int n = atoi(argv[1]) + 1,
      k = atoi(argv[2]);

  int **A = (int**)malloc(n * sizeof(int*));

  A[0] = (int*)calloc(n, sizeof(int));
  A[0][0] = 1;

  for (int i = 1; i < n; i++) {
    A[i] = (int*)calloc(n, sizeof(int));

    A[0][i] = 1;
    A[i][0] = 1;
  }

  solve_triangle_tableau(A, k, n - 1, 1, 1, n, n);

  return EXIT_SUCCESS;
}

void solve_triangle_tableau(int **A, int k, int w, int x1, int y1, int x2, int y2) {

  if (w == 1) {

    A[x1][y1] = A[x1 - 1][y1] + A[x1][y1 - 1];

  } else {

    int x, y, 
        slice = w / k;

    for (int i = 0; i < k - 1; ++i) {

      x = x1 + i * slice;

      for (int j = 0; j <= i; ++j) {

        y = y1 + j * slice;
        solve_square_tableau(A, k, slice, x, y, x + slice, y + slice);
        x -= slice;

      }
    
    }

    x = x1 + (k - 1) * slice;

    for (int j = 0; j <= k - 1; ++j) {

      y = y1 + j * slice;
      solve_triangle_tableau(A, k, slice, x, y, x + slice, y + slice);
      x -= slice;

    }

  }

}

void solve_square_tableau(int **A, int k, int w, int x1, int y1, int x2, int y2) {

  if (w == 1) {

    A[x1][y1] = A[x1 - 1][y1] + A[x1][y1 - 1];

  } else {

    int x, y, 
        slice = w / k;

    for (int i = 0; i < k; ++i) {

      x = x1 + i * slice;

      for (int j = 0; j <= i; ++j) {

        y = y1 + j * slice;
        solve_square_tableau(A, k, slice, x, y, x + slice, y + slice);
        x -= slice;

      }
    
    }

    for (int i = 0; i < k; ++i) {

      x = x1 + w - slice;
      y = y1 + (i + 1) * slice;

      for (int j = 0; j < k - i - 1; ++j) {

        solve_square_tableau(A, k, slice, x, y, x + slice, y + slice);
        x -= slice;
        y += slice;

      }

    }

  }
}