#include "add.h"

/******************************************************************************
* Add a new processor to the network and rebalance keys.
******************************************************************************/
int add(network_t *network, int id, int m)
{
	linked_list_t *processors = network->processors;
	struct node *p_node = find_processor(network, id),
				*k_node;

	processor_t *processor,
				*next = (processor_t*)p_node->value;

	int key, i = 0, j, size = 0;

	/**************************************************************************
	* Return because the processor already exsits in the system.
	**************************************************************************/
	if (next->id == id) return PROCESSOR_EXISTS;

	/**************************************************************************
	* Free the finger tables of all processors in preperation of rebuilding
	* them.
	**************************************************************************/
	free_fingers(processors);

	/**************************************************************************
	* Create new processor.
	**************************************************************************/
	processor = (processor_t*)malloc(sizeof(processor_t));

	processor->id = id;
	processor->active = TRUE;
	key = (next->keys != NULL ? *(int*)next->keys->value : 0);
	/**************************************************************************
	* Find keys for the successor processor after the new addition.
	**************************************************************************/
	if (next->keys == NULL
		|| (id < next->id && id < key && next->id >= key)
		|| (id > next->id && (id < key || (id > key && next->id >= key)))
	)
	{
		processor->n = 0;
		processor->keys = NULL;
		printf("No keys moved to new processor.\n");
	}

	else
	{
		k_node = processor->keys = next->keys;
		/**********************************************************************
		* If the new id value is less than the next key value then roll it
		* over.
		**********************************************************************/
		while (id < key) 
		{
			k_node = k_node->next;
			key = *(int*)k_node->value;
			++i;
		}

		/**********************************************************************
		* If key value is lower than the new id then find the key equal to or
		* higher than the new id value.
		**********************************************************************/
		while (id >= key + size) 
		{
			k_node = k_node->next;
			j = key;
			key = *(int*)k_node->value;

			size = (j > key ? pow(2, network->m) : 0);

			++i;
		}

		processor->n = i;
		next->n -= i;

		if (next->n == 0) next->keys = NULL;
		else next->keys = k_node;
	}
	
	if (processor->n != 0)
	{
		k_node = processor->keys;
		printf("The following keys were moved to processor %d [ %d",
			id, *(int*)k_node->value);

		k_node = k_node->next;
		for(int i = 1; i < processor->n; ++i, k_node = k_node->next)
			printf(", %d", *(int*)k_node->value);

		printf(" ]\n");
	}

	/**************************************************************************
	* Insert the new processor to the network.
	**************************************************************************/
	insert(processors, p_node->prev, processor);

	/**************************************************************************
	* Rebuild finger tables for all processors in the network.
	**************************************************************************/
	build_finger_tables(processors, m);

	return id;
}
