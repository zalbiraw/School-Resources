//============================================================================
// Name        : 3307Assignment1.cpp
// Author      : Zaid Albirawi / Valmir Verbani
//============================================================================

#include <iostream>
#include <vector>
#include <math.h>
#include <time.h>
#include <fstream>
#include <sstream>
#include "User.h"
#include "Client.h"
#include "Account.h"

using namespace std;

/*
* attributes and objects that will be used
*/ 
vector<Client> clients;
bool trace = false, convert, decimal = false, closeAcc=false;
int finder, power;
string usr, pswd, type, temp;
double value;
ostringstream outTrace;
User admin = User("manager", "password",0);
User maint = User("maintainer", "password",1);
ofstream outFile;

/*
*initializing all the methods in this file
*/
void saveClients();
void loadClients();
bool find (vector<Client>, string);
void logIn(int);
void manager(int);
void maintainer (int option);
void client (int);
void manage(Account*);
bool valid(string, int, int);
double stod(string);
double stodHelper(string, int);
bool initSaving();
bool initChecking();
bool choiceHelper(string);
void invalid(int);
void manageOptions();
void logger (int);
string getTime();
bool trans(Account*);
bool exit(string);


int main() {
	/*
	*start by loading the clients information that was previous saved
	*/
	loadClients();
	cout << "Welcome to Western Banking. Please insert your Username and Password to proceed." << endl;

	
	while (1){
		/*
		*ask the user for username and password or 'exit' to exit the program
		*/
		cout <<"Username: ";
		cin >> usr;
		if (usr == "exit") break;
		cout << "Password: ";
		cin >> pswd;
		/*
		* check the entered username and password to see if they are correct
		* keeps asking until the correct information is entered or if the user types in 'exit'
		*/
		if (usr=="manager" && pswd==admin.getPswd()) logIn(0);
		else if (usr=="maintainer" && pswd==maint.getPswd())logIn(1);
		else if (!find(clients, usr) || clients[finder].getPswd()!=pswd)
			cout << "You have entered invalid login information, please try again.\n" << endl;
		else logIn(2);

		cout << "Please type \"exit\" to exit the program." << endl;
	}
	/*
	* end the function by saving/ resaving the clients new or updated information
	*/ 
	saveClients();
	return 0;
}

/*
* The save function saves the clients information onto an external file , 'clientList.txt'
* It stores the clients username, password, saving account balance and/or chequing account balance
* 'End Of Users' is also written on the file to know that the end of the file is reached 
* Then the text file is closed
*/
void saveClients(){
	outFile.open("clientList.txt");
	for(int i = 0 ; i < clients.size(); i++)
	{
		outFile << clients[i].getName() << endl;
		outFile << clients[i].getPswd() << endl;
		outFile << (clients[i].hasSaving() ? clients[i].getSaving()->getBalance() : -1) << endl;
		outFile << (clients[i].hasChecking() ? clients[i].getChecking()->getBalance() : -1) << endl;
	}outFile << "END OF USERS" << endl;
	if (trace) outFile << "ON" << endl;
	outFile << outTrace.str();
	outFile.flush();
	outFile.close();
} 
/*
*   The load function works similar to the save function but it instead reads the 'clientList.txt' file information.
*	It first checks if 'End of Users' is reached to identify that the end of filed is reached.
* 	If it reached, then the trace is turned on to record what has happened.
*	It reads the first two lines, which are username and password under our 'temp' client.
*	The next two lines read are the saving and/or chequing balances, which are also loaded onto the 'temp' client.
*/
void loadClients(){
	ifstream file;
	string line, user, password;
	bool eou = false;
	file.open("clientList.txt", ios::in);
	if(file.is_open()) {
		while(getline(file, line)) {
			if(line == "END OF USERS") {
				eou = true;
				getline(file, line);
				if (line == "ON") {
					trace = true;
					getline(file, line);
				}
			} if (!eou){
				user = line;
				getline(file, line);
				password = line; 
				Client temp = Client(user,password,2);

				getline(file, line);
				if(line != "-1")
				{
					temp.addSaving();
					temp.getSaving()->deposit(stod(line));
				}
				getline(file, line);
				if(line != "-1")
				{
					temp.addChecking();
					temp.getChecking()->deposit(stod(line));
				} clients.push_back(temp);
			} else 	outTrace << line << endl;
		}
	}
}

/*
*	The find method checks whether a client is in the bank or not, true if the client is and false otherwise. 
*@param Vector<Client>  A vector that contains the clients
*@param String A string containing a username
*@return boolean 
*/
bool find (vector<Client> bank, string usr){
	for (finder=0; finder<bank.size(); finder++)
		if (bank[finder].getName()==usr) return true;
	return false;
}

/*
*	The login function checks to see who has logged in.
*	If the parameter input is 0; the client has logged in and the client interface is displayed.
*	The trace records if the client has logged out.
*	If the parameter input is 1; a maintenance person has logged in and the maintenance interface is displayed.
*	The trace records if the maintenance person has logged out.
*	If the parameter input is 2; a manager has logged in and the manager interface is displayed.
*	The trace records if the manager has logged out.
*@param Integer
*/
void logIn(int user){
	string option;
	switch(user){
		case 0:
			if (trace) logger(0);
			while(1){
				cout << "\nPlease choose from the following options[1-6]"
						"\n1. Open an account."
						"\n2. Close an account."
						"\n3. Manage account."
						"\n4. View client information."
						"\n5. View all clients informations."
						"\n6. Log out." << endl;
				cin >> option;
				if (!valid(option, 1, 6)) invalid(0);
				else if (option[0] == '6') {
					if (trace) outTrace << "Logged Out." << endl;
					break;
				} else manager((int)option[0]-48);
			} break;
		case 1:
			if (trace) logger(1);
			while(1){
				cout <<	"\nPlease choose from the following options[1-3]"
						"\nThe execution trace is currently "<< (trace ? "ON." : "OFF.") << ""
						"\n1. Toggle execution trace."
						"\n2. Print execution trace."
						"\n3. Log out." << endl;
				cin >> option;
				if (!valid(option, 1, 3)) invalid(0);
				else if (option[0] == '3') {
					if (trace) outTrace << "Logged Out." << endl;
					break;
				} else maintainer((int)option[0]-48);
			} break;
		case 2:
			if (trace) logger(2);
			while(1){
				cout << "\nPlease choose from the following options[1-3]"
						"\n1. Saving Account."
						"\n2. Checking Account."
						"\n3. Log out." << endl;
				cin >> option;
				if (!valid(option, 1, 3)) invalid(0);
				else if (option[0] == '3') {
					if (trace) outTrace << "Logged Out." << endl;
					break;
				} else client((int)option[0]-48);
			} break;
	}cout << "\nHave a good day.\n\n" <<endl;
}

/*
*	The manager function deals with when the manager loggs in.
*	In case 1; Manager has opened a new acccunt for the client, with a username and password.
*			 ; The new clients information must contain atleast 8 characters for password and must be a new username.
			 ; Information is pushed to the 'temp' client.
*			 ; Trace records that a new client was made.
*	In case 2; Manager is closing a clients account.
			 ; The account can't be closed if the chequing/ saving accounts has a balance greater than 0.
			 ; The account must also exist.
			 ; Trace records that a client has been closed.
	In case 3; Manages a clients account.
			 ; Either chequing or savings account.
	In case 4; Manager sees the clients chequing and/or saving balance(s).
	in case 5; Able to see multiple clients accounts
			 ; Sees their chequing and/or saving balance(s). 
*@param Integer
*/
void manager(int option){
	switch (option){
	case 1:
		cout << "\nOpening a new account:" << endl;
		if (trace) outTrace << "\nOpening a new account: ";
		while(1){
			cout << "\nPlease enter a Username for the new client(type \"exit\" to abort): ";
			cin >> usr;
			if (exit(usr)) break;
			if (!find(clients, usr)){
				while (1){
					cout << "Please enter a Password for the new client(Must be at least 8 characters): ";
					cin >> pswd;
					if (pswd.size()>7){
						cout << "\nThe Client account has been successfully created.\n" << endl;
						if (trace) outTrace << "Successful (" << usr << ", " << pswd << ") was added." << endl;
						clients.push_back(Client(usr, pswd, 3));
						break;
					} else cout << "\nThe password must be at least 8 characters" << endl;
				} break;
			} else cout << "\nThe Username that you entered already exists in the database, please select a different Username." << endl;
		} break;

	case 2:
		cout << "\nClosing a client account:" << endl;
		if (trace) outTrace << "\nClosing a client account: ";
		while (1){
			cout << "\nPlease type in the Username of the account that you would like to close(type \"exit\" to abort): ";
			cin >> usr;
			if (exit(usr)) break;
			if (!find(clients, usr)) cout << "\nThere does not exist a client with the Username, " << usr << endl;
			else {
				if(clients[finder].getSaving() != 0 && clients[finder].getSaving()->getBalance()!=0)
					cout << "Account cannot be closed, Saving account contains funds." << endl;
				else if(clients[finder].getChecking() != 0 && clients[finder].getChecking()->getBalance()!=0)
					cout << "Account cannot be closed, Checking account contains funds." << endl;
				else{
					clients.erase(clients.begin()+finder);
					cout << "The account has been successfully closed." << endl;
					if (trace) outTrace << "Successful (" << usr << ") has been closed." << endl;
					break;
				}
			}
		} break;

	case 3:
		cout << "\nManaging a client account:" << endl;
		if (trace) outTrace << "\nManaging a client account: ";
		while (1){
			cout << "\nPlease type in the Username of the account that you would like to manage(type \"exit\" to abort):";
			cin >> usr;
			if (exit(usr)) break;
			if (!find(clients, usr))cout << "\nThere does not exist a client with the Username, " << usr << endl;
			else{
				if (trace) outTrace << "Now managing, " << usr << "." << endl;
				while(1){
					cout << "\nPlease select the account that you'd like to manage:" << endl;
					cout << "1. Saving Account." << endl;
					cout << "2. Checking Account." << endl;

					cin >> temp;
					if (!valid(temp, 1, 2)) cout << "\nInvalid choice." << endl;
					else {
						bool init;
						if (temp=="1"){
							if (!clients[finder].hasSaving()) init=initSaving();
							if (init) manage(clients[finder].getSaving());
							else cout << "\nPlease initialize the Saving Account before managing it." << endl;
						} else {
							if (!clients[finder].hasChecking()) init=initChecking();
							if (init) manage(clients[finder].getChecking());
							else cout << "\nPlease initialize the Checking Account before managing it." << endl;
						} break;
					}
				} break;
			}
		} break;

	case 4:
		while (1){
			cout << "\nPlease type in the Username of the account that you would like to view(type \"exit\" to abort): ";
			cin >> usr;
			if (exit(usr)) break;
			if (!find(clients, usr)) cout << "\nThere does not exist a client with the Username, " << usr << endl;
			else{
				if (trace) outTrace << "Now viewing, " << usr << " information." << endl;
				cout << "\n\nUsername: " << clients[finder].getName() << endl;

				cout << "Saving Account: ";
				if (clients[finder].hasSaving()) cout << "$" << clients[finder].getSaving()->getBalance() << endl;
				else cout << "Saving Account is not initialized." << endl;

				cout << "Checking Account: ";
				if (clients[finder].hasChecking()) cout << "$" << clients[finder].getChecking()->getBalance() << endl;
				else cout << "Checking Account is not initialized." << endl;

				break;
			}
		}break;

	case 5:
		if (trace) outTrace << "Viewing the client list information." << endl;
		cout << "Username\t\tSaving\t\tChecking" << endl;
		for (int i = 0; i<clients.size(); i++){
			cout << clients[i].getName()<< "\t\t";

			if (clients[i].hasSaving()) cout << "$" << clients[i].getSaving()->getBalance() << "\t\t";
			else cout << "n/a\t\t";

			if (clients[i].hasChecking()) cout << "$" << clients[i].getChecking()->getBalance() << endl;
			else cout << "n/a" << endl;
		} break;
	}
}

/*
*	The maintainer function allows a maintenance person to fully print the traces that have been recorded,
*	In case 2; The maintainer has printed the trace calls.
*			 ; It shows the time when they were printed.
*@param Integer 
*/
void maintainer (int option){
	switch(option){
		case 1:
			if (trace) {
				cout << "\nIf not printed, all previous execution traces will be lost. Are you sure you'd like to continue(y/n)" << endl;
				while(1){
					cin >> temp;
					if (temp.size()==1){
						if (temp[0]=='y'){
							trace = false;
							outTrace.str("");
							break;
						}else if (temp[0]=='n')break;
					}else invalid(1);
				}
			}else trace = true;
			break;
		case 2:
			outTrace << "PRINTED: " << getTime() << endl;
			cout << outTrace.str();
			break;
	}
}

/*
*	The client function has the option of managing the chequing and/or saving account(s)
*	In case 1; The client is managing the saving account.
*	In case 2; The client is managing the chequing account.
*@param Integer
*/
void client (int option){
	switch(option){
		case 1:
			if (trace) outTrace << "Managing the Saving account." << endl;
			if (!clients[finder].hasSaving()){
				if (initSaving()) break;
			} else manage((clients[finder].getSaving()));
			break;
		case 2:
			if (trace) outTrace << "Managing the Checking account." << endl;
			if (!clients[finder].hasChecking()){
				if (initChecking()) break;
			} else manage(clients[finder].getChecking());
			break;
	}
}

/*
*	The manager function manages the accounts.
*	It first checks which the user wanted to do, check balances, transfer money, deposit/withdraw.
*	For depositing money/ withdrawing money, the client types in the amount ( such that it doesn't surpass its balance or goes lower than 0).
*	In either case, the balances in each account of the clients is updated.
*	If the amount is withdraw below 1000$ threshold, a charge is 2$ is applied.
*	If the transfer is picked and the client wants to transfer money to a non-active account, that account is made.
*	The user can also only close and account if the balance is 0$.
*@param A pointer to an Account
*/
void manage (Account* acc){
	while(1){
		manageOptions();
		cin >> temp;
		if (!valid(temp, 1, 6)) cout << "\nInvalid choice." << endl;
		else if (temp[0] == '6') {
			if (trace) outTrace << "<< Back <<" << endl;
			break;
		}
		else{
			switch((int)temp[0]-48){
				case 1:
					if (trace) outTrace << "Viewed balance." << endl;
					cout << "\nBalance: $" << acc->getBalance() << endl;
					break;
				case 2:
					cout << "\nPlease enter the amount that you would like to deposit:";
					cin >> temp;
					value = stod(temp);
					if (!convert) cout << "\nPlease enter a valid number." << endl;
					else {
						acc->deposit(value);
						if (trace) outTrace << "Deposited, $" << value <<endl;
						cout << "\nA sum of, $" << value << ", has been deposited to your account, your account balance is now $" << acc->getBalance() << endl;
						break;
					} break;
				case 3:
					cout << "\nPlease enter the amount that you would like to withdraw:";
					cin >> temp;
					value = stod(temp);
					if (!convert) cout << "\nPlease enter a valid number." << endl;
					else{
						if (acc->getType()==0){
							if (acc->withdraw(value)){
								if (trace) outTrace << "Withdrawn, $" << value << endl;
								cout << "\nA sum of, $" << value << ", has been withdrawn from your account, your account balance is now $" << acc->getBalance() << endl;
								break;
							} else invalid(2);
						} else {
							if (acc->getBalance()>999 && acc->getBalance()- value < 1000){
								cout << "Your account balance will drop below the threshold of $1,000 after this transaction, this will case a charge of $2, do you comply(y/n)" << endl;
								while(1){
									cin >> temp;
									if (choiceHelper(temp)){
										if (acc->withdraw(value+2)){
											if (trace) outTrace << "Withdrawn, $" << value << endl;
											cout << "\nA sum of, $" << value << ", has been withdrawn from your account, as well as a transaction $2 charge, your account balance is now $" << acc->getBalance() << endl;
										} else invalid(2);
										break;
									}
								}
							} else {
								if (acc->withdraw(value)){
									if (trace) outTrace << "Withdrawn, $" << value << endl;
									cout << "\nA sum of, $" << value << ", has been withdrawn from your account, your account balance is now $" << acc->getBalance() << endl;
									break;
								} else invalid(2);
							}
						}
					} break;
				case 4:
					bool init;
					if (!clients[finder].hasSaving() || !clients[finder].hasChecking())
					{
						if (acc->getType()==0) init=initChecking();
						else init=initSaving();

						if (init){
							trans(acc);
							break;
						} else cout << "\nPlease make sure that your Saving and Checking accounts are both initialized." << endl;
					}else if(trans(acc))break;
					break;
				case 5:
					if (acc->getBalance()!=0) cout << "\nPlease make sure that the account balance is 0, current balance: $" << acc->getBalance() << endl;
					else {
						if (acc->getType()==0) {
							if (trace) outTrace << "Closed Saving account." << endl;
							clients[finder].removeSaving();
							closeAcc = true;
						}
						else {
							if (trace) outTrace << "Closed Checking account." << endl;
							clients[finder].removeChecking();
							closeAcc = true;
						}
						cout << "\nThe account has been successfully closed." << endl;
					} break;
			}
		}
		if (closeAcc){
			closeAcc = false;
			break;
		}
	}
}

/*
*	The valid function checks whether the string or the integers are valid or not
*@param String
*@param Integer
*@param Integer
*@return Boolean
*/
bool valid(string str, int x, int y){
	if (str.size()>1 || !isdigit(str[0]) || (int)str[0]<x+48 || (int)str[0]>y+48) return false;
	return true;
}
/*
* 	The stod calls the stodhelper to turn the string into a double 
*@param String
*@return double
*/
double stod(string str){
	convert = true;
	power = 0;
	decimal = false;
	return stodHelper(str, 0)/pow(10, power);
}
/*
*	The stodhelper function is the main method to turn a string into a double.
*@param String
*@param String
*@return double
*/
double stodHelper(string str, int j){
	for (int i=str.size()-1;i>-1;i--){
		if (isdigit(str[i]) || (str[i]=='.' && !decimal)) {
			if (str[i]=='.'){
				decimal = true;
				power = j;
			} else return (int(str[i])-48)*pow(10, j)+stodHelper(str.substr(0, i), j+1);
		}else{
			convert = false;
			return 0;
		}
	}return 0;
}
/*
*	The initSaving function checks to see whether you have a saving account.
*	If you don't, it creates one.
*	It is saved on the trace. 
*@return boolean
*/
bool initSaving(){
	cout << "It seems like you don't have a Saving account, would you like to create one?(y/n): ";
	cin >> temp;
	if (choiceHelper(temp)){
		clients[finder].addSaving();
		if (trace) outTrace << "Initialized Saving account." << endl;
		return true;
	} return false;
}
/*
*	The initCheckingfunction checks to see whether you have a chequing account.
*	If you don't, it creates one.
*	It is saved on the trace. 
*@return boolean
*/
bool initChecking(){
	cout << "It seems like you don't have a Checking account, would you like to create one?(y/n): ";
	cin >> temp;
	if (choiceHelper(temp)){
		clients[finder].addChecking();
		if (trace) outTrace << "Initialized Checking account." << endl;
		return true;
	} return false;
}

/*
*	The choiceHelper function checks to see whether y/n was entered.
*	If 'n' the operation will be canelled.
* 	If 'y' the function returns true
*
*@param string
*@return boolean
*/
bool choiceHelper(string str){
	if (str.size()==1){
		if (str[0]=='y') return true;
		else if (str[0]=='n') {
			cout << "\nOperation cancelled." <<endl;
			return false;
		}
		else invalid(1);
	} else invalid(1);
	return false;
}
/*
* invalid is called out by the choice helpeer function and it checks whether its an invalid choice or not.
*@param Integer
*/
void invalid(int i){
	switch (i){
		case 0:
			cout << "\nInvalid choice." << endl;
			break;
		case 1:
			cout << "Invalid response, please enter(y/n): ";
			break;
		case 2:
			cout << "\nWarning! Insufficient funds." << endl;
			break;
	}
}

void manageOptions(){
	cout << "\nPlease choose from the following options[1-6]"
			"\n1. Show Balance."
			"\n2. Deposit."
			"\n3. Withdraw."
			"\n4. Transfer."
			"\n5. Close Account"
			"\n6. Back" << endl;
}

/*
*	Traces whenever a manager,client, maintenance person has logged in
*@param Integer
*/
void logger (int i){
	switch (i){
		case 0:
			outTrace << "Username: manager" << endl;
			outTrace << "Password: password" << endl;
			outTrace << "Time logged: " << getTime() << endl;
			break;
		case 1:
			outTrace << "Username: maintainer" << endl;
			outTrace << "Password: password" << endl;
			outTrace << "Time logged: " << getTime() << endl;
			break;
		case 2:
			outTrace << "Username: " << clients[finder].getName() << endl;
			outTrace << "Password: " << clients[finder].getPswd() << endl;
			outTrace << "Time logged: " << getTime() << endl;
			break;
	}
}

/*
*	The getTime function is for retrieving the actual time for the trace calls
*/
string getTime(){
	time_t rawtime;
	time (&rawtime);
	return asctime(localtime (&rawtime));
}

/*
*	The trans function is a helper function that is called to transfer the money from one account to another.
*	If the amount is transfered, the amount is shown and to which account is has been transferred to.
*@param Account pointer
*@return boolean
*/
bool trans(Account* acc){
	cout << "\nPlease enter the amount that you would like to transfer:";
	cin >> temp;
	value = stod(temp);
	if (!convert) cout << "Please enter a valid number." << endl;
	else{
		if (acc->withdraw(value)){
			if (trace) outTrace << "Transfered, $" << value << endl;
			cout << "\nA sum of, $" << value << ", has been transfered ";
			if (acc->getType()==0){
				clients[finder].getChecking()->deposit(value);
				cout << "from your Saving Account to your Checking Account.";
			} else {
				clients[finder].getSaving()->deposit(value);
				cout << "from your Checking Account to your Saving Account.";
			}cout << "New balance Saving: $" << clients[finder].getSaving()->getBalance() << ", Checking: $" << clients[finder].getChecking()->getBalance() << endl;
			return true;
		} else invalid(2);
	} return false;
}
/*
*	The exit function is to exit the program or the current state once the user is done.
*@paramter String
*@return boolean
*/
bool exit(string str){
	if (usr == "exit"){
		if (trace) outTrace << "<< Aborted <<" << endl;
		return true;
	} return false;
}
