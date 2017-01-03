/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains the logging and debugging functions for the program.
*/

#ifndef LOGGER_H
#define LOGGER_H

#ifdef __APPLE__
  #include <GLUT/glut.h>
#else 
  #include <GL/glut.h>
#endif

#include "raytracer.h"
void draw_light(raytracer_t*);
void log_raytracer(raytracer_t*);

#endif