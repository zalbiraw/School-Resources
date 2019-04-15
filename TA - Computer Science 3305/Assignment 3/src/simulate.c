/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* simulate.c 
*
******************************************************************************/

#include "simulate.h"

int memory, max_memory, mode, time_quantum;
FILE *fp;
d_linked_list_t *jobs;
pthread_mutex_t memory_mutex = PTHREAD_MUTEX_INITIALIZER,
				jobs_mutex = PTHREAD_MUTEX_INITIALIZER;

void* run(void *j)
{
	job_t *job = get_next_job(mode, jobs);
	int number, required_memory;

	while (job != NULL)
	{

		number = job->number;
		required_memory = job->required_memory;

		/**********************************************************************
		* checks if the memory requested exceeds maximum memory
		**********************************************************************/
		if (required_memory > max_memory)
		{
			/******************************************************************
			* inform user that the job won't run, clean and terminate
			******************************************************************/
			print_exceed_memory(fp, number);
			free(job);
			return NULL;
		}

		/**********************************************************************
		* runs job
		**********************************************************************/
		pthread_mutex_lock(&memory_mutex);
		if (required_memory <= memory) execute_job(job);

		/**********************************************************************
		* checks if the memory requested exceeds current available memory
		**********************************************************************/
		else 
		{
			/******************************************************************
			* inform user that the job doesn't have enough resources at the 
			* moment, add the job back to the list
			******************************************************************/
			print_insufficient_memory(fp, number);
			
			pthread_mutex_lock(&jobs_mutex);
			enqueue(jobs, job);
			pthread_mutex_unlock(&jobs_mutex);
		}
		pthread_mutex_unlock(&memory_mutex);

		pthread_mutex_lock(&jobs_mutex);
		job = get_next_job(mode, jobs);
		pthread_mutex_unlock(&jobs_mutex);

	}

	return NULL;
}

/******************************************************************************
* 
******************************************************************************/
void simulate(int memory_value, int mode_value, int time_quantum_value,
	d_linked_list_t *list)
{
	/**************************************************************************
	* opens output file
	**************************************************************************/
	fp = fopen(SYSTEM_OUTPUT, WRITE);

	/**************************************************************************
	* check if the system file is in the directory
	**************************************************************************/
	if (fp == NULL)
	{
		printf("Unable to open %s file\n", SYSTEM_OUTPUT);
		exit(FAILURE);
	}

	/**************************************************************************
	* set global variables
	**************************************************************************/
	memory = max_memory = memory_value;

	/**************************************************************************
	* set executing mode
	**************************************************************************/
	mode = mode_value;
	time_quantum = time_quantum_value;
	print_mode(fp, mode);
	jobs = list;

	/**************************************************************************
	* create threads and run jobs
	**************************************************************************/
	pthread_t threads[NUMBER_OF_THREADS];
	for (int i = 0; i < NUMBER_OF_THREADS; ++i)
	{
		if (pthread_create(&threads[i], NULL, run, NULL))
		{
			printf("Error: failed to create thread.\n");
			exit(FAILURE);
		}
	}

	/**********************************************************************
	* wait for the jobs to finish executing
	**********************************************************************/
	for (int i = 0; i < NUMBER_OF_THREADS; ++i)
		pthread_join(threads[i], NULL);
}

void execute_job(job_t *job) {
	int number = job->number,
		required_memory = job->required_memory,
		required_time = job->required_time,
		time = mode == RR ? time_quantum : required_time;

	/******************************************************************
	* inform user that the job started executing and allocate mrmory
	******************************************************************/
	print_starting(fp, number);
	allocate_memory(required_memory);
	pthread_mutex_unlock(&memory_mutex);

	/******************************************************************
	* run the job
	******************************************************************/
	sleep(time >= required_time ? required_time : time);

	required_time -= time;

	/******************************************************************
	* inform user that the job finished executing
	******************************************************************/
	if (required_time < 1)
	{
		print_completed(fp, number);
		free(job);
	}

	/******************************************************************
	* put the job back in queue if it didn't finish
	******************************************************************/
	else 
	{
		pthread_mutex_lock(&jobs_mutex);
		job->required_time = required_time;
		pthread_mutex_unlock(&jobs_mutex);
		enqueue(jobs, job);
	}

	/******************************************************************
	* deallocate memory
	******************************************************************/
	pthread_mutex_lock(&memory_mutex);
	deallocate_memory(required_memory);
}

void allocate_memory(int r) {
	memory -= r;
	print_allocate_memory(fp, memory, r);
}

void deallocate_memory(int r) {
	memory += r;
	print_deallocate_memory(fp, memory, r);
}
