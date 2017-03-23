#ifndef PBM_H
#define PBM_H

#include <stdio.h>
#include <stdlib.h>

char** pbm_rect(int, int);
void draw_line(char**, int, int, int, int);
void pbm_ascii(FILE*, char**, int, int);
void pbm_raw(FILE*, char**, int, int);

#endif