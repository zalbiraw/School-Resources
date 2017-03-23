#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

void *opA(void*);
void *opB(void*);
sem_t mutex_a, mutex_b;

#define TRUE 1
#define FLASE 0

int first = TRUE;

int main (int argc, char **argv)
{
	int ctr;
	if (argc < 2)
	{
		printf("Please enter the number of times that thread A"
			" and thread B execute their operations\n");

		exit(EXIT_FAILURE);
	}
	else
		ctr = atoi(argv[1]);

	sem_init(&mutex_a, 0, -1);
	sem_init(&mutex_b, 0, -1);

	pthread_t a, b;
 	if(pthread_create(&a, NULL, opA, (void*)&ctr))
 	{
        perror("Error - pthread_create()\n");
        exit(EXIT_FAILURE);
    }

    if(pthread_create(&b, NULL, opB, (void*)&ctr))
 	{
        perror("Error - pthread_create()\n");
        exit(EXIT_FAILURE);
    }

	pthread_join(a, NULL);
	pthread_join(b, NULL);

	sem_destroy(&mutex_a);
	sem_destroy(&mutex_b);

	return EXIT_SUCCESS;
}

void *opA(void *ptr)
{
	int ctr = *(int*)ptr;

	if (!first)
		sem_wait(&mutex_a);
	else
		first = FLASE;

	while(ctr)
	{
		ctr--;
		printf("Thread A executing opA\n");
		sem_post(&mutex_b);
		sem_wait(&mutex_a);
	}
	sem_post(&mutex_b);
	return NULL;
}

void *opB(void* ptr)
{
	int ctr = *(int*)ptr;

	if (!first)
		sem_wait(&mutex_b);
	else
		first = FLASE;

	while(ctr)
	{
		ctr--;
		printf("Thread A executing opB\n");
		sem_post(&mutex_a);
		sem_wait(&mutex_b);
	}
	sem_post(&mutex_a);
	return NULL;
}