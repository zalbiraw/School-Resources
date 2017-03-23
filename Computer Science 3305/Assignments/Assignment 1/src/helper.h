/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* helper.h
*
******************************************************************************/

#ifndef HELPER_H
#define HELPER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <syslog.h>
#include <math.h>

#include "linked_doubly_list.h"

#define MAX_LEN 1024

#define ERR_FORK 10
#define ERR_PIPE 11
#define ERR_DUP	12

#define DELETE 127
#define KEYLEFT 4
#define KEYRIGHT 5
#define KEYUP 3
#define KEYDOWN 2

void print_user();
void noecho();
void delete(int, char*);
void clear_line();
char switch_keypad(char);
int isNumber(char*);
short history_handler(char**, d_linked_t*);
void clean_history(d_linked_t*);
int exe_command_errs(int);

char getch();

#endif