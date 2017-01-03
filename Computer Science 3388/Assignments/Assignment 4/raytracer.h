/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains raytracer objects, definitions and operations.
*/


#ifndef RAYTRACER_H
#define RAYTRACER_H

#include "world.h"

#define TRUE 1
#define FALSE 0

typedef struct {
    float tracer_plane;
    world_t *world;
    vector_t ***rays;
} raytracer_t;

raytracer_t* init_raytracer(
	char*, char*,
	float, float, float,
	float, float,
	float, float, float,
	int, int, int);
void construct_rays(raytracer_t*, vertex_t*);
void calculate_pixel_color(color_t*, raytracer_t*, vertex_t*, vector_t*, int);
void evaluate_shading_model(color_t*, raytracer_t*, vertex_t*, vector_t*, object_t*, float, int);
float evaluate_diffuse(vector_t*, vector_t*);
float evaluate_specular(object_t*, vector_t*, vector_t*, vector_t*);
void log_raytracer(raytracer_t*);
void free_raytracer(raytracer_t*);

#endif