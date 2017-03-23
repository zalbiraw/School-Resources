/******************************************************************************
* 
* Name: 	Zaid Albirawi
* Email: 	zalbiraw@uwo.ca
*
* zash.c contains the main function for ZASH. Zaid Albirawi Shell.
*
******************************************************************************/

#include "shell.h"

/******************************************************************************
* Main function.
******************************************************************************/
int main(int argc, char** argv)
{
	int super = 0;
	set_envo(argc, argv, &super);
	process_input(super);
	return 0;
}

/******************************************************************************
* Proccesses the arguments of the program and sets the syslog mask.
******************************************************************************/
void set_envo(int argc, char** argv, int* super)
{
	int opt, option_index = 0;

    static struct option long_options[] =
	{
		{"debug", 	optional_argument, 0, 'd'},
		{"super", 	optional_argument, 0, 's'},
		{0, 0, 0, 0}
	};

	/**************************************************************************
	* Opens the syslog stream and sets its mask to the default value, log info.
	**************************************************************************/
	openlog("ZASH", LOG_PERROR | LOG_PID | LOG_NDELAY, LOG_USER);
    setlogmask(LOG_UPTO(LOG_INFO));

	/**************************************************************************
	* Proccesses the arguments of the program.
	**************************************************************************/
	while((opt = getopt_long(argc, argv, "::s::d", long_options
		, &option_index)) != -1)
		switch (opt)
		{
			case 'd':
				setlogmask(LOG_UPTO(LOG_DEBUG));
				syslog(LOG_DEBUG, "Debug mode enabled.\n");
				break;

			case 's':
				/**************************************************************
				* disables character echoing in the terminal settings
				**************************************************************/
				*super = 1;
		}
}