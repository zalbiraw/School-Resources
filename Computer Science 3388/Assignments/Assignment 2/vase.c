/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
*/

#include "vase.h"

int     size        = 0;
float   ambient[]   = AMBIENT,
        diffuse[]   = DIFFUSE,
        specular[]  = SPECULAR,
        position_x  = POSITION_X, 
        position_y  = POSITION_Y;
double  sin_theta, cos_theta;
mesh_t* mesh;

/*
* main function, calls the init, the display, and the key functions
*/
int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

    init();

    glutReshapeFunc(reshape);
    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);

    glutTimerFunc(0, animate, 0);

    glutMainLoop();
    
    freeMesh(mesh);
    return EXIT_SUCCESS;
}

/*
* init initializes glut, gl and the mesh object.
*/
void init() {
    initWindow();
    initLight();
    glClearColor (0.0, 0.0, 0.0, 0.0);
    glEnable(GL_DEPTH_TEST);

    mesh = getMesh(PROFILE_TXT, 360 / THETA);

    //Calculates the values for light rotation
    float rad = ROTATION_RATE * M_PI / 180;
    sin_theta = sin(rad);
    cos_theta = cos(rad);
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
* initLight initializes the light attributes.
*/
void initLight() {
    glEnable(GL_COLOR_MATERIAL);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, specular);

    glLightModelf(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
}

/*
* reshape initializes ortho and lookAt
*/
void reshape (GLsizei w, GLsizei h) {
    glViewport(0, 0, w, h);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(LEFT, RIGHT, BOTTOM, TOP, NEAR, FAR);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(  
        EYE_X, EYE_Y, EYE_Z, 
        REFERENCE_X, REFERENCE_Y, REFERENCE_Z, 
        UP_X, UP_Y, UP_Z);
}

/*
* display draws the mesh.
*/
void display() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    drawAxis();

    //Sets the position of the light
    float position[] = {position_x, position_y, POSITION_Z, 1.0f};
    glLightfv(GL_LIGHT0, GL_POSITION, position);

    drawTriangles();

    glutSwapBuffers();
}

/*
* drawAxis draws axis.
*/
void drawAxis() {
    glBegin(GL_LINES);
        glColor3f(1, 0, 0);
        glVertex3f(-SCREEN_SCALE, 0.0, 0.0);
        glVertex3f(SCREEN_SCALE, 0.0, 0.0);

        glColor3f(0, 1, 0);
        glVertex3f(0.0, -SCREEN_SCALE, 0.0);
        glVertex3f(0.0, SCREEN_SCALE, 0.0);

        glColor3f(0, 0, 1);
        glVertex3f(0.0, 0.0, -SCREEN_SCALE);
        glVertex3f(0.0, 0.0, SCREEN_SCALE);
    glEnd();
}

/*
* animate recalculates the position the new position of the lights 
* and repaints 
*/
void animate() {
    float   new_x = position_x * cos_theta - position_y * sin_theta,
            new_y = position_x * sin_theta + position_y * cos_theta;

    position_x = new_x;
    position_y = new_y;

    glutPostRedisplay();
    glutTimerFunc(DELAY, animate, 0);
}

/*
* drawTriangles draws the mesh triangles.
*/
void drawTriangles() {
    polygon_t   **polygons = mesh->polygons,
                *polygon;

    vertex_t    **points, *normal, *v1, *v2, *v3;

    for(int i = 0; i < mesh->polygon_count; i++) {
        polygon = polygons[i];
        points = polygon->points;
        normal = polygon->normal;
        v1 = points[0];
        v2 = points[1];
        v3 = points[2];

        glColor3f(POLYGON_RED, POLYGON_BLUE, POLYGON_GREEN);
        glBegin(GL_POLYGON);
            glNormal3f(normal->x, normal->y, normal->z);
            glVertex3f(v1->x, v1->y, v1->z);
            glVertex3f(v2->x, v2->y, v2->z);
            glVertex3f(v3->x, v3->y, v3->z);
        glEnd();
    }
}

/*
* Handles keyboard input.
* unsigned char key     the value of the character that was pressed on 
*                       the keyboard.
*/
void keyboard(unsigned char key, int x, int y) {
    switch(key) {
        case 'q': case 'Q':
            exit(0);
            break;
    }
}