#ifndef ASAP_H
#define ASAP_H

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <limits.h>
#include <cilk/cilk.h>

#define INF INT_MAX

int** asap (int**, int, int);
int** min_plus(int**, int**, int);
int min(int, int);

#endif