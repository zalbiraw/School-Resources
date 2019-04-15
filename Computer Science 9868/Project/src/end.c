#include "end.h"

/******************************************************************************
* End a processor in the network and rebalance keys.
******************************************************************************/
int end(network_t *network, int id, int m)
{
	linked_list_t *processors = network->processors;
	struct node *p_node = find_processor(network, id),
				*k_node;

	processor_t *processor = (processor_t*)p_node->value,
				*next;

	int key;

	/**************************************************************************
	* Return if the processor does not exist.
	***************************************************************************/
	if (processor->id != id) return PROCESSOR_NOT_FOUND;

	/**************************************************************************
	* Get successor using finger table.
	***************************************************************************/
	next = (processor_t*)processor->fingers->head->value;

	/**************************************************************************
	* Check if the next processor is active.
	***************************************************************************/
	if (next->active == FALSE)
	{
		recover(network, next);
		return end(network, id, m);
	}

	/**************************************************************************
	* Set the successors keys to start where this processors started if it
	* managed any.
	***************************************************************************/
	id = next->id;

	if (processor->keys != NULL)
	{
		next->n += processor->n;
		next->keys = processor->keys;

		k_node = next->keys;
		key = *(int*)k_node->value;
		printf("Keys moved to processor %d [ %d", id, key);

		k_node = k_node->next;
		for(int i = 1; i < processor->n; ++i, k_node = k_node->next)
			printf(", %d", *(int*)k_node->value);

		printf(" ]\n");
	} 

	else printf("No keys moved to processor %d.\n", id);

	free_fingers(processors);
	free(processor);
	erase(processors, p_node);

	build_finger_tables(processors, m);

	return id;
}
