#ifndef PGM_H
#define PGM_H

#include <stdio.h>
#include <stdlib.h>

char** pgm_rect(int, int);
void draw_row(char**, char, int, int, int);
void draw_col(char**, char, int, int, int);
void pgm_ascii(FILE*, char**, int, int);
void pgm_raw(FILE*, char**, int, int);

#endif