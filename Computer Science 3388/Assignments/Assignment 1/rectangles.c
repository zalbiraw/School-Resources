/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
*
* Generates randomly positioned, shaped, and rotated rectangles. 
* Set them on random directions and rotations upon animation.
*/

#include "rectangles.h"

rect_t rects[RECT_NUMBER];
int change = 0;

/*
* Main function, calls the init, the display, and the key functions
*/
int main(int argc, char** argv) {
    glutInit(&argc, argv);

    init();

    glutDisplayFunc(display);
    glutKeyboardFunc(keyboard);

    glutMainLoop();
    free(rects);
    return EXIT_SUCCESS;
}

/*
* Initializes glut, gl, and generates the rectangles.
*/
void init() {
    glutInitDisplayMode(GLUT_DOUBLE);
    glutInitWindowSize(WINDOW_X, WINDOW_Y);

    glutCreateWindow(WINDOW_NAME);

    //sets background
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

    //sets the projection, camera to window coordinates
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, WINDOW_X, 0, WINDOW_Y, 0, 1);

    //switch to the model view, the object view transformation matrix
    glMatrixMode(GL_MODELVIEW);

    srand(time(NULL));
    //Generates rectangles
    generateRectangles();
}

/*
* Draws rectangles
*/
void display() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    //draws and updates rectangles
    for (int i = 0; i < RECT_NUMBER; i++) {
        drawRectangle(rects[i]);
        update(i);
    }

    glutSwapBuffers();
}

/*
* Rescales rectangles and calls the redraw function.
*/
void animate() {
    rect_t r;
    float w, l;
    vertex_t s;

    for (int i = 0; i < RECT_NUMBER; i++) {
        r = rects[i];
        w = r.width;
        l = r.length;
        s = r.scale;

        //Animates width rescaling, and regenerates a new rescale value
        //once the current one is reached.
        if (w < s.x) {
            w++;
        } else if(w > s.x) {
            w--;
        } else {
            rects[i].scale.x = getRand(RECT_MIN, RECT_MAX);
        }

        //Animates length rescaling, and regenerates a new rescale value
        //once the current one is reached.
        if (l < s.y) {
            l++;
        } else if(l > s.y) {
            l--;
        } else {
            rects[i].scale.y = getRand(RECT_MIN, RECT_MAX);
        }

        rects[i].width  = w;
        rects[i].length = l;
    }

    //Redraws
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
            exit(0);
            break;
        case 's': case 'S':
            glutTimerFunc(0, animate, 0);
            break;
    }
}

/*
* Generates rectangles
*/
void generateRectangles() {
    rect_t r;
    for (int i = 0; i < RECT_NUMBER; i++) {
        //randomly generates an rbg color, min set to 1 to avoid a black color
        r.color.r = getRand(1, COLOR_RANGE) / COLOR_RANGE;
        r.color.b = getRand(1, COLOR_RANGE) / COLOR_RANGE;
        r.color.g = getRand(1, COLOR_RANGE) / COLOR_RANGE;

        //randomly generates widths and lengths
        r.width  = getRand(RECT_MIN, RECT_MAX);
        r.length = getRand(RECT_MIN, RECT_MAX);

        //randomly generates rectangle coordinates
        r.position.x = getRand(0, WINDOW_X);
        r.position.y = getRand(0, WINDOW_Y);

        //randomly generates a direction vector
        r.direction.x = getRand(DIR_MIN, DIR_MAX);
        r.direction.y = getRand(DIR_MIN, DIR_MAX);

        //randomly generates the rectangle orientation, and the rotation 
        //direction and angle
        r.orientation = getRand(0, ROTATION_DEGREES);
        r.angle = getRand(ANGLE_MIN, ANGLE_MAX);

        //randomly generates the scaling 
        r.scale.x = getRand(RECT_MIN, RECT_MAX);
        r.scale.y = getRand(RECT_MIN, RECT_MAX);

        rects[i] = r;
    }
}

/*
* Draws rectangles.
* rect_t r  the rectangle object.
*/
void drawRectangle(rect_t r) {
    vertex_t    p = r.position;
    float       w = r.width, 
                l = r.length,
                x1 = p.x, 
                y1 = p.y,
                x2 = x1 + w, 
                y2 = y1 + l,
                cX = x1 + w / 2, 
                cY = y1 + l / 2;

    //resets the transformation matrix
    glLoadIdentity();

    //sets color
    glColor3f(r.color.r, r.color.b, r.color.g);

    //rotates rectangle
    glTranslatef(cX, cY, 0);
    glRotatef(r.orientation, 0, 0, 1);
    glTranslatef(-cX, -cY, 0);

    //draws rectangle
    glRectf(x1, y1, x2, y2);
}

/*
* Updates rectangles with position and orientation changes.
* int i     index of the rectangle that needs to be updated.
*/
void update(int i) {
    rect_t      r = rects[i];
    vertex_t    p = r.position,
                d = r.direction;
    float       x = p.x + d.x,
                y = p.y + d.y;

    //wraps rectangle around the x-axis
    if (x > WINDOW_X) {
        x = 0;
    } else if (x < 0 - r.width) {
        x = WINDOW_X;
    }

    //wraps rectangle around the y-axis
    if (y > WINDOW_Y) {
        y = 0;
    } else if (y < 0 - r.length) {
        y = WINDOW_Y;
    }

    //sets new position coordinates
    rects[i].position.x = x;
    rects[i].position.y = y;

    //sets new orientation
    rects[i].orientation = (int)(r.orientation + r.angle) % ROTATION_DEGREES;
}

/*
* Generates a random float.
* float min     the minimum value for the randomized variable.
* float max     the maximum value for the randomized variable.
*/
float getRand(float min, float max) {
    return (float)(rand() % (int)(max - min + 1) + min);
}