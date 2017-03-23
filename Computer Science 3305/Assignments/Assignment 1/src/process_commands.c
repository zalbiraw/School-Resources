/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* process_commands.c 
*
******************************************************************************/

#include "process_commands.h"

/******************************************************************************
* process the given commands
******************************************************************************/
short process_commands(int i, char ***argv, int prev_pid, int in
	, d_linked_t *history)
{	
	int status, fd[2];
	pid_t pid;

	/**************************************************************************
	* Creates a new pipe if the program needs it. 
	**************************************************************************/
	if (argv[i + 1] != NULL && pipe(fd) < 0)
		return exe_command_errs(ERR_PIPE);

	/**************************************************************************
	* Forks the process
	**************************************************************************/
	switch(pid = fork())
	{
		case -1:
		return exe_command_errs(ERR_FORK);

		/**********************************************************************
		* Hnadles the child process
		**********************************************************************/
		case 0:

		/**********************************************************************
		* If the previous child flag is not -1, then set the stdin to the 
		* output of that child
		**********************************************************************/
		if (prev_pid != -1)
			if (dup2(in, STDIN_FILENO) < 0)
				return exe_command_errs(ERR_DUP);
		
		/**********************************************************************
		* If this is not the last sub-command, then dup the stdout to the pipe
		**********************************************************************/
		if(argv[i + 1] != NULL)
		{
			close(fd[0]);
			if (dup2(fd[1], STDOUT_FILENO) < 0)
				return exe_command_errs(ERR_DUP);
		}

		/**********************************************************************
		* execute the command
		**********************************************************************/
		return exe_command(i, argv, history);

		/**********************************************************************
		* Handles the parent process
		**********************************************************************/
		default:

		/**********************************************************************
		* Waits on the child to finish executing
		**********************************************************************/
		wait(&status);
		if (argv[i + 1] == NULL)
		{
			/******************************************************************
			* If the exit value was 1, then that means that the process exited
			* by the exit command, therefore, terminate
			******************************************************************/
			syslog(LOG_DEBUG, "Status: %d\n", status);
			if(status == 1280) return 5;
			else return status;
		}
		
		/**********************************************************************
		* Close the output pipe and execute the method recursively with the 
		* next sub-command
		**********************************************************************/
		close(fd[1]);
		return process_commands(i + 1, argv, pid, fd[0], history);
	}
}

/******************************************************************************
* executes the sub-commands
******************************************************************************/
short exe_command(int i, char*** argv, d_linked_t *history)
{
	/**************************************************************************
	* checks if the command is an exit command and exectues it
	**************************************************************************/
	if (strcmp(argv[i][0], "exit") == 0)
	{
		syslog(LOG_INFO, "[ZASH: Process Completed]\n");
		return 5;
	}

	/**************************************************************************
	* checks if the command is a history command and executes the 
	* history_handler
	**************************************************************************/
	else if (strcmp(argv[i][0], "history") == 0)
		return history_handler(argv[0], history);

	/**************************************************************************
	* executes the command
	**************************************************************************/
	else 
		execvp(argv[i][0], argv[i]);
		syslog(LOG_INFO, "-zash: %s: command not found\n", argv[i][0]);
		return -5;	
}