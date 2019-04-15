/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* scheduler.c 
*
******************************************************************************/

#include "scheduler.h"

job_t *get_next_job(int mode, d_linked_list_t* jobs) {
	job_t *j;

	switch(mode)
	{
		case SJF:
		{
			struct d_node *n, *node;
			job_t *job;
			int lowest, required_time; 

			n = node = jobs->head;

			/******************************************************************
			* Return NULL if no more jobs
			******************************************************************/
			j = (node != NULL ? (job_t*)node->value : NULL);
			if (j == NULL) return j;

			/******************************************************************
			* Linearly search for job with lowest time (lazy solution)
			******************************************************************/
			lowest = j->required_time;
			for (; node != NULL; node = node->next)
			{
				job = (job_t*)node->value;
				required_time = job->required_time;
				
				if (required_time < lowest)
				{
					lowest = required_time;
					j = job;
					n = node;
				}
			} 

			/******************************************************************
			* Remove the job from linked list
			******************************************************************/
			erase(jobs, n);

		} break;
		
		case FCFS:
		case RR:
			j = (job_t*)dequeue(jobs);
			break;

		case LIFO:
			j = (job_t*)pop(jobs);
			break;
	}

	return j;
}
