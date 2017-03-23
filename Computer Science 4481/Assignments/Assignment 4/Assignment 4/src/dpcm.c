#include "dpcm.h"

void dpcm(enum RULE rule, predictor_t *predictor) {

  int width = predictor->width,
      height = predictor->height,
      **result = predictor->result;

  // encode the first pixel
  result[0][0] = 128 - predictor->pixels[0][0];

  // encode the rest of pixels at the first row with W prediction
  // and the pixels at the second row with N prediction.
  for (int i = 1; i < width; ++i)
    result[0][i] = prediction_error(W, predictor, 0, i);

  for (int i = 0; i < width; ++i)
    result[1][i] = prediction_error(N, predictor, 1, i);

  // encode the rest of pixels at the first two and last columns  with N prediction.
  for (int i = 2, j = width - 1; i < height; ++i) {

    result[i][0] = prediction_error(N, predictor, i, 0);
    result[i][1] = prediction_error(N, predictor, i, 1);
    result[i][j] = prediction_error(N, predictor, i, j);
  
  }

  // encode the rest of the pixels.
  for (int i = 2; i < height; ++i)
    for (int j = 2; j < width - 1; ++j)
      result[i][j] = prediction_error(rule, predictor, i, j);

}

int prediction_error(enum RULE rule, predictor_t *predictor, int i, int j) {
  
  int height = predictor->height,
      width = predictor->width,
      **pixels = predictor->pixels;

  switch(rule) {

    case W:
      return pixels[i][j - 1] - pixels[i][j];

    case N:
      return pixels[i - 1][j] - pixels[i][j];

    case NW:
      return pixels[i][j - 1] / 2 + pixels[i - 1][j] / 2 - pixels[i][j];

    case CALIC:
      return calic(predictor, i, j) - pixels[i][j];

    default:
      printf("Unhandled prediction error case.\n");
      exit(EXIT_FAILURE);
  }

}

int calic(predictor_t *predictor, int i, int j) {

  int **pixels = predictor->pixels,

      W   = pixels[i][j - 1],
      N   = pixels[i - 1][j],
      WW  = pixels[i][j - 2],
      NW  = pixels[i - 1][j - 1],
      NN  = pixels[i - 2][j],
      NE  = pixels[i - 1][j + 1],
      NNE = pixels[i - 2][j + 1],

      dh = abs(W - WW) + abs(N - NW) + abs(NE - N),
      dv = abs(W - NW) + abs(N - NN) + abs(NE - NNE),
      dh_dv, dv_dh, prediction;

  // run through the CALIC conditions.

  // sharp horizontal edge.
  if ((dv_dh = dv - dh) > 80) return W;
  else {

    // sharp vertical edge.
    if ((dh_dv = dh - dv) > 80) return N;
    else {

      prediction = (W + N) / 2 + (NE - NW) / 4;

      // horizontal edge.
      if (dv_dh > 32) return prediction / 2 + W / 2;

      // vertical edge.
      else if (dh_dv > 32) return prediction / 2 + N / 2;

      // weak horizontal edge.
      else if (dv_dh > 8) return 3 * prediction / 4 + W / 4;

      // weak vertical edge.
      else if (dh_dv > 8) return 3 * prediction / 4 + N / 4;

      return prediction;

    }

  }

}
