#include "helper.h"

/******************************************************************************
* Initilizes the network typedef from the file provided.
******************************************************************************/
network_t* initilize_network(char *filename)
{
	
	FILE *fp = fopen(filename, READ);

	if (fp == NULL)
	{
		printf("Unable to open %s\n", filename);
		exit(FAILURE);
	}

	int m, n, k, *key;
	processor_t *processor;
	linked_list_t *keys = init_linked_list(), *processors = init_linked_list();

	fscanf(fp, "m = %d\n", &m);
	fscanf(fp, "n = %d\n", &n);
	fscanf(fp, "k = %d\n", &k);

	/**************************************************************************
	* Read in network keys.
	**************************************************************************/
	for (int i = 0; i < k; ++i)
	{
		key = (int*)malloc(sizeof(int));

		fscanf(fp, "%d\n", key);
		circular_enqueue(keys, (void*)key);
	}
	print_keys(keys);

	/**************************************************************************
	* Read in network processors.
	**************************************************************************/
	for (int i = 0; i < n; ++i)
	{
		processor = (processor_t*)malloc(sizeof(processor_t));

		fscanf(fp, "%hd\n", &processor->id);
		processor->active = TRUE;
		processor->keys = NULL;

		circular_enqueue(processors, processor);
	}
	print_processors(processors);

	fclose(fp);

	/**************************************************************************
	* Assign keys to processors.
	**************************************************************************/
	distribute_keys(keys, processors, pow(2, m));

	/**************************************************************************
	* Build the finger tables of all processors.
	**************************************************************************/
	build_finger_tables(processors, m);

	network_t *network = (network_t*)malloc(sizeof(network_t));
	network->m = m;
	network->keys = keys;
	network->processors = processors;

	print_info(network);

	return network;
}

/*****************************************************************************
* Assign keys to processors.
*****************************************************************************/
void distribute_keys(linked_list_t *keys, linked_list_t *processors, int size)
{
	struct node *k_node = keys->head,
				*p_node = processors->head;

	processor_t *processor, *next;
	int curr_key = *(int*)k_node->value,
		prev_key,
		n = processors->size,
		j = 0,
		k = 0,
		rollover = 0;

	short id;

	for (int i = 0; i < n; ++i, p_node = p_node->next)
	{
		processor = (processor_t*)p_node->value;
		processor->n = 0;

		id = processor->id;

		j = ((i + 1) / n) * size;

		next = (processor_t*)p_node->next->value;

		while (curr_key + rollover <= id)
		{
			k_node = k_node->next;

			prev_key = curr_key;
			curr_key = *(int*)k_node->value;
			rollover = (prev_key > curr_key ? size: 0);

			++processor->n;
			++k;
		}

		if (curr_key <= next->id + j)
			next->keys = k_node;

	}

	((processor_t*)processors->head->value)->n += keys->size - k;
}

/*****************************************************************************
* Build the finger tables for all processors.
*****************************************************************************/
void build_finger_tables(linked_list_t *processors, int m)
{
	linked_list_t *fingers;
	struct node *p_node = processors->head,
				*f_node;

	processor_t *processor;
	int half_size = pow(2, m - 1),
		size = half_size * 2,
		rollover;

	short id, curr_id, prev_id;
	/*************************************************************************
	* Iterate through processors and build finger tables.
	*************************************************************************/
	for (int i = 0; i < processors->size; ++i, p_node = p_node->next)
	{
		processor = (processor_t*)p_node->value;

		id = processor->id;
		processor->fingers = init_linked_list();
		fingers = processor->fingers;

		prev_id = id;
		f_node = p_node->next;

		/*********************************************************************
		* Add the fingers based on the ids closest to the ids of 2^i
		*********************************************************************/
		for (int j = 1, k = 0; j <= half_size; f_node = f_node->next) 
		{
			processor = (processor_t*)f_node->value;
			curr_id = processor->id;
			k += (curr_id < prev_id ? 1 : 0);
			rollover = size * k;

			if (curr_id + rollover >= id + j)
			{
				enqueue(fingers, f_node->value);
				while (curr_id + rollover >= id + j && j <= half_size)
					j *= 2;
			}

			prev_id = curr_id;
		}
	}
}
