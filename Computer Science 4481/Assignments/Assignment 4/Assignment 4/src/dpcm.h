#ifndef DPCM_H
#define DPCM_H

#include "helpers.h"

typedef struct {

	int height,
		width,
		**pixels,
		**result;

} predictor_t;

enum RULE {W = 1, N = 2, NW = 3, CALIC = 4};

void dpcm(enum RULE, predictor_t*);
int prediction_error(enum RULE, predictor_t*, int, int);
int calic(predictor_t*, int, int);

#endif
