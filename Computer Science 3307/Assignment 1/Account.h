/*
 * Account.h
 *
 *  Created on: Sep 13, 2014
 *      Author: zalbiraw/ vverbani
 */

#ifndef ACCOUNT_H_
#define ACCOUNT_H_

using namespace std;

/*
*attributes
*/
class Account {
	int type;
	double balance;
public:
	Account(int);
	/*
	*	Getter method of the type
	*@return Integer
	*/
	int getType(){return type;}
	/*
	*	Getter method for the balance 
	*@return double
	*/
	double getBalance(){return balance;}
	/*
	*	Deposit function to deposit the money to an account
	*@param double
	*/
	void deposit(double amount){balance += amount;}
	/*
	*	Withdraw function to withdraw the money from an account	
	*@param double
	*@return boolean
	*/
	bool withdraw(double amount){
		if (balance>=amount){
			balance -= amount;
			return true;
		} else return false;
	}
};

Account::Account(int type){
	this->type = type;
	balance = 0;
}

#endif /* ACCOUNT_H_ */
