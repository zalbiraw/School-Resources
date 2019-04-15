#include "simulator.h"

int main()
{
	network_t *network = initilize_network(INPUT);
	int i, size = pow(2, network->m);

	while(TRUE)
	{
		printf("\nPlease select one of the following commands to interact with the simulator:\n"
			"\t1. Find a key\n"
			"\t2. Add a processor\n"
			"\t3. End a processor\n"
			"\t4. Crash a processor\n"
			"\t5. Print network information\n"
			"\t6. Exit simulator\n\n"
		);

		printf("simulator> ");

		if (!scanf("%d", &i)) break;

		switch(i)
		{

			case FIND:
				simulate_find(network, size);
				break;

			case ADD:
				simulate_add(network, size);
				break;

			case END:
				simulate_end(network, size);
				break;

			case CRASH:
				simulate_crash(network);
				break;

			case PRINT:
				print_info(network);
				break;

			case EXIT:
				goto TERMINATE;

		}
	}

TERMINATE:
	free_network(network);
	exit(SUCCESS);
}

void simulate_find(network_t *network, int size)
{
	int key, res;
	short id;

	printf("Processor ID: ");
	scanf("%hd", &id);

	printf("Key: ");
	scanf("%d", &key);

	printf("Searching for key %d...\n", key);

	if (key < size) 
		res = find(network, id, key + (id > key ? size : 0), size);

	else res = KEY_NOT_FOUND;

	if (res == PROCESSOR_NOT_FOUND)
		printf("Processor %d does not exist in the network.\n", id);

	else if (res == KEY_NOT_FOUND)
		printf("Key %d does not exist in the network.\n", key);

	else
		printf("Found key %d in processor %d.\n", key, res);
}

void simulate_add(network_t *network, int size)
{
	int res;
	short id;

	printf("Processor ID: ");
	scanf("%hd", &id);

	printf("Adding processor %d...\n", id);

	if (id >= size) res = PROCESSOR_ID_TOO_LARGE;

	else res = add(network, id, network->m);

	if (res == PROCESSOR_EXISTS)
		printf("Processor %d already exists in the network.\n", id);

	else if (res == PROCESSOR_ID_TOO_LARGE)
		printf("Processor id value, %d, is too large or network space.\n", id);

	else
		printf("Processor %d added to the network.\n", res);
}

void simulate_end(network_t *network, int size)
{
	int res;
	short id;

	printf("Processor ID: ");
	scanf("%hd", &id);

	printf("Ending processor %d...\n", id);

	res = end(network, id, network->m);

	if (res == PROCESSOR_NOT_FOUND)
		printf("Processor %d does not exist in the network.\n", id);

	else
		printf("Processor %d ended.\n", id);
}

void simulate_crash(network_t *network)
{
	int res;
	short id;

	printf("Processor ID: ");
	scanf("%hd", &id);

	printf("Crashing processor %d...\n", id);

	res = crash(network, id);

	if (res == PROCESSOR_NOT_FOUND)
		printf("Processor %d does not exist in the network.\n", id);

	else
		printf("Processor %d crashed.\n", id);
}
