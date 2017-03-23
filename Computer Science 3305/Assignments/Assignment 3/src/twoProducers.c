#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#include <unistd.h>

#define T int
T *buffer_a, *buffer_b;
sem_t empty_a, full_a, empty_b, full_b, mutex_a, mutex_b;

void *producer_a(void*);
void *producer_b(void*);
void *consumer(void*);

int main (int argc, char **argv)
{
	int buffer_a_size, buffer_b_size, num_items_a, num_items_b, ctr;
	if (argc < 5)
	{
		printf("Please enter the buffer sizes of the buffers " 
			"associated with the producers and the number of "
			"items produced by each of the producers\n");

		exit(EXIT_FAILURE);
	}
	else
	{
		buffer_a_size = atoi(argv[1]);
		buffer_b_size = atoi(argv[2]);
		num_items_a = atoi(argv[3]);
		num_items_b = atoi(argv[4]);

		if(buffer_a_size < 1 || buffer_b_size < 1)
		{
			printf("Buffer size must be greater than 0.\n");
			exit(EXIT_FAILURE);
		}
			
		ctr = num_items_a + num_items_b;
	}

	pthread_t a, b, consumer_thread;

	sem_init(&empty_a, 0, buffer_a_size);
	sem_init(&full_a, 0, 0);
	sem_init(&empty_b, 0, buffer_b_size);
	sem_init(&full_b, 0, 0);

	sem_init(&mutex_a, 0, 1);
	sem_init(&mutex_b, 0, 1);

	buffer_a = (T*)malloc(buffer_a_size * sizeof(T));
	buffer_b = (T*)malloc(buffer_b_size * sizeof(T));

 	if(pthread_create(&a, NULL, producer_a, (void*)&num_items_a))
 	{
        perror("Error - pthread_create()\n");
        exit(EXIT_FAILURE);
    }

    if(pthread_create(&b, NULL, producer_b, (void*)&num_items_b))
 	{
        perror("Error - pthread_create()\n");
        exit(EXIT_FAILURE);
    }

    if(pthread_create(&consumer_thread, NULL, consumer,(void*)&ctr))
 	{
        perror("Error - pthread_create()\n");
        exit(EXIT_FAILURE);
    }

    pthread_join(a, NULL);
	pthread_join(b, NULL);
	pthread_join(consumer_thread, NULL);

	sem_destroy(&empty_a);
	sem_destroy(&full_a);
	sem_destroy(&empty_b);
	sem_destroy(&full_b);
	sem_destroy(&mutex_a);
	sem_destroy(&mutex_b);

	free(buffer_a);
	free(buffer_b);

	return EXIT_SUCCESS;
}

void *producer_a(void *ptr)
{
	int i = 0, ctr = *(int*)ptr;
	while(i < ctr)
	{
		sem_wait(&empty_a);
		sem_wait(&mutex_a);
		printf("producer 1 has put an item in its buffer\n");
		buffer_a[i] = i;
		i++;
		sem_post(&mutex_a);
		sem_post(&full_a);
	}
	return NULL;
}

void *producer_b(void *ptr)
{
	int i = 0, ctr = *(int*)ptr;
	while(i < ctr)
	{
		sem_wait(&empty_b);
		sem_wait(&mutex_b);
		printf("producer 2 has put an item in its buffer\n");
		buffer_b[i] = i;
		i++;
		sem_post(&mutex_b);
		sem_post(&full_b);
	}
	return NULL;
}

void *consumer(void *ptr)
{
	int a = 0, b = 0, value, ctr = *(int*)ptr;
	while(ctr)
	{
		sem_getvalue(&full_a, &value);
		if (value > 0)
		{
			sem_wait(&full_a);
			sem_wait(&mutex_a);
			ctr--;
			printf("Consumer has consumed an item(%d) from producer1\n"
				, buffer_a[a++]);
			sem_post(&mutex_a);
			sem_post(&empty_a);
		}

		sem_getvalue(&full_b, &value);
		if (value > 0)
		{
			sem_wait(&full_b);
			sem_wait(&mutex_b);
			ctr--;
			printf("Consumer has consumed an item(%d) from producer2\n"
				, buffer_b[b++]);
			sem_post(&mutex_b);
			sem_post(&empty_b);
		}
	}
	return NULL;
}