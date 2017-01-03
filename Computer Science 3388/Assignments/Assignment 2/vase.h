/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
*
* Header file for vase.c, contains constants and structure definitions.
*/

#ifndef RECTANGLES_H
#define RECTANGLES_H

#ifdef __APPLE__
  #include <GLUT/glut.h>
#else 
  #include <GL/glut.h>
#endif

#include "mesh.h"

#define PROFILE_TXT "vase.txt"

#define WINDOW_NAME "vase"
#define WINDOW_WIDTH 640
#define WINDOW_HEIGHT 640

#define THETA 1

//Color values
#define AMBIENT {0.2f, 0.2f, 0.2f, 1.0f}
#define DIFFUSE {0.8f, 0.8f, 0.8f, 1.0f}
#define SPECULAR {0.5f, 0.5f, 0.5f, 1.0f}

//Sets the ortho.
#define SCREEN_SCALE 60

//Orhto values
#define LEFT -(SCREEN_SCALE / 2)
#define RIGHT SCREEN_SCALE / 2
#define BOTTOM -(SCREEN_SCALE / 6)
#define TOP SCREEN_SCALE * 5 / 6
#define NEAR -(SCREEN_SCALE / 2)
#define FAR SCREEN_SCALE / 2

//Eye value for lookAt
#define EYE_X 0.0
#define EYE_Y 0.0
#define EYE_Z 0.0

//Reference value for lookAt
#define REFERENCE_X -1.0
#define REFERENCE_Y -1.0
#define REFERENCE_Z -0.4

//Up value for lookAt
#define UP_X 0.0
#define UP_Y 0.0
#define UP_Z 1.0

//Light ponsition
#define POSITION_X 30.0
#define POSITION_Y -30.0
#define POSITION_Z 40.0

//Rotation speed
#define ROTATION_RATE 10

#define DELAY 100

//Color value for the Vase
#define POLYGON_RED 0.8
#define POLYGON_BLUE 0.4
#define POLYGON_GREEN 0.2

void init();
void initWindow();
void initLight();
void reshape (GLsizei, GLsizei);
void display();
void animate();
void drawAxis();
void drawTriangles();
vertex_t* calculateNormal(vertex_t*, vertex_t*, vertex_t*);
void keyboard(unsigned char, int, int);

#endif