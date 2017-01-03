/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Executes the ray tracer.
*/

#ifndef MAIN_H
#define MAIN_H

#include <pthread.h>
#include <semaphore.h>

#include "raytracer.h"
#include "logger.h"

#define WINDOW_NAME "Balls"
#define WINDOW_WIDTH 640.0
#define WINDOW_HEIGHT 640.0

//Orhto values
#define LEFT 0.0
#define RIGHT WINDOW_WIDTH
#define BOTTOM 0.0
#define TOP WINDOW_HEIGHT
#define NEAR -1.0
#define FAR 1.0

#define OBJECTS_FILENAME "objects.txt"
#define LIGHTS_FILENAME "lights.txt"

#define WORLD_WIDTH WINDOW_WIDTH
#define WORLD_HEIGHT WINDOW_HEIGHT
#define WORLD_DEPTH 640.0
#define TRACER_PLANE_Z 0.0

#define EYE_X WORLD_WIDTH/2
#define EYE_Y WORLD_HEIGHT/2
#define EYE_Z -5000

#define BACKGROUND_R 0
#define BACKGROUND_B 0
#define BACKGROUND_G 0

#define AMBIENT_INTENSITY 0.8

#define DELAY 10

#define THREADS 32

#define REFLECTIVITY_DEPTH 2

void init();
void initWindow();
void reshape (GLsizei, GLsizei);
void display();
void animate();
void keyboard(unsigned char, int, int);
void *work();

#endif