/*
* Name: Zaid Albirawi
* Student Number: 250626065
* Email: zalbiraw@uwo.ca
* Due Date: December 7th, 2016
* 
* Contains linked list definition and operations.
*/

#include "linked_list.h"

/*
* Adds a node to the linked list.
*
* linked_t* 	list    the pointer to the linked list.
* void* 		element the pointer to the node value.
*/
void add(linked_t *list, void *element) {
    node_t *node = (node_t*)malloc(sizeof(node_t));

    node->element = element;
    node->next = NULL;

    if (list->head == NULL) {
        list->head = list->tail = node;
    } else {
        list->tail->next = node;
        list->tail = node;
    }
}