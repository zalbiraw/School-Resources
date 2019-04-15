#include "printer.h"

/******************************************************************************
* Print the network keys.
******************************************************************************/
void print_keys(linked_list_t *keys)
{
	struct node *k_node = keys->head;

	printf("Keys: [ %d", *(int*)k_node->value);

	k_node = k_node->next;
	for (int i = 1; i < keys->size; ++i, k_node = k_node->next)
		printf(", %d", *(int*)k_node->value);

	printf(" ]\n\n");
}

/******************************************************************************
* Print the network processors.
******************************************************************************/
void print_processors(linked_list_t *processors)
{
	struct node *p_node = processors->head;

	printf("Processors: [ %d", *(int*)p_node->value);

	p_node = p_node->next;
	for (int i = 1; i < processors->size; ++i, p_node = p_node->next)
		printf(", %d", *(int*)p_node->value);

	printf(" ]\n\n");
}

/******************************************************************************
* Print the network information.
******************************************************************************/
void print_info(network_t *network)
{
	linked_list_t 	*processors = network->processors,
					*fingers;

	struct node *p_node = processors->head,
				*k_node, *f_node;

	processor_t *processor;
	int id;

	/**************************************************************************
	* Print the information of every processor.
	**************************************************************************/
	for (int i = 0; i < processors->size; ++i, p_node = p_node->next)
	{
		processor = (processor_t*)p_node->value;
		k_node = processor->keys;

		/**********************************************************************
		* Print the processor keys.
		**********************************************************************/
		printf("Processor: %d\n", processor->id);
		printf("Keys: [ ");
		if (processor->keys == NULL) printf("NULL");
		else
		{
			printf("%d", *(int*)k_node->value);

			k_node = k_node->next;
			for (int j = 1; j < processor->n; ++j, k_node = k_node->next)
				printf(", %d", *(int*)k_node->value);

		}
		printf(" ]\n");

		/**********************************************************************
		* Print the processor fingers.
		**********************************************************************/
		printf("Fingers: [ ");

		fingers = processor->fingers;
		f_node = fingers->head;

		printf("%d", ((processor_t*)f_node->value)->id);

		f_node = f_node->next;
		for (int j = 1; j < fingers->size; ++j, f_node = f_node->next)
			printf(", %d", ((processor_t*)f_node->value)->id);
		
		printf(" ]\n\n");

	}
}
