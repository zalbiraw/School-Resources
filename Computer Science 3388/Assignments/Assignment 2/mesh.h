/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
*
* mesh.h contains all type defentions for the mesh object.
*/

#ifndef MESH_H
#define MESH_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct {
    float x, y, z;
} vertex_t;

typedef struct {
	vertex_t** points;
	vertex_t* normal;
} polygon_t;

typedef struct {
	int point_count;
	int polygon_count;
	vertex_t** points;
	polygon_t** polygons;
} mesh_t;

typedef struct node_t {
    struct node_t* next;
    vertex_t* vertex;
} node_t;

//The number of times the intitial profile points are doubled.
#define DOUBLE_POINTS 4

node_t* getProfile(char*, int*); 
mesh_t* getMesh(char*, int);
void triangulate(mesh_t*, int, int);
void doublePoints(node_t*, int*);
vertex_t* calculateNormal(vertex_t*, vertex_t*, vertex_t*);
void freeMesh(mesh_t*);

#endif