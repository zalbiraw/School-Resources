/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains the logging and debugging functions for the program.
*/

#include "logger.h"

/*
* Draws the light at its approximate position on the screen.
*
* raytracer_t*  raytracer    the pointer to the raytracer object.
*/
void draw_light(raytracer_t *raytracer) {
    light_t *light;
    float x, y;

    //iterates through all the lights
    for (node_t *node = raytracer->world->lights->head; node != NULL;
        node = node->next) {
        light = node->element;

        x = light->position.x;
        y = light->position.y;

        glColor3ub(light->color.r, light->color.g, light->color.b);
        glRectf(x - 2, y - 2, x + 2, y + 2);
    }
}

/*
* Logs the lights' and the objects' attributes to the console.
*
* raytracer_t*  raytracer    the pointer to the raytracer object.
*/
void log_raytracer(raytracer_t *raytracer) {
    world_t *world = raytracer->world;
    light_t *light;
    object_t *object;
    triangle_t *triangle;
    sphere_t *sphere;

    printf("Lights:\n");
    printf("*************************************************\n");
    for (node_t *node = world->lights->head; node != NULL; node = node->next) {
        light = node->element;

        printf("Position: (%.2f, %.2f, %.2f)\n",
            light->position.x, light->position.y, light->position.z);
        printf("Color: (%d, %d, %d)\n",
            light->color.r, light->color.g, light->color.b);
        printf("Intensity: %.2f\n", light->intensity);
        printf("*************************************************\n");
    }

    printf("Objects:\n");
    printf("*************************************************\n");
    for (node_t *i = world->objects->head; i != NULL; i = i->next) {
        object = i->element;

        switch(object->type) {
            case 'T':
                triangle = object->triangle;

                printf("Type: Triangle\n");
                printf("Points: (%.2f, %.2f, %.2f), (%.2f, %.2f, %.2f), (%.2f, %.2f, %.2f)\n",
                    triangle->points[0].x, triangle->points[0].y, triangle->points[0].z,
                    triangle->points[1].x, triangle->points[1].y, triangle->points[1].z,
                    triangle->points[2].x, triangle->points[2].y, triangle->points[2].z);
                printf("Normal: (%.2f, %.2f, %.2f)\n",
                    triangle->normal.x, triangle->normal.y, triangle->normal.z);
                break;
            case 'S':
                sphere = object->sphere;

                printf("Type: Sphere\n");
                printf("Center: (%.2f, %.2f, %.2f)\n",
                    sphere->center.x, sphere->center.y, sphere->center.z);
                printf("Radius: %.2f\n", sphere->r);
                break;
        }

        printf("Color: (%d, %d, %d)\n",
            object->color.r, object->color.g, object->color.b);
        printf("Ambient Reflectivity: %.2f\n", object->ambient);
        printf("Diffuse Reflectivity: %.2f\n", object->diffuse);
        printf("Specular Reflectivity: %.2f\n", object->specular);
        printf("Fallout Rate: %d\n", object->fallout);
        printf("Object Reflectivity: %.2f\n", object->reflectivity);
        printf("*************************************************\n");
    }
}
