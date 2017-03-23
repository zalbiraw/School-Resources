#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

void *op(void*);
sem_t **mutexes;

struct info
{
	int i;
	int ctr;
	int num_threads;
};

int main (int argc, char **argv)
{
	int i, ctr, num_threads;
	if (argc < 3)
	{
		printf("Please enter the number of times that the threads"
			" execute their operation and the number of threads.\n");

		exit(EXIT_FAILURE);
	}
	else
	{
		ctr = atoi(argv[1]);
		num_threads = atoi(argv[2]);
	}
		
	mutexes = (sem_t**)malloc(num_threads * sizeof(sem_t*));
	for (i = 0; i < num_threads; i++)
		mutexes[i] = (sem_t*)malloc(sizeof(sem_t));

	sem_init(mutexes[0], 0, 0);
	for (i = 1; i < num_threads; i++)
		sem_init(mutexes[i], 0, -1);

	pthread_t threads[num_threads];
	struct info *threads_info[num_threads];
 	for(i = 0; i < num_threads; i++)
 	{ 
 		threads_info[i] = (struct info*)malloc(sizeof(struct info));

 		threads_info[i]->i = i;
 		threads_info[i]->ctr = ctr;
 		threads_info[i]->num_threads = num_threads;

 		if(pthread_create(&threads[i], NULL, op, (void*)threads_info[i]))
	 	{
	        perror("Error - pthread_create()\n");
	        exit(EXIT_FAILURE);
	    }
 	}

 	for(i = 0; i < num_threads; i++)
 	{
 		pthread_join(threads[i], NULL);
		sem_destroy(mutexes[i]);
		free(mutexes[i]);
		free(threads_info[i]);
	}
	free(mutexes);

	return EXIT_SUCCESS;
}

void *op(void *ptr)
{
	struct info *thread_info = (struct info*)ptr;
	int i = thread_info->i, ctr = thread_info->ctr
		, num_threads = thread_info->num_threads;

	if (i)
		sem_wait(mutexes[i]);

	while(ctr)
	{
		ctr--;
		printf("Thread %d executing op\n", i);

		if (i + 1 == num_threads)
			sem_post(mutexes[0]);
		else
			sem_post(mutexes[i + 1]);

		sem_wait(mutexes[i]);
	}
	if (i + 1 == num_threads)
		sem_post(mutexes[0]);
	else
		sem_post(mutexes[i + 1]);

	return NULL;
}
