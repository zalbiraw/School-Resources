/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
*
* mesh.c reads in a profile of points and creates a mesh_t from them. 
* The mesh_t will contain the points of a number of rotated profiles 
* around the z-axis, it will also contain a number of triangles that
* will construct the mesh object alog with their normals.
*/

#include "mesh.h"

/*
* getProfile reads the profile textfile, then creates and returns the
* initial mesh object profile in a linked list.
*
* char *file    the filename of the file that contains the profile
*               points.
* int *len      a pointer to an integer that will contain the length
*               of the profile.
*/
node_t* getProfile(char *file, int *len) {
    FILE *fp = fopen(file, "r");

    //Exits if file is not found
    if (fp == NULL) {
        printf("Cannot find file %s\n", file);
        exit(EXIT_SUCCESS);
    }


    float       x, y, z, d;
    node_t      *head = (node_t*)malloc(sizeof(node_t)),
                *node = head,
                *prev = NULL;
    vertex_t    *vertex;

    //Scans file for points
    while(fscanf(fp, "%f %f %f %f\n", &x, &y, &z, &d) != EOF) {
        (*len)++;

        //Holds the point values.
        vertex = (vertex_t*)malloc(sizeof(vertex_t));

        vertex->x = x;
        vertex->y = y;
        vertex->z = z;

        node->vertex = vertex;

        node->next = (node_t*)malloc(sizeof(node_t));
        prev = node;
        node = node->next;
    }

    free(node);

    //Doubles the ammount of profile points for better results.
    for(int i = 0; i < DOUBLE_POINTS; i++) {
        doublePoints(head, len);
    }

    return head;
}

/*
* getMesh returns a mesh_t that contains the points of a number of 
* rotated profiles around the z-axis, it will also contain a number
* of triangles that will construct the mesh object alog with their 
* normals. 
*
* char *file    the filename of the file that contains the profile
*               points.
* int slices    the number of required slices for the mesh object.
*/
mesh_t* getMesh(char* file, int slices) {
    int         len             = 0,
                point_count;
    double      rad             = (360 / slices) * (M_PI / 180),
                sin_theta       = sin(rad),
                cos_theta       = cos(rad);
    float       x, y, z;
    node_t      *node           = getProfile(file, &len),
                *prev;
    vertex_t    **points        = (vertex_t**)malloc(sizeof(vertex_t*)
                                * len * slices),
                *vertex;
    mesh_t      *mesh           = (mesh_t*)malloc(sizeof(mesh_t));

    point_count = slices * len;
    //Moves first profile points to the mesh object points cloud 
    //and clears the linked list allocated memory.
    for(int i = 0; i < len; i++) {
        points[i] = node->vertex;
        prev = node;
        node = node->next;

        free(prev);
    }

    //Calculates and adds the rest of the slices' points to the 
    //points clound
    for(int i = len; i < point_count; i += len) {
        for(int j = 0; j < len; j++) {
            vertex = points[i - len + j];
            x = vertex->x;
            y = vertex->y;
            z = vertex->z;

            vertex = (vertex_t*)malloc(sizeof(vertex_t));
            vertex->x = x * cos_theta - y * sin_theta;
            vertex->y = x * sin_theta + y * cos_theta;
            vertex->z = z;

            points[i + j] = vertex;
        }
    }

    mesh->point_count   = point_count;
    mesh->points        = points;
    triangulate(mesh, slices, len);

    return mesh;
}

/*
* triangulate triangulates the points in the point clouds and 
* generates the surface triangles.
*
* mesh_t *mesh  the pointer to the mesh object.
* int slices    the number of slices in the mesh object.
* int len       the number of points in each profile.
*/
void triangulate(mesh_t *mesh, int slices, int len) {
    int         polygon_count   = slices * (len - 1) * 2,
                p               = 0;
    polygon_t   **polygons      = (polygon_t**)malloc(sizeof(polygon_t*) 
                                    * polygon_count), 
                *polygon;
    vertex_t    **points        = mesh->points,
                **vertices, *v1, *v2, *v3, *v4;

    //Generates triangles and calculates their normals.
    for(int i = len; i <= mesh->point_count; i += len) {
        for(int j = 0; j < len - 1; j++) {
            v1 = points[i - len + j];
            v2 = points[i - len + j + 1];
            v3 = points[i % (slices * len) + j];
            v4 = points[i % (slices * len) + j + 1];  

            //Top triangle
            polygon = (polygon_t*)malloc(sizeof(polygon_t));
            vertices = (vertex_t**)malloc(sizeof(vertex_t*) * 3);

            vertices[0] = v1;
            vertices[1] = v3;
            vertices[2] = v2;

            polygon->points = vertices;
            polygon->normal = calculateNormal(v1, v3, v2);

            polygons[p++] = polygon;

            //Bottom triangle
            polygon = (polygon_t*)malloc(sizeof(polygon_t));
            vertices = (vertex_t**)malloc(sizeof(vertex_t*) * 3);

            vertices[0] = v3;
            vertices[1] = v4;
            vertices[2] = v2;

            polygon->points = vertices;
            polygon->normal = calculateNormal(v3, v4, v2);

            polygons[p++] = polygon;
        }
    }

    mesh->polygon_count = polygon_count;
    mesh->polygons      = polygons;
}

/*
* doublePoints adds extra points to profiles to increase the quality
* of the mesh object
*
* node_t *node  the head of initial profile linked list.
* int len       the number of points in each profile.
*/
void doublePoints(node_t *node, int *len) {
    node_t  *prev = node,
            *next = prev->next;
    vertex_t *vertex, *v1, *v2;

    for(int i = 0; i < *len; i++) {
        node    = (node_t*)malloc(sizeof(node_t));
        vertex  = (vertex_t*)malloc(sizeof(vertex_t));

        v1 = prev->vertex;
        v2 = next->vertex;

        //creates a new points between v1 and v2
        vertex->x = (v1->x + v2->x) / 2;
        vertex->y = (v1->y + v2->y) / 2;
        vertex->z = (v1->z + v2->z) / 2;

        node->vertex = vertex;
        prev->next = node;
        node->next = next;

        prev = next;
        next = next->next;
    }

    *len = (*len * 2) - 1;
}

/*
* calculateNormal calculates the surface normal for v1, v2, and v3
*
* vertex_t *v1  is the first point of the triangle.
* vertex_t *v2  is the second point of the triangle.
* vertex_t *v2  is the third point of the triangle.
*/
vertex_t* calculateNormal(vertex_t* v1, vertex_t* v2, vertex_t* v3) {
    float       x, y, z, len;
    vertex_t    *u      = (vertex_t*)malloc(sizeof(vertex_t)),
                *v      = (vertex_t*)malloc(sizeof(vertex_t)),
                *normal = (vertex_t*)malloc(sizeof(vertex_t));

    //Creates the vectors u, and v.
    u->x = v2->x - v1->x;
    u->y = v2->y - v1->y;
    u->z = v2->z - v1->z;
    v->x = v3->x - v1->x;
    v->y = v3->y - v1->y;
    v->z = v3->z - v1->z;

    //Finds normals
    x = u->y * v->z - u->z * v->y;
    y = u->z * v->x - u->x * v->z;
    z = u->x * v->y - u->y * v->x;

    len = sqrt(x * x + y * y + z * z);

    //Normalizes normals
    normal->x = x / len;
    normal->y = y / len;
    normal->z = z / len;

    free(u);
    free(v);

    return normal;
}

/*
* freeMesh frees the memory allocated to the mesh object.
*
* mesh_t *mesh  the pointer to the mesh object.
*/
void freeMesh(mesh_t* mesh) {
    vertex_t    **points = mesh->points;
    polygon_t   **polygons = mesh->polygons,
                *polygon;

    for (int i = 0; mesh->polygon_count; i++) {
        polygon = polygons[i];
        free(polygon->normal);
        free(polygon);
    }

    for (int i = 0; mesh->point_count; i++) {
        free(points[i]);
    }

    free(mesh);
}