#ifndef PPM_H
#define PPM_H

#include <stdio.h>
#include <stdlib.h>

#define RED 1
#define GREEN 2
#define BLUE 3

#define RECT_1 10
#define RED_1 11
#define GREEN_1 12
#define BLUE_1 13

#define RECT_2 20
#define RED_2 21
#define GREEN_2 22
#define BLUE_2 23

#define RECT_3 30
#define RED_3 31
#define GREEN_3 32
#define BLUE_3 33

#define RECT_4 40
#define RED_4 41
#define GREEN_4 42
#define BLUE_4 43

#define RECT_5 50
#define RED_5 51
#define GREEN_5 52
#define BLUE_5 53

char** ppm_rect(int, int);
void draw_rect(char**, int, int, int, int, int);
int get_color(int, int, int);
void ppm_ascii(FILE*, char**, int, int);
void ppm_raw(FILE*, char**, int, int);

#endif