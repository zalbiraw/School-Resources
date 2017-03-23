/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* process_commands.h 
*
******************************************************************************/

#ifndef PROCESS_COMMANDS_H
#define PROCESS_COMMANDS_H

#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <stdbool.h>

#include "linked_list.h"
#include "linked_doubly_list.h"
#include "helper.h"

#define ON 1
#define OFF 0
#define TRUE 1
#define FALSE 0

short process_commands(int, char***, int, int, d_linked_t*);
short exe_command(int, char***, d_linked_t*);
int redirect(int, char***);

#endif