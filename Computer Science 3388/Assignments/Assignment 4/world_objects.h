/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains world objects and their readers.
*/

#ifndef WORLD_OBJECTS_H
#define WORLD_OBJECTS_H

#include <stdio.h>
#include <stdlib.h>

#include "vector.h"
#include "linked_list.h"

typedef struct {
    int r, g, b;
} color_t;

typedef struct {
    vertex_t position;
    color_t color;
    float intensity;
} light_t;

typedef struct {
    vector_t normal;
    vertex_t points[3];
} triangle_t;

typedef struct {
    float r;
    vertex_t center;
    short int direction;
} sphere_t;

typedef struct {
    int id, fallout;
    char type;
    union {
        triangle_t *triangle;
        sphere_t *sphere;
    };
    color_t color;
    float ambient, diffuse, specular, reflectivity;
} object_t;

FILE* open_file(char*);
void load_lights(char*, linked_t*);
void load_objects(char*, linked_t*);
void read_triangle_object(FILE*, object_t*);
void read_sphere_object(FILE*, object_t*);

#endif