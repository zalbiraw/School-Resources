#include "find.h"

/******************************************************************************
* Finds a key in the network.
******************************************************************************/
int find(network_t *network, int id, int key, int size)
{
	struct node *p_node = find_processor(network, id),
				*k_node;

	processor_t *processor;
	int k;

	/*************************************************************************
	* Terminate if the processor does not exist.
	*************************************************************************/
	processor = (processor_t*)p_node->value;
	if (processor->id != id)
		return PROCESSOR_NOT_FOUND;
	
	/*************************************************************************
	* Look for key in the current processor.
	*************************************************************************/
	k_node = processor->keys;
	if (k_node != NULL) for (int i = 0; i < processor->n; ++i)
	{
		k = *(int*)k_node->value;
		
		if (k == key % size) return id;

		k_node = k_node->next;
	} 
		
	/*************************************************************************
	* Look for the key using the fingers of the processor.
	*************************************************************************/
	return find_key(network, p_node, id, key, 0, size);
}

/******************************************************************************
* Finds a processor or its successor in the network.
******************************************************************************/
struct node* find_processor(network_t *network, int id)
{
	linked_list_t *processors = network->processors;
	struct node *p_node = processors->head;
	processor_t *processor;

	for (int i = 0; i < processors->size; ++i, p_node = p_node->next)
	{
		processor = (processor_t*)p_node->value;
		if (id <= processor->id)
		{
			if (processor->active == FALSE)
			{
				recover(network, p_node);
				return find_processor(network, id);
			}
			
			else return p_node;
		} 
	}

	return processors->head;
}

/******************************************************************************
* Recursively tries to find a key in the network.
******************************************************************************/
int find_key(network_t *network, struct node *p_node, short original_id,
	int key, int k, int size)
{
	processor_t *processor = (processor_t*)p_node->value;
	int id = processor->id;

	if (processor->active == FALSE)
	{
		recover(network, find_processor(network, id));
		return find(network, original_id, key, size);
	}

	printf("Searching in processor %d\n", id);
	if (id + (k * size) >= key)
	{
		if (processor->keys == NULL) return KEY_NOT_FOUND;

		struct node *k_node = processor->keys;

		key %= size;

		while (*(int*)k_node->value < key) k_node = k_node->next;
		if (*(int*)k_node->value == key) return id;
	}

	else 
	{
		linked_list_t *fingers = processor->fingers;
		struct node *f_node = fingers->head;
		int prev_id = id;

		id = ((processor_t*)f_node->value)->id;
		k += (id < prev_id ? 1 : 0);

		if (id + (k * size) >= key)
			return find_key(network, f_node, original_id, key, k, size);

		while (f_node->next != NULL)
		{
			prev_id = id;
			id = ((processor_t*)f_node->next->value)->id;
			k += (id < prev_id ? 1 : 0);

			if (id + (k * size) <= key) f_node = f_node->next;
			else 
			{
				k -= (id < prev_id ? 1 : 0);
				break;
			}
		}

		return find_key(network, f_node, original_id, key, k, size);
	}

	return KEY_NOT_FOUND;
}

