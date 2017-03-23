/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* process_input.c processes the users input into the shell, passes it to a
* tokenizer, and then passes the tokens obtained to the process_commands 
* function which will process and execute the commands.
*
******************************************************************************/

#include "process_input.h"

/******************************************************************************
* Processes the input and determine whether it is a user interface operation 
* or a set of commands that will need to be executed.
******************************************************************************/
void process_input(int super)
{

	/**************************************************************************
	* bool 			special_char 		determines whether the character to be 
	*									processed is special or not.
	* int 			len 				keeps track of the current line length
	* char 			line 				holds current line
	* d_linked_t 	history  			the head of the history doubly list
	* struct d_node history_scroll  	current history entery while scrolling
	**************************************************************************/
	bool special_char = FALSE;
	int status, len = 0;
	char ch, *line = (char*)malloc(MAX_LEN);
	d_linked_t history = {
		.d_head = NULL, 
		.d_tail = NULL, 
		.len = 0
	};
	struct d_node *history_scroll = NULL;

	/**************************************************************************
	* Loops until the user exits the program.
	**************************************************************************/
	print_user();
	while(1)
	{

		if (super)
			ch = getch();
		else
			ch = getchar();
			
		if (special_char)
			ch = switch_keypad(ch);

		special_char = FALSE;

		/**********************************************************************
		* switchs arround possible cases depending on the red character
		**********************************************************************/
		switch(ch)
		{
			case '[':
				special_char = TRUE;
				continue;
				break;

			case KEYLEFT:
			case KEYRIGHT:
			case '\t':
				break;

			case DELETE:
				if (len > 0) 
					delete(--len, line);
				break;

			/******************************************************************
			* if the character processed is the up arrow key, then the program
			* frees and discards the current line, allocates a new line, copies
			* the previes history line from the history list if it exits and
			* outputs it.
			******************************************************************/
			case KEYUP:
				if (history_scroll != NULL)
				{
					free(line);
					clear_line();

					line = (char*)malloc(MAX_LEN);
					len = strlen(history_scroll->string);
					memcpy(line, history_scroll->string, len);
					line[len] = '\0';

					printf("%s", line);

					if (history_scroll->prev != NULL)
						history_scroll = history_scroll->prev;
				}
				break;

			/******************************************************************
			* if the character processed is the down arrow key, then the 
			* program frees and discards the current line, allocates a new 
			* line, copies the next history line from the history list if it 
			* exits and outputs it.
			******************************************************************/
			case KEYDOWN:
				free(line);
				clear_line();

				line = (char*)malloc(MAX_LEN);
				len = 0;

				if (history_scroll != NULL && history_scroll->next != NULL)
				{	
					history_scroll = history_scroll->next;

					len = strlen(history_scroll->string);
					memcpy(line, history_scroll->string, len);
					line[len] = '\0';

					printf("%s", line);	
				}
				break;

			/******************************************************************
			* if the maximum line length is not exceeded the program will print
			* the character. if the character is not a new line then continue. 
			* Else, terminate line, pass it to the process_line methond,
			* allocate a new line, reset the line length, and rests the history
			* scroller value. 
			******************************************************************/
			default:
				if (len < MAX_LEN)
				{
					if (super)
						printf("%c", ch);

					if (ch != '\n')
						line[len++] = ch;

					else if (ch == '\n' && len > 0)
					{
						line[len] = '\0';
						if ((status = process_line(line, &history)) == -5
							|| status == 5)
						{
							clean_history(&history);
							free(line);
							if (status == 5)
							{
								system("stty sane");
								exit(5);
							}
							exit(0);
						}

						/******************************************************
						* frees the original line as its value has been copied 
						* to a new string to reserve memory.
						******************************************************/
						free(line);

						line = (char*)malloc(MAX_LEN);
						len = 0;

						history_scroll = history.d_tail; 

						print_user();
					}
				}
				else syslog(LOG_INFO, "Maxumum line size reached.\n");
				break;
		}
	}
}

/******************************************************************************
* process_line acts like a bridge between the tokenized commands and the
* commands interpreter. The method also adds all lines to the history of the 
* bash.
******************************************************************************/
short process_line(char* line, d_linked_t* history)
{
	short status = 1;
	int len = strlen(line), i, j;
	char ***commands;
	struct d_node *temp;

	/**************************************************************************
	* sends the commands to be processed and stores the result into commands
	**************************************************************************/
	if ((commands = tokenize(strcat(line, " "), len + 1)) == NULL)
	{
		syslog(LOG_INFO, "Syntax error\n");
		return -1; 
	}

	/**************************************************************************
	* sends the commands to the commands interpreter. If the commands is 
	* exit, then terminate, else, process the line and add it to the history.
	**************************************************************************/
	status = process_commands(0, commands, -1, -1, history);
	syslog(LOG_DEBUG, "process_commands return value: %d\n", status);

	if(status == 0 || status == 1)
	{
		/**********************************************************************
		* creates a temp d_node struct that will hold the line value in the 
		* history.
		**********************************************************************/
		temp = (struct d_node*)malloc(sizeof(struct d_node));
		temp->next = NULL;
		temp->string = (char*)malloc(len + 1);
		memcpy(temp->string, line, len);
		temp->string[len] = '\0'; 

		/**********************************************************************
		* creates a temp d_node struct that will hold the line value in the 
		* history.
		**********************************************************************/
		if (history->len == 0)
		{
			temp->prev = NULL;
			history->d_head = temp;
			history->d_tail = temp;
		}
		else
		{
			temp->prev = history->d_tail;
			history->d_tail->next = temp;
			history->d_tail = temp;
		}

		/**********************************************************************
		* Prints the history trace to the syslong, and increments the history
		* length
		**********************************************************************/
		syslog(LOG_DEBUG, "History trace - %d: %s\n", history->len++, 
			temp->string);
	}

	/**************************************************************************
	* clean up the commands array.
	**************************************************************************/
	for(i = 0; commands[i] != NULL; i++)
	{
		for(j = 0; commands[i][j] != NULL; j++)
			free(commands[i][j]);
		free(commands[i]);
	}
	free(commands);
	return status;
}