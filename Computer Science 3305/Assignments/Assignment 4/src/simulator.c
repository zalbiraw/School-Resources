#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "simulator.h"

int main (int argc, char** argv)
{
	if (argc < 4)
		failure();

	int frames;
	if ((frames = atoi(argv[1])) < 1)
		failure();

	if (strcmp(argv[3], "LRU") == 0)
		simulate(frames, open_trace(argv[2]), LRU);
	else if(strcmp(argv[3], "LFU") == 0)
		simulate(frames, open_trace(argv[2]), LFU);
	else failure();

	return EXIT_SUCCESS;
}

void failure()
{
	printf("Incorrect format. Use cases:\n");
	printf("\tsimulator # trace.txt LRU\n");
	printf("\tsimulator # trace.txt LFU\n");
	exit(EXIT_FAILURE);
}

FILE* open_trace(char* trace)
{
	FILE *fp = fopen(trace, "r");

	if (fp == NULL)
	{
		printf("Error: Failed to open file.\n");
		exit(EXIT_FAILURE);
	}
	return fp;
}

void simulate(int frames, FILE* trace, short algo)
{
	int mem_loc, i, miss = 0;
	size_t n = STR_LEN;
	char* str_mem = (char*)malloc(STR_LEN + 1);
	page_t** table = generate_table(frames, 0);

	while(getline (&str_mem, &n, trace) != -1)
	{
		mem_loc = atoi(str_mem);
		i = find(table, mem_loc, frames);

		if (i == -1)
		{
			miss++;
			i = 0;
			if (algo == LFU)
				table[i]->freq = -1;
		}

		table[i]->mem_loc = mem_loc;
		table[i]->freq++;

		if (algo == LRU)
			reorder_lru(table, frames, i);
		else
			reorder_lfu(table, frames, i);
	}
	for (i = 0; i < frames; i++)
		free(table[i]);
	free(table);
	fclose(trace);

	printf("TLB misses: %d\n", miss);
}

page_t** generate_table(int frames, int i)
{
	page_t** table = (page_t**)malloc(sizeof(page_t*) * frames);
	for (; i < frames; i++)
	{
		table[i] = (page_t*)malloc(sizeof(page_t));
		table[i]->mem_loc = -1;
		table[i]->freq = -1;
	}
	return table;
}

int find(page_t** table, int mem_loc, int frames)
{
	int i = 0;
	for (; i < frames; i++)
		if (table[i]->mem_loc == mem_loc)
			return i;
	return -1;
}

void reorder_lru(page_t** table, int frames, int i)
{
	while (i < frames - 1)
		swap(table, i++);
}

void reorder_lfu(page_t** table, int frames, int i)
{
	if (i + 1 < frames && (table[i]->freq >= table[i + 1]->freq))
	{
		swap(table, i++);
		reorder_lfu(table, frames, i);
	}
}

void swap(page_t** table, int i)
{
	page_t* temp = table[i];
	table[i] = table[i + 1];
	table[i + 1]  = temp;
}