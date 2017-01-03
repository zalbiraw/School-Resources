/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Executes the ray tracer.
*/

#include "main.h"

color_t ***pixels;
raytracer_t *raytracer;

int reflectivity = 1;

/*
* main function, calls the init, log, display, and key functions
*/
int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);

    init();

    log_raytracer(raytracer);

    glutReshapeFunc(reshape);
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);

    glutMainLoop();

    return EXIT_SUCCESS;
}

/*
* init initializes glut, gl, raytracer object, and pixels array.
*/
void init() {
    initWindow();
    glClearColor(0.0, 0.0, 0.0, 0.0);

    raytracer = init_raytracer(
        OBJECTS_FILENAME, LIGHTS_FILENAME,
        EYE_X, EYE_Y, EYE_Z,
        TRACER_PLANE_Z, AMBIENT_INTENSITY,
        WORLD_WIDTH, WORLD_HEIGHT, WORLD_DEPTH,
        BACKGROUND_R, BACKGROUND_B, BACKGROUND_G);

    //initializes the pixels array that will store the colors of the pixels
    pixels = (color_t***)malloc((WORLD_WIDTH + 1) * sizeof(color_t**));
    for (int x = 0; x <= WORLD_WIDTH; ++x) {
        pixels[x] = (color_t**)malloc((WORLD_HEIGHT + 1) * sizeof(color_t*));
        for(int y = 0; y <= WORLD_HEIGHT; ++y) {
            pixels[x][y] = (color_t*)malloc(sizeof(color_t));
        }
    }
}

/*
* initWindow initializes the glut window attributes.
*/
void initWindow() {
    glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT);
    glutInitWindowPosition(
        (glutGet(GLUT_SCREEN_WIDTH) - WINDOW_WIDTH)/2,
        (glutGet(GLUT_SCREEN_HEIGHT) - WINDOW_HEIGHT)/2
    );
    glutCreateWindow(WINDOW_NAME);
}

/*
* reshape initializes ortho
*/
void reshape(GLsizei w, GLsizei h) {
    glViewport(0, 0, w, h);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(LEFT, RIGHT, BOTTOM, TOP, NEAR, FAR);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

/*
* Multithreads the raytracer, calculates all pixel colors and draws them.
*/
void display() {
    glClear(GL_COLOR_BUFFER_BIT);

    color_t *color;
    int indices[THREADS];
    pthread_t threads[THREADS];

    //create threads, and start executing opperations
    for(int i = 0; i < THREADS; ++i) {
        indices[i] = i;
        pthread_create(&threads[i], NULL, work, (void*)&indices[i]);
    }

    //wait for threads to finish their jobs
    for(int i = 0; i < THREADS; ++i) {
        pthread_join(threads[i], NULL);
    }

    //draw pixelss
    glBegin(GL_POINTS);
    for (int x = 0; x <= WORLD_WIDTH; ++x) {
        for (int y = 0; y <= WORLD_HEIGHT; ++y) {
            color = pixels[x][y];
            glColor3ub(color->r, color->g, color->b);
            glVertex2i(x, y);
        }
    }
    glEnd();

    //draws lights
    draw_light(raytracer);

    glutSwapBuffers();
}

/*
* Animates the scene by moving the spheres up and down.
*/
void animate() {
    object_t *object;
    sphere_t *sphere;

    for(node_t *node = raytracer->world->objects->head;
        node != NULL; node = node->next) {
        object = node->element;
        sphere = object->sphere;

        //moves the sphere objects
        if (object->type == 'S' && sphere->r < WORLD_HEIGHT / 2) {
            sphere->center.y += sphere->direction * sphere->r / 20;

            if (sphere->center.y - sphere->r <= 0) {
                sphere->direction = 1;
            } else if (sphere->center.y + sphere->r >= WORLD_HEIGHT) {
                sphere->direction = -1;
            }
        }
    }

    glutPostRedisplay();
    glutTimerFunc(DELAY, animate, 0);
}

/*
* Handles keyboard input.
* unsigned char key     the value of the character that was pressed on 
*                       the keyboard.
*/
void keyboard(unsigned char key, int x, int y) {
    switch(key) {
        case 'q': case 'Q':
            for (int x = 0; x <= WORLD_WIDTH; ++x) {
                for(int y = 0; y <= WORLD_HEIGHT; ++y) {
                    free(pixels[x][y]);
                }
                free(pixels[x]);
            }
            free(pixels);
            free_raytracer(raytracer);

            exit(0);
            break;

        case 's': case 'S':
            glutTimerFunc(0, animate, 0);
            break;

        case 'r': case 'R':
            if (reflectivity == REFLECTIVITY_DEPTH) {
                reflectivity = 1;
            } else {
                reflectivity = REFLECTIVITY_DEPTH;
            }
            break;
    }
}

/*
* Calls the calculate_pixel_color to calculate pixel color and sets the returned
* value to the corresponding pixel in the pixels array.
* void* param the id of the job. which pixels to compute.
*/
void* work(void* param) {
    int id = *(int*)param,
        size = WORLD_HEIGHT / (THREADS - 1),
        start = id * size;
    vertex_t eye = {
        .x = EYE_X,
        .y = EYE_Y,
        .z = EYE_Z
    };

    //iterate through pixels and calculate colors.
    for (int x = 0; x <= WORLD_WIDTH; ++x) {
        for (int y = start; y < start + size && y <= WORLD_HEIGHT; ++y) {
            calculate_pixel_color(pixels[x][y], raytracer,
                &eye, raytracer->rays[x][y], reflectivity);
        }
    }
    return NULL;
}
