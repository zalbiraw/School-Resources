/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains world definition and operations.
*/

#include "world.h"

/*
* Initializes the world object.
*
* float ambient     the world ambient value.
* float w           the world width value.
* float h           the world height value.
* float d           the world depth value.
* int   r           the world background color r value.
* int   g           the world background color g value.
* int   b           the world background color b value.
*
* returns a pointer to the world object.
*/
world_t* init_world(
    float ambient,
    float w, float h, float d,
    int r, int g, int b) {
    vertex_t    *dimensions = (vertex_t*)malloc(sizeof(vertex_t));
    color_t     *background = (color_t*)malloc(sizeof(color_t));
    linked_t    *lights     = (linked_t*)malloc(sizeof(linked_t)),
                *objects    = (linked_t*)malloc(sizeof(linked_t));
    world_t     *world      = (world_t*)malloc(sizeof(world_t));

    dimensions->x = w;
    dimensions->y = h;
    dimensions->z = d;

    background->r = r;
    background->g = g;
    background->b = b;

    //initializes lights and objects linked lists.
    lights->head = lights->tail = objects->head = objects->tail = NULL;

    world->dimensions   = dimensions;
    world->ambient      = ambient;
    world->background   = background;
    world->lights       = lights;
    world->objects      = objects;
    return world;
}

/*
* Calculates the intersection with an object.
*
* vertex_t*     origin      a pointer to the ray origin vertex.
* vector_t*     direction   a pointer to the ray direction vector.
* object_t*     object_t    a pointer to the object that is being tested for
*                           for intersection.
*
* returns the distance between the origin and intersection point if an
* intersection occurs, Nan if there is no intersection
*/
float intersect(vertex_t *origin, vector_t *direction, object_t *object) {
    switch(object->type) {
        case 'T':
            return intersect_triangle(origin, direction, object);
        case 'S':
            return intersect_sphere(origin, direction, object);
    }
    return NAN;
}

/*
* Calculates the intersection with a triangle object.
*
* vertex_t*     origin      a pointer to the ray origin vertex.
* vector_t*     direction   a pointer to the ray direction vector.
* object_t*     object_t    a pointer to the object that is being tested for
*                           for intersection.
*
* returns the distance between the origin and intersection point if an
* intersection occurs, Nan if there is no intersection
*/
float intersect_triangle(vertex_t *origin, vector_t *direction, object_t *object) {
    triangle_t  *triangle = object->triangle;
    vector_t    normal = triangle->normal,
                u, v, w;
    vertex_t    *points = triangle->points,
                *p0 = &points[0],
                intersection, temp;
    float d, numerator, denominator, uu, uv, uw, vv, vw, s, t;

    //denominator = n . direction
    denominator = dot_vectors(&normal, direction);

    if (fabs(denominator) < EPSILON) {
        return NAN;
    }

    //numerator = n . (p0 - origin)
    sub_vectors(&temp, p0, origin);
    numerator = dot_vectors(&normal, &temp);

    d = numerator / denominator;

    if (d < 0) {
        return NAN;
    }

    find_interesction_point(&intersection, origin, direction, d);
    sub_vectors(&u, &points[1], p0);
    sub_vectors(&v, &points[2], p0);
    sub_vectors(&w, &intersection, p0);

    uu = dot_vectors(&u, &u);
    uv = dot_vectors(&u, &v);
    uw = dot_vectors(&u, &w);
    vv = dot_vectors(&v, &v);
    vw = dot_vectors(&v, &w);

    denominator = uv * uv - uu * vv;

    s = (uv * vw - vv * uw) / denominator;
    if (s < 0.0 || s > 1.0) {
        return NAN;
    }

    t = (uv * uw - uu * vw) / denominator;
    if (t < 0.0 || s + t > 1.0) {
        return NAN;
    }

    return d;
}

/*
* Calculates the intersection with a sphere object.
*
* vertex_t*     origin      a pointer to the ray origin vertex.
* vector_t*     direction   a pointer to the ray direction vector.
* object_t*     object_t    a pointer to the object that is being tested for
*                           for intersection.
*
* returns the distance between the origin and intersection point if an
* intersection occurs, Nan if there is no intersection
*/
float intersect_sphere(vertex_t *origin, vector_t *direction,
    object_t *object) {
    sphere_t *sphere = object->sphere;
    vertex_t *center = &sphere->center, temp;
    float b, c, d, sqrtd, radius = sphere->r;

    //temp = ray origin - center
    sub_vectors(&temp, origin, center);

    //b = 2 * ray direction . (ray origin - sphere center)
    b = 2 * dot_vectors(direction, &temp);

    //c = (ray origin - sphere center) . (ray origin - sphere center)
    // - radius^2
    c = dot_vectors(&temp, &temp) - pow(radius, 2);

    //d = b^2 - 4 * a * c, a = 1
    d = pow(b, 2) - 4 * c;

    if (d < 0) {
        return NAN;
    } else if (d == 0) {
        return -b / 2;
    } else {
        sqrtd = sqrt(d);
        return fmin(
            (-b + sqrtd) / 2,
            (-b - sqrtd) / 2
        );
    }
}

/*
* Calculates the normal of the object.
*
* vector_t*     normal          a pointer to the vector that will be assigned
*                               the value of the normal.
* object_t      object          a pointer to the object.
* vertex_t      intersection    a pointer to vertex of the intersection.
*/
void get_normal(vector_t *normal, object_t *object, vertex_t *intersection) {
    switch(object->type) {
        case 'T':
            get_normal_triangle(normal, object);
            break;
        case 'S':
            get_normal_sphere(normal, object, intersection);
            break;
    }
}

/*
* Calculates the normal of a sphere object.
*
* vector_t*     normal          a pointer to the vector that will be assigned
*                               the value of the normal.
* object_t      object          a pointer to the object.
* vertex_t      intersection    a pointer to vertex of the intersection.
*/
void get_normal_sphere(vector_t *normal, object_t *object,
    vertex_t *intersection) {
    clone_vector(normal, intersection);
    sub_vectors(normal, normal, &object->sphere->center);
    normalize_vector(normal);
}

/*
* Calculates the normal of a triangle object.
*
* vector_t*     normal          a pointer to the vector that will be assigned
*                               the value of the normal.
* object_t      object          a pointer to the object.
*/
void get_normal_triangle(vector_t *normal, object_t *object) {
    clone_vector(normal, &object->triangle->normal);
}

/*
* Calculates the reflected ray.
*
* vector_t* reflected   a pointer to the vector that will be assigned
*                               the value of the reflected ray.
* vector_t* ray         a pointer to the ray direction vector.
* vector_t* normal      a pointer to the normal vector.
*/
void find_reflected_ray(vector_t *reflected, vector_t *ray, vector_t *normal) {
    normalize_vector(normal);
    float c = 2 * dot_vectors(ray, normal);

    multiply_constant_vector(reflected, c, normal);
    sub_vectors(reflected, reflected, ray);
    normalize_vector(reflected);
}

/*
* Calculates the intersection point with an object.
*
* vertex_t*     i           a pointer to the vertex that will be assigned the
*                           value of the intersection.
* vertex_t*     o           a pointer to the ray origin vertex.
* vector_t*     d           a pointer to the ray direction vector.
* float         distance    the distance between the ray origin and the
*                           intersection point.
*
* returns the intersection point.
*/
void find_interesction_point(vertex_t *i, vertex_t *o, vector_t *d, float distance) {
    //i = o + d * distance
    multiply_constant_vector(i, distance, d);
    add_vectors(i, i, o);
}

/*
* Frees the memory allocated for a world object.
*
* world_t*  world   a pointer to the world object.
*/
void free_world(world_t *world) {
    linked_t    *lights = world->lights,
                *objects = world->objects;
    node_t      *node, *temp;
    object_t    *object;
    
    //frees lights.
    for(node = lights->head; node != NULL; ) {
        temp = node;
        node = node->next;

        free(temp->element);
        free(temp);
    }

    //frees objects.
    for(node = objects->head; node != NULL; ) {
        temp = node;
        node = node->next;

        object = temp->element;
        switch(object->type) {
            case 'T':
                free(object->triangle);
                break;
            case 'S':
                free(object->sphere);
                break;
        }

        free(temp->element);
        free(temp);
    }

    //frees world attributes.
    free(world->dimensions);
    free(world->background);
    free(objects);
    free(world);
}