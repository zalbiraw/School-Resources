#include "memory.h"

/******************************************************************************
* Frees allocated memory for the network object.
******************************************************************************/
void free_network(network_t *network)
{
	linked_list_t	*keys 		= network->keys,
					*processors = network->processors,
					*fingers;

	struct node *k_node = keys->head, 
				*p_node = processors->head,
				*f_node, *temp;
	int *key;

	/**************************************************************************
	* Frees the memory allocated for the network keys.
	**************************************************************************/
	for (int i = 0; i < keys->size; ++i)
	{
		key = (int*)k_node->value;
		free(key);

		temp = k_node;
		k_node = k_node->next;
		free(temp);
	}
	free(keys);

	/**************************************************************************
	* Frees the memory allocated for the finger tables for all the processors.
	**************************************************************************/
	free_fingers(processors);

	/**************************************************************************
	* Frees the memory allocated for all the processors.
	**************************************************************************/
	for (int i = 0; i < processors->size; ++i)
	{
		free((processor_t*)p_node->value);
		temp = p_node;
		p_node = p_node->next;
		free(temp);
	}
	free(processors);

	/**************************************************************************
	* Frees the memory allocated for the network typedef.
	**************************************************************************/
	free(network);
}

/******************************************************************************
* Frees the memory allocated for the finger tables for all the processors.
******************************************************************************/
void free_fingers(linked_list_t *processors)
{
	linked_list_t *fingers;

	struct node *p_node = processors->head,
				*f_node, *temp;

	for (int i = 0; i < processors->size; ++i)
	{
		fingers = ((processor_t*)p_node->value)->fingers;

		f_node = fingers->head;
		for (int j = 0; j < fingers->size; ++j)
		{
			temp = f_node;
			f_node = f_node->next;
			free(temp);
		}
		free(fingers);

		p_node = p_node->next;
	}
}
