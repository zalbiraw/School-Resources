/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains world definition and operations.
*/

#ifndef WORLD_H
#define WORLD_H

#include "world_objects.h"

#define EPSILON 0.00001

typedef struct {
    vertex_t *dimensions;
    float ambient;
    color_t *background;
    linked_t *lights, *objects;
} world_t;

world_t* init_world(float, float, float, float, int, int, int);
float intersect(vertex_t*, vector_t*, object_t*);
float intersect_triangle(vertex_t*, vector_t*, object_t*);
float intersect_sphere(vertex_t*, vector_t*, object_t*);
void get_normal(vector_t*, object_t*, vertex_t*);
void get_normal_triangle(vector_t*, object_t*);
void get_normal_sphere(vector_t*, object_t*, vertex_t*);
void find_reflected_ray(vector_t*, vector_t*, vector_t*);
void find_interesction_point(vertex_t*, vertex_t*, vector_t*, float);
void free_world(world_t*);

#endif