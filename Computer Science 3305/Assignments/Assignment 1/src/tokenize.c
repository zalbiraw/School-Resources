/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* tokenize.c tokenizes the input lines. sperates commands by '<' '|' '>' '<<' 
* '||' '>>' 
*
******************************************************************************/

#include "tokenize.h"

char*** tokenize(char* input, int len)
{
	/**************************************************************************
	* bool 		next_command				is set to true when the program
	*										starts processeing the next commnad
	* bool 		operator 					is set to true when the last
	* 										processed token is an operator
	* char* 	breaker 					the character that holds the value
	* 										of the operator
	* char* 	op 							holds the value of the operator
	* int 		num_commands 				counter for the number of ints
	* struct s_linked* tokens_head			tokens linked list
	* struct i_linked* sub_commands_head 	commands linked list
	**************************************************************************/
	bool next_command = FALSE, operator = TRUE, redirect_in = FALSE
		, redirect_out = FALSE, fail = FALSE, flip = FALSE, quotation = FALSE;
	char *breaker;
	int i, j = 0, num_commands = 1, operator_len, next;

	struct s_linked *tokens_head = 
		(struct s_linked*)malloc(sizeof(struct s_linked));

	struct i_linked *sub_commands_head = 
		(struct i_linked*)malloc(sizeof(struct i_linked));

	struct s_linked *tokens = tokens_head, *tokens_clean;
	struct i_linked *sub_commands = sub_commands_head, *sub_commands_clean;

	/**************************************************************************
	* Makes a copy of the input line. The program will then be able to make 
	* changes freely.
	**************************************************************************/
	char line[strlen(input)];
	memcpy(line, input, strlen(input));

	/**************************************************************************
	* sets the initial commands' tokens number to zero
	**************************************************************************/
	sub_commands_head->value = 0;

	/**************************************************************************
	* Iterates through the line and tokenizes the input
	**************************************************************************/
	for (i = 0; i < len; i++)
	{
		/**********************************************************************
		* Checks if the current character is a command terminator character
		**********************************************************************/
		if ((breaker = strchr("<>|", line[i])) != NULL)
		{
			/******************************************************************
			* Returns NULL if the previously processed token is an operator
			******************************************************************/
			if (operator)
				fail = TRUE;

			/******************************************************************
			* Sets the value of op to the current operator
			******************************************************************/
			switch(*breaker)
			{
				case '<':
					redirect_in = TRUE;
					break;
				case '>':
					redirect_out = TRUE;
			}

			/******************************************************************
			* replaces the sepcial character with a ' '
			******************************************************************/
			line[i] = ' ';
			operator = TRUE;
			next_command = TRUE;
			next = i;
		}

		if (line[i] == '\"')
		{
			line[i] = ' ';
			if (quotation)
				quotation = FALSE;
			else
				quotation = TRUE;
		}

		/**********************************************************************
		* Looks for the start of a token
		**********************************************************************/
		if (line[i] != ' ' && !j)
		{
			operator = FALSE;
			j = i + 1;
		}

		/**********************************************************************
		* Creates the tokens
		**********************************************************************/
		else if (line[i] == ' ' && j && !quotation)
		{
			tokens->string = (char*)malloc(i - j + 2);
			memcpy(tokens->string, line + j - 1, i - j + 1);
			tokens->string[i - j + 1] = '\0';

			tokens = s_init_next(tokens);
			j = FALSE;
			sub_commands->value++;
		}

		if(next < i && (redirect_out || redirect_in))
		{
			tokens->string = (char*)malloc(10);
			if (redirect_out)
			{
				redirect_out = FALSE;
				memcpy(tokens->string, "redirect>", 9);
			}
			else
			{
				redirect_in = FALSE;
				memcpy(tokens->string, "redirect<", 9);
			}

			tokens->string[9] = '\0';
			tokens = s_init_next(tokens);
			sub_commands->value++;	
		}

		/**********************************************************************
		* If the next command flag is set, then increment the number of 
		* commands and generate the next sub_commands node
		**********************************************************************/
		if(next_command)
		{
			next_command = FALSE;
			sub_commands = i_init_next(sub_commands);
			num_commands++;
			sub_commands->value = 0;
		}
	}

	if (operator || quotation)
		fail = TRUE;

	/**************************************************************************
	* char** 	command 	will hold the diffrent sub-commands
	* char*** 	commands 	will holld all the commands and their operators
	**************************************************************************/
	char check;
	char** command;
	char*** commands = (char***)malloc(sizeof(char**) * (num_commands + 1));
	
	tokens = tokens_head;
	sub_commands = sub_commands_head;

	/**************************************************************************
	* Iterates through sub_commands linked lists and generates a tokenized
	* commands array
	**************************************************************************/
	for (i = 0; i < num_commands; i++)
	{
		/**********************************************************************
		* Creates a char** that will hold all the tokens for the current 
		* command
		**********************************************************************/
		command = (char**)malloc(sizeof(char*) * (sub_commands->value + 1));

		/**********************************************************************
		* Iternates through the tokens linked list to add the tokens to the 
		* current command
		**********************************************************************/
		for(j = 0; j < sub_commands->value; j++)
		{
			/******************************************************************
			* Links the token to the command's token list
			******************************************************************/

			check = tokens->string[8];
			if(check == '<' || check == '>')
			{
				free(tokens->string);
				tokens->string = (char*)malloc(4);

				if(check == '>')
					memcpy(tokens->string, "tee", 3);
				else
				{
					flip = TRUE;
					memcpy(tokens->string, "cat", 3);
				}

				tokens->string[3] = '\0';
			}

			command[j] = tokens->string;
			syslog(LOG_DEBUG, "Token processed(%d/%d): %s\n", j + 1
				, sub_commands->value, command[j]);	

			tokens_clean = tokens;
			tokens = tokens->next;
			free(tokens_clean);
		}
		if (i < num_commands - 1)
			syslog(LOG_DEBUG, "Pipe(%d/%d)\n", i + 1 , num_commands - 1);
		/**********************************************************************
		* Sets the last token of commad to NULL and links the it to the 
		* commands array
		**********************************************************************/
		command[j] = NULL;

		if (flip)
		{
			flip = FALSE;
			commands[i] = commands[i - 1];
			commands[i - 1] = command;
			syslog(LOG_DEBUG, "Commands flipped.\n");
		}
		else
			commands[i] = command;


		/**********************************************************************
		* Cleans the sub_commands linked list
		**********************************************************************/
		sub_commands_clean = sub_commands;
		sub_commands = sub_commands->next;
		free(sub_commands_clean);
	}
	/**************************************************************************
	* frees the dangling tokens linked list object
	**************************************************************************/
	free(tokens);

	/**************************************************************************
	* terminates the commands array with NULL item at the end of it.
	**************************************************************************/
	commands[i] = NULL;
	if (fail)
	{
		for(i = 0; commands[i] != NULL; i++)
		{
			for(j = 0; commands[i][j] != NULL; j++)
				free(commands[i][j]);
			free(commands[i]);
		}
		free(commands);
		return NULL;
	}
	return commands;
}