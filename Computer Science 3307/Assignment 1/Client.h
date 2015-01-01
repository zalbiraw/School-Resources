/*
 * Client.h
 *
 *  Created on: Sep 13, 2014
 *      Author: zalbiraw
 */

#ifndef CLIENT_H_
#define CLIENT_H_

#include "Account.h"
using namespace std;

class Client : public User {
	/*
	* 	attributes
	*/
	Account saving, checking;
	bool boolSaving, boolChecking;
public:
	Client(string, string, int);
	/*
	*	The hasSaving and hasChecking check to see if there are checking or saving accounts active
	*@return booelean
	*/
	bool hasSaving(){return boolSaving;}
	bool hasChecking(){return boolChecking;}

	/*
	*	The getSaving and getChecking are getter function that retrieve the saving and checking balance
	* @param Integer pointers
	*/
	Account* getSaving(){
		if (boolSaving) return &saving;
		return 0;
	}

	Account* getChecking(){
		if (boolChecking) return &checking;
		return 0;
	}

	void addSaving(){
		boolSaving = true;
	}

	void addChecking(){
		boolChecking = true;
	}

	void removeSaving(){
		boolSaving = false;
	}

	void removeChecking(){
		boolChecking = false;
	}

	/*
	*	The transfer function transfers the amount specified from the account specified to a different account.
	*@param double
	*@param Account
	*@param Account
	*@return boolean
	*/
	bool transfar(double amount, Account from, Account to){
		if (from.getBalance()>=amount){
			from.withdraw(amount);
			to.deposit(amount);
			return true;
		}else return false;
	}
};

Client::Client(string username, string password, int type)
: User(username, password, type)
, saving(0)
, checking(1)
{
	boolSaving = false;
	boolChecking = false;
}

#endif /* CLIENT_H_ */
