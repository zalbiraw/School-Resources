/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* helper.c contains all the helper methods for zash
*
******************************************************************************/

#include "helper.h"


/******************************************************************************
* prints the device's username
******************************************************************************/
void print_user()
{
	printf("%s> ", getenv("USER"));
}

/******************************************************************************
* activates noecho terminal mode
******************************************************************************/
void noecho() 
{
	system("stty -echo");
  	system("stty -icanon");
}

char getch()
{
	noecho();
  	char ch = getchar();
  	system("stty sane");
  	return ch;
}

/******************************************************************************
* deletes the current character.
******************************************************************************/
void delete(int len, char* line)
{
	line[len] = '\0';
	printf("\b \b");
}

/******************************************************************************
* clears the current line
******************************************************************************/
void clear_line()
{
	printf("\r");
	printf("%c[2K", 27);
	print_user();
}

/******************************************************************************
* Determines which special character is processed.
******************************************************************************/
char switch_keypad(char ch)
{
	switch(ch)
	{
		case 'A': return KEYUP;
		case 'B': return KEYDOWN;
		case 'C': return KEYRIGHT;
		case 'D': return KEYLEFT;
		default:  return ch;
	}
}

/******************************************************************************
* checks if the input for the history function is a number and returns that
* number if it is.
******************************************************************************/
int isNumber(char* n)
{
	int i, j = 0, number = 0;
	for(i = strlen(n) - 1; i > -1; i--)
	{
		if (strchr("0123456789", n[i]) == NULL)
			return -1;
		else
			number += (n[i]-48)*pow(10, j++);
	}
	return number;
}

/******************************************************************************
* prints the history trail 
******************************************************************************/
short history_handler(char** argv, d_linked_t *history)
{
	int print_len = 10, i;
	struct d_node *h_node;

	if (argv[1] != NULL && (i = isNumber(argv[1])) > 0)
		print_len = i;

	h_node = history->d_tail;
	for (i = 1; h_node->prev != NULL && i < print_len; h_node = h_node->prev)
		i++;

	for ( ; h_node != NULL; h_node = h_node->next)
		fprintf(stdout, "%d\t%s\n", history->len - --i, h_node->string);

	return -5;
}

/******************************************************************************
* frees all the strings in the history.
******************************************************************************/
void clean_history(d_linked_t *history)
{
	int i;
	struct d_node *node = history->d_head, *temp;
	for (i = 0; i < history->len; i++)
	{
		temp = node;
		node = node->next;
		free(temp->string);
		free(temp);
	}
}

/******************************************************************************
* prints the error commands 
******************************************************************************/
int exe_command_errs(int error)
{
	switch(error)
	{
		case ERR_FORK:
			syslog(LOG_INFO, "Error: failed to fork.\n");
			break;

		case ERR_PIPE:
			syslog(LOG_INFO, "Error: failed to create a pipe.\n");
			break;

		case ERR_DUP:
			syslog(LOG_INFO, "Error: failed to dup.\n");
			break;
	}
	return -2;
}