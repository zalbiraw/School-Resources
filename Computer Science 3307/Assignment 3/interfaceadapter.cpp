#include <iostream>
#include <stdio.h>

#define INIT 0
#define ADD 1
#define REMOVE 2
#define CLONE 3
#define READD 4
#define COMMIT 5
#define PUSH 6
#define PULL 7

using namespace std;

void adapter(int, string);
void interfaceToBash(int, string);
void bashToInterface(int, string);

int main() {
	adapter(INIT, "");
	adapter(READD, "repo");
	adapter(ADD, " .");
	adapter(COMMIT, "SAAD");
	adapter(PUSH, "SAAD");
	adapter(REMOVE, "SAAD");
	adapter(PULL, "SAAD");
	return 0; 	
}

void adapter(int op, string arg)
{
	interfaceToBash(op, arg);
	bashToInterface(op, arg);
}

void interfaceToBash(int op, string arg)
{
	switch(op)
	{
		case INIT:
			cout << "git init " << arg << endl;
			break;
		case ADD:
			cout << "git add " << arg << endl;
			break;
		case REMOVE:
			cout << "git rm " << arg << endl;
			break;
		case CLONE:
			cout << "git clone " << arg << endl;
			break;
		case READD:
			cout << "git remote add " << arg << endl;
			break;
		case COMMIT:
			cout << "git commit -m \"" << arg << "\"" << endl;
			break;
		case PUSH:
			cout << "git push " << arg << endl;
			break;
		case PULL:
			cout << "git pull " << arg << endl;
			break; 
	}
}

void bashToInterface(int op, string arg)
{
	switch(op)
	{
		case INIT:
			cout << "Repository has been initialized." << endl;
			break;
		case ADD:
			cout << "File " << arg << " has been added." << endl;
			break;
		case REMOVE:
			cout << "File " << arg << " has been removed." << endl;
			break;
		case CLONE:
			cout << "Repository " << arg << " has been cloned." << endl;
			break;
		case READD:
			cout << "Remote repository " << arg << " has been added." << endl;
			break;
		case COMMIT:
			cout << "Commit " << arg << " has been submitted." << endl;
			break;
		case PUSH:
			cout << "Commit has been pushed." << endl;
			break;
		case PULL:
			cout << "Commit has been pulled." << endl;
			break; 
	}
}