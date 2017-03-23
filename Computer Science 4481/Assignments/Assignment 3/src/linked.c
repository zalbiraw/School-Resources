#include "linked.h"

node_t* create(int index) {

  node_t *node = (node_t*)malloc(sizeof(node_t));
  node->index = index;
  node->next = NULL;
  return node;

}

linked_t* init() {

  linked_t *list = (linked_t*)malloc(sizeof(linked_t));
  list->head = list->tail = NULL;
  list->len = 0;

  return list;
}

void push(linked_t* list, int index) {

  node_t *node = create(index);

  if (list->len == 0) list->head = list->tail = node;
  else {

    list->tail->next = node;
    list->tail = node;

  }

  list->len++;
}

void trim(linked_t* list) {

  node_t *head = list->head;

  if (list->len == 1) list->head = list->tail = NULL;
  else list->head = head->next;

  list->len--;

  free(head);
}


void trim_until(linked_t* list, int index) {
  
  for (node_t *node = list->head; node && node->index < index;
    node = list->head) trim(list);

}
