/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains world objects and their readers.
*/

#include "world_objects.h"

/*
* Checks if the file exists and opens it if it does.
*
* char* filename    the filename.
*
* returns a pointer to the file descriptor opened.
*/
FILE* open_file(char *filename) {
    FILE *fd = fopen(filename, "r");

    if (fd == NULL) {
        printf("Cannot find file %s\n", filename);
        exit(EXIT_SUCCESS);
    }

    return fd;
}

/*
* Reads all the lights inside the lights file descriptor in the world lights
* linked list.
*
* char*         filename    the lights descriptor filename.
* linked_t*     lights      the pointer to the world lights linked list.
*/
void load_lights(char *filename, linked_t *lights) {
    FILE *fd = open_file(filename);
    light_t *light;
    vertex_t position;
    color_t color;
    float intensity;

    //reads all light attributes
    while(fscanf(fd, "Position: %f %f %f, Color: %d %d %d, Intensity: %f\n",
        &position.x, &position.y, &position.z,
        &color.r, &color.g, &color.b,
        &intensity) != EOF) {

        light = (light_t*)malloc(sizeof(light_t));
        light->position = position;
        light->color = color;
        light->intensity = intensity;
        add(lights, light);
    }

    fclose(fd);
}

/*
* Reads all the objects inside the objects file descriptor in the world objects
* linked list.
*
* char*         filename    the objects descriptor filename.
* linked_t*     objects     the pointer to the world objects linked list.
*/
void load_objects(char *filename, linked_t *objects) {
    FILE *fd = open_file(filename);
    char type;
    int id = -1, 
        fallout;
    float ambient, diffuse, specular, reflectivity;
    color_t color;
    object_t *object;

    //reads all object attributes
    while(fscanf(fd, "%c\n\tColor: %d %d %d\n\tAmbient: %f\n\tDiffuse: %f\n\tSpecular: %f\n\tFallout: %d\n\tReflectivity: %f\n",
        &type,
        &color.r, &color.g, &color.b,
        &ambient, &diffuse, &specular,
        &fallout, &reflectivity) != EOF) {
        object = (object_t*)malloc(sizeof(object_t));

        object->id = ++id;
        object->type = type;
        object->color = color;
        object->ambient = ambient;
        object->diffuse = diffuse;
        object->specular = specular;
        object->fallout = fallout;
        object->reflectivity = reflectivity;

        //switch to read the rest of the object attributes based on the object
        //type
        switch(type) {
            case 'T':
                read_triangle_object(fd, object);
                break;
            case 'S':
                read_sphere_object(fd, object);
                break;
        }

        add(objects, object);
    }

    fclose(fd);
}

/*
* A load_objects helper that reads a triangle object attributes
*
* FILE*         fd          the file descriptor for the objects descriptor file.
* object_t*     object      the pointer to the object struct.
*/
void read_triangle_object(FILE *fd, object_t *object) {
    vector_t u, v;
    vertex_t *points; 
    triangle_t *triangle = (triangle_t*)malloc(sizeof(triangle_t));

    points = triangle->points;
    fscanf(fd, "\tPoints: (%f %f %f), (%f %f %f), (%f %f %f)\n",
        &points[0].x, &points[0].y, &points[0].z,
        &points[1].x, &points[1].y, &points[1].z,
        &points[2].x, &points[2].y, &points[2].z);

    sub_vectors(&u, &points[1], &points[0]);
    sub_vectors(&v, &points[2], &points[0]);
    cross_vectors(&triangle->normal, &u, &v);
    normalize_vector(&triangle->normal);

    object->triangle = triangle;
}

/*
* A load_objects helper that reads a sphere object attributes
*
* FILE*         fd          the file descriptor for the objects descriptor file.
* object_t*     object      the pointer to the object struct.
*/
void read_sphere_object(FILE *fd, object_t *object) {
    vertex_t center;
    sphere_t *sphere = (sphere_t*)malloc(sizeof(sphere_t));

    fscanf(fd, "\tCenter: %f %f %f\n\tRadius: %f\n",
        &center.x, &center.y, &center.z,
        &sphere->r);

    sphere->direction = -1;
    sphere->center = center;

    object->sphere = sphere;
}
