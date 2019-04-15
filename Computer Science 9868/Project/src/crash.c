#include "crash.h"

/******************************************************************************
* Crash a processor in the network.
******************************************************************************/
int crash(network_t *network, int id)
{
	struct node *p_node = find_processor(network, id);
	processor_t *processor = (processor_t*)p_node->value,
				*next;

	int key;

	/**************************************************************************
	* Return if the processor does not exist.
	***************************************************************************/
	if (processor->id != id) return PROCESSOR_NOT_FOUND;

	processor->active = FALSE;

	return id;
}

void recover(network_t *network, struct node *p_node)
{
	linked_list_t *processors = network->processors;
	processor_t *processor = (processor_t*)p_node->value;
	int m = network->m;

	printf("Network recovering from processor %d crash.\n", processor->id);

	free_fingers(processors);
	free(processor);
	erase(processors, p_node);

	distribute_keys(network->keys, processors, pow(2, m));
	build_finger_tables(processors, m);
}
