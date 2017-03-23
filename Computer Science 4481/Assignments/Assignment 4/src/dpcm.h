#ifndef DPCM_H
#define DPCM_H

#include "helpers.h"

typedef struct {

	int height, width;
	unsigned char **image, **result;

} predictor_t;

enum RULE {I, W = 1, N = 2, NW = 3, CALIC = 4};

void dpcm(enum RULE, predictor_t*);
unsigned char prediction_error(enum RULE, predictor_t*, int, int);
unsigned char calic(predictor_t*, int, int);

#endif
