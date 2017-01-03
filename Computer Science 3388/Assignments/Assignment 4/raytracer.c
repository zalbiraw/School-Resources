/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains raytracer objects, definitions and operations.
*/

#include "raytracer.h"

/*
* Initializes the raytracer object
*
* char* objects             the filename for the objects descriptor.
* char* lights              the filename for the lights descriptor.
* float eye_x               the x coordinate of the eye position.
* float eye_y               the y coordinate of the eye position.
* float eye_z               the z coordinate of the eye position.
* float tracer_plane        the z index at which the tracer plane resides.
* float ambient_intensity   the ambient intensity for the world.
* float world_width         the world width.
* float world_height        the world height.
* float world_depth         the world depth.
* int   bg_r                the world background color r channel.
* int   bg_g                the world background color g channel.
* int   bg_b                the world background color b channel.
*
* returns a pointer to the raytracer object.
*/
raytracer_t* init_raytracer(
    char* objects, char* lights,
    float eye_x, float eye_y, float eye_z,
    float tracer_plane, float ambient_intensity,
    float world_width, float world_height, float world_depth,
    int bg_r, int bg_b, int bg_g) {
    
    raytracer_t *raytracer  = (raytracer_t*)malloc(sizeof(raytracer_t));
    world_t     *world      = init_world(
        ambient_intensity,
        world_width, world_height, world_depth,
        bg_r, bg_b, bg_g);
    vertex_t eye;
    
    eye.x = eye_x;
    eye.y = eye_y;
    eye.z = eye_z;

    raytracer->tracer_plane = tracer_plane;
    raytracer->world = world;

    //pre-generates eye-tracer rays
    construct_rays(raytracer, &eye);

    //loads lights and objects
    load_lights(lights, world->lights);
    load_objects(objects, world->objects);

    return raytracer;
}

/*
* Generate the eye-object rays.
*
* raytracer_t*  raytracer   a pointer to the raytracer object.
* vertex_t*     eye         a pointer to the eye vertex.
*/
void construct_rays(raytracer_t* raytracer, vertex_t *eye) {
    vertex_t    *dimensions    = raytracer->world->dimensions,
                point;
    vector_t    ***rays        = (vector_t***)malloc(
                                    (dimensions->x + 1) * 
                                    (dimensions->y + 1) * 
                                    sizeof(vector_t*)
                                    ),
                **col;

    //sets the z coordinate for all the points as they are all the same.
    point.z = raytracer->tracer_plane;

    //generate and store rays into the rays attribute of the raytracer obejct.
    for (int x = 0; x <= dimensions->x; ++x) {
        point.x = x;
        col     = (vector_t**)malloc(
                        sizeof(vector_t*) * 
                        (dimensions->y + 1));

        for (int y = 0; y <= dimensions->y; ++y) {
            point.y = y;
            col[y] = (vector_t*)malloc(sizeof(vector_t));
            sub_vectors(col[y], &point, eye);
            normalize_vector(col[y]);
        }

        rays[x] = col;
    }

    raytracer->rays = rays;
}

/*
* Calculates the color of the requested pixel.
*
* color_t*      color       is a pointer to the color object that will be
*                           populated.
* raytracer_t*  raytracer   is a pointer to the raytracer object.
* vertex_t*     origin      is a pointer to the ray origin vertex.
* vector_t*     ray         is a pointer to the ray origin-object ray.
*/
void calculate_pixel_color(color_t *color, raytracer_t *raytracer,
    vertex_t *origin, vector_t *ray, int depth) {
    world_t     *world  = raytracer->world;
    object_t    *object, 
                *closest_object = NULL;
    color_t     *bg     = world->background,
                shading_model;
    float       distance, 
                closest_distance = -1;

    //sets the pixel color to the default background color
    color->r = bg->r;
    color->b = bg->b;
    color->g = bg->g;

    //returns background color if the max depth is reached
    if (depth == 0) {
        return;
    }

    //iterates all world objects and finds if the rays intersect any of these
    //objects
    for(node_t *node = world->objects->head; node != NULL;
        node = node->next) {
        object = node->element;
        distance = intersect(origin, ray, object);

        if (!isnan(distance) && (closest_distance == -1 
            || distance < closest_distance)) {
            closest_distance = distance;
            closest_object = object;
        }
    }

    //calculates the color of the pixel if the ray at that point intersects an
    //object
    if (closest_object != NULL) {
        evaluate_shading_model(&shading_model, raytracer, origin, ray,
            closest_object, closest_distance, depth);

        color->r = fmin(shading_model.r, 255);
        color->b = fmin(shading_model.b, 255);
        color->g = fmin(shading_model.g, 255);
    }
}

/*
* Calculates the color of the requested pixel using the Phong shading model.
*
* color_t*      shading_model   is a pointer to the color object that will be
*                               populated.
* raytracer_t*  raytracer       is a pointer to the raytracer object.
* vertex_t*     origin          is a pointer to the ray origin vertex.
* vector_t*     ray             is a pointer to the ray origin-object ray.
* object_t*     object          is a pointer to the intersected object.
* float         distance        is the distance between the ray origin and
*                               the object.
*/
void evaluate_shading_model(color_t *shading_model, raytracer_t *raytracer,
    vertex_t *origin, vector_t *ray, object_t *object, float distance,
    int depth) {
    world_t     *world      = raytracer->world;
    linked_t    *lights     = world->lights,
                *objects    = world->objects;
    vector_t    light_ray, normal, reflection_ray;
    vertex_t    intersection;
    light_t     *light;
    object_t    *target;
    color_t     reflection_color;
    float shading, ambient, diffuse, specular;

    //sets ambient color to be the minimum coloring for the pixel
    ambient = world->ambient * object->ambient;
    shading_model->r = object->color.r * ambient;
    shading_model->b = object->color.b * ambient;
    shading_model->g = object->color.g * ambient;

    //finds the intersection point
    find_interesction_point(&intersection, origin, ray, distance);

    //iterates through all the lights and calculates the shading model for each
    //color
    for(node_t *i = lights->head; i != NULL; i = i->next) {
        light = i->element;

        //calculates the shadow ray
        sub_vectors(&light_ray, &light->position, &intersection);
        normalize_vector(&light_ray);

        //checks if the shadow ray intersects any objects
        for(node_t *j = objects->head; j != NULL; j = j->next) {
            target = j->element;
            //ignore intersections with self
            if (object->id == target->id) {
                continue;
            }

            //skips the shading if an intersection is found
            if (intersect(&intersection, &light_ray, target) > -1) {
                goto SKIP_SHADING;
            }
        }

        //retrieves the normal at the point of intersection
        get_normal(&normal, object, &intersection);
        find_reflected_ray(&reflection_ray, ray, &normal);

        //computes the shading
        diffuse = evaluate_diffuse(&normal, &light_ray);
        specular = evaluate_specular(object, ray, &normal, &light_ray);

        //computes reflection
        calculate_pixel_color(&reflection_color, raytracer,
            &intersection, &reflection_ray, depth - 1);

        shading = light->intensity * (object->diffuse * diffuse + 
            object->specular * specular);

        shading_model->r += light->color.r * shading + reflection_color.r * object->reflectivity;
        shading_model->g += light->color.g * shading + reflection_color.g * object->reflectivity;
        shading_model->b += light->color.b * shading + reflection_color.b * object->reflectivity;

        SKIP_SHADING:
        continue;
    }
}

/*
* Calculates diffuse shading.
*
* vector_t* n   is a pointer to the normal vector of the intersection point.
* vector_t* l   is a pointer to the light vector from the intersection point
*               to the light.
*
* returns the diffuse shader value.
*/
float evaluate_diffuse(vector_t *n, vector_t *l) {
    //max(0, light source vector . normal vector
    return fmax(0, dot_vectors(l, n));
}

/*
* Calculates specular shading.
*
* object_t*     object       is a pointer to the intersected object.
* vector_t*     ray          is a pointer to the origin-object ray.
* vector_t* n   is a pointer to the normal vector of the intersection point.
* vector_t* l   is a pointer to the light vector from the intersection point
*               to the light.
*
* returns the shader specular value.
*/
float evaluate_specular(object_t *object, vector_t *ray, vector_t *n,
    vector_t *l) {
    vector_t v, r, r1, r2;

    multiply_constant_vector(&v, -1, ray);

    // R = −L + 2(N.L)N
    multiply_constant_vector(&r1, -1, l);
    multiply_constant_vector(&r2, 2 * dot_vectors(n, l), n);
    add_vectors(&r, &r1, &r2);

    return pow(fmax(0, dot_vectors(&v, &r)), object->fallout);//TODO
}

/*
* Frees the memory used for the raytracer.
*
* raytracer_t* raytracer a pointer to the raytracer object.
*/
void free_raytracer(raytracer_t *raytracer) {
    world_t     *world      = raytracer->world;
    vector_t    ***rays     = raytracer->rays;
    vertex_t    *dimensions = world->dimensions;

    for (int x = 0; x <= dimensions->x; ++x) {
        for (int y = 0; y <= dimensions->y; ++y) {
            free(rays[x][y]);
        }
        free(rays[x]);
    }

    free(rays);
    free_world(world);
    free(raytracer);
}