/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains the vector and vertex definitions and operations.
*/

#ifndef VECTOR_H
#define VECTOR_H

#include <math.h>

typedef struct {
    float x, y, z;
} vertex_t;

typedef struct {
    float x, y, z;
} vector_t;

void multiply_constant_vector(void*, float, void*);
void add_vectors(void*, void*, void*);
void sub_vectors(void*, void*, void*);
void cross_vectors(void*, void*, void*);
void normalize_vector(void*);
void clone_vector(void*, void*);
float dot_vectors(void*, void*);

#endif