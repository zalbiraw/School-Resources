/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
*
* Header file for rectangles.c, contains constants and structure definitions.
*/

#ifndef RECTANGLES_H
#define RECTANGLES_H

#ifdef __APPLE__
  #include <GLUT/glut.h>
#else 
  #include <GL/glut.h>
#endif

#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

//window name
#define WINDOW_NAME "Rectangles!"

//window size
#define WINDOW_X 640.0f
#define WINDOW_Y 640.0f

//number of rectangles
#define RECT_NUMBER 15

//the min and max values for the width and length of a rectangle
#define RECT_MIN 1
#define RECT_MAX 100

//the min and max values for the direction of a rectangle in the x and y
#define DIR_MIN -5
#define DIR_MAX 5

//the min and max values for the rotation angle
#define ANGLE_MIN -10
#define ANGLE_MAX 10

//the color and rotation ranges
#define COLOR_RANGE 255
#define ROTATION_DEGREES 360

//delay in msecs
#define DELAY 10

//color structure
typedef struct {
    float r;
    float b;
    float g;
} rbg_t;

//vertex structure
typedef struct {
    float x;
    float y;
} vertex_t;

//rectangle structure
typedef struct {
    rbg_t color;
    float width;
    float length;
    float orientation;
    float angle;
    vertex_t position;
    vertex_t direction;
    vertex_t scale;
} rect_t;

void init();
void display();
void keyboard(unsigned char, int, int);
void generateRectangles();
void drawRectangle(rect_t);
void update(int);
float getRand(float, float);
float max(float, float);
float min(float, float);

#endif