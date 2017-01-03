/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains the vector and vertex definitions and operations.
*/

#include "vector.h"

/*
* Multiples a vector/vertex with a constant.
*
* void*     i   the vector/vertex that will be assigned the result.
* float     c   the constant that the vector/vertex will be multiplied by.
* void*     j   the vector/vertex will be multiplied by the constant.
*/
void multiply_constant_vector(void* i, float c, void* j) {
    vector_t    *u = i,
                *v = j;
    u->x = v->x * c;
    u->y = v->y * c;
    u->z = v->z * c;
}

/*
* Adds two vectors/vertices.
*
* void*     i   the vector/vertex that will be assigned the result.
* void*     j   the first vector/vertex in the addition operation.
* void*     k   the second vector/vertex in the addition operation.
*/
void add_vectors(void *i, void *j, void *k) {
    vector_t    *u = i,
                *v = j,
                *w = k;
    u->x = v->x + w->x;
    u->y = v->y + w->y;
    u->z = v->z + w->z;
}

/*
* Subtracts two vectors/vertices.
*
* void*     i   the vector/vertex that will be assigned the result.
* void*     j   the first vector/vertex in the subtraction operation.
* void*     k   the second vector/vertex in the subtraction operation.
*/
void sub_vectors(void *i, void *j, void *k) {
    vector_t    *u = i,
                *v = j,
                *w = k;
    u->x = v->x - w->x;
    u->y = v->y - w->y;
    u->z = v->z - w->z;
}

/*
* Crosses two vectors/vertices.
*
* void*     i   the vector/vertex that will be assigned the result.
* void*     j   the first vector/vertex in the cross operation.
* void*     k   the second vector/vertex in the cross operation.
*/
void cross_vectors(void *i, void *j, void *k) {
    vector_t    *u = i,
                *v = j,
                *w = k;
    u->x = v->y * w->z - v->z * w->y;
    u->y = v->z * w->x - v->x * w->z;
    u->z = v->x * w->y - v->y * w->x;
}

/*
* Normalizes a vector/vertex.
*
* void*     i   the vector/vertex that will be normalized.
*/
void normalize_vector(void *i) {
    vector_t    *u = i;
    float d = sqrt(pow(u->x, 2) + pow(u->y, 2) + pow(u->z, 2));

    u->x /= d;
    u->y /= d;
    u->z /= d;
}

/*
* Clones a vector/vertex.
*
* void*     i   the vector/vertex that will be contain the cloned value.
* void*     j   the vector/vertex that will be cloned.
*/
void clone_vector(void *i, void *j) {
    vector_t    *u = i,
                *v = j;
    u->x = v->x;
    u->y = v->y;
    u->z = v->z;
}

/*
* Dots two vectors/vertices.
*
* void*     i   the first vector/vertex in the dot operation.
* void*     j   the second vector/vertex in the dot operation.
*
* returns a float containing the result of the operation.
*/
float dot_vectors(void *i, void *j) {
    vector_t    *u = i,
                *v = j;
    return u->x * v->x + u->y * v->y + u->z * v->z;
}
