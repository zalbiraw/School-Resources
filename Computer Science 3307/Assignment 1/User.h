/*
 * User.h
 *
 *  Created on: Sep 12, 2014
 *      Author: zalbiraw
 */

#ifndef USER_H_
#define USER_H_

using namespace std;

class User {
	string username, password;
	int type;
public:
	User(string, string, int);

	string getName(){return username;}
	string getPswd(){return password;}
	int getType(){return type;}
};

User::User(string username, string password, int type){
	this->username = username;
	this->password = password;
	this->type = type;
}

#endif /* USER_H_ */
