/* Program to compute Pi using Monte Carlo methods */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/time.h>
#include <unistd.h>
#include <errno.h>
#include <math.h>
#include <sched.h>

#define SEED 35791246

double computeElapsedTime(struct timeval start_time, struct timeval finish_time)
{
  double start_count, end_count, elapsed_time;

  start_count =
     (double)start_time.tv_sec+1.e-6*(double)start_time.tv_usec;
  end_count =
     (double)finish_time.tv_sec+1.e-6*(double)finish_time.tv_usec;

  elapsed_time = (end_count - start_count);

  return elapsed_time;
}

void pi(int niter)
{
   double x,y;
   int i,count=0; /* # of points in the 1st quadrant of unit circle */
   double z;
   double pi;
   /* initialize random numbers */
   srand(SEED);
   count=0;
   for ( i=0; i<niter; i++) {
      x = (double)rand()/RAND_MAX;
      y = (double)rand()/RAND_MAX;
      z = x*x+y*y;
      if (z<=1) count++;
      }
   pi=(double)count/niter*4;
   printf("# of trials= %d , estimate of pi is %g \n",niter,pi);
}

int main(int argc, char **argv)
{
   int niter, childs, i, policy;
   double elapsed_time;
   struct sched_param param;
   struct timeval start_time,finish_time;
   
   if (argc != 3){
     perror("incorrect arguments");
     exit(0);
   }

   niter = atoi(argv[1]);
   childs = atoi(argv[2]);

   for (i = 0; i < childs; i++)
   {
      int pid = fork();

      if (pid < 0)
         perror("fork()");

      if (pid == 0)
      {
         if (i%2 == 0)
         {
            printf("\npolicy: SCHED_FIFO, ");
            policy = SCHED_FIFO;
         }
         else
         {
            printf("\npolicy: SCHED_OTHER, ");
            policy = SCHED_OTHER;
         }

         param.sched_priority = sched_get_priority_max(policy);
         if(sched_setscheduler(0,policy,&param))
         {
            perror("Error setting scheduler policy");
            exit(EXIT_FAILURE);
         }

         gettimeofday(&start_time,NULL);
         pi(niter);
         gettimeofday(&finish_time,NULL);
         elapsed_time = computeElapsedTime(start_time,finish_time);
         printf("child %d has taken %f seconds to compute pi\n", i, elapsed_time);
         return 0;
      }
   }
   return 0;
}




  
 

  


  
  
  

