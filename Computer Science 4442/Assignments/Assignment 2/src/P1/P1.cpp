#include <stdio.h>
#include <iostream>
#include <unordered_map>
#include "fileRead.h"
#include "VectorHash.h"

using namespace std;

typedef string T;
void populate(vector<T>, unordered_map<vector<T>, int>*, int, int);

int main(int argc, char **argv)
{
	if (argc < 5)
	{
		cout << "Error: insufficient number arguments." << endl;
		cout << "Required format: P1 text1.txt text2.txt # #" << endl;
	}
	else
	{
		char* file1 = argv[1], *file2 = argv[2];
		int n = atoi(argv[3]), print = atoi(argv[4]);

		vector<T> tokens, nGram;
		unordered_map<vector<T>, int> database;  
		try
		{
			read_tokens(file1, tokens, false);
			populate(tokens, &database, n, 0);

			read_tokens(file2, tokens, false);
			populate(tokens, &database, n, 1);
		}
		catch (FileReadException e)                     
		{
			e.Report();
		}

		if (print)
			for (auto i = database.begin(); i != database.end(); ++i) 
			{
				nGram = i->first;
				if (i->second == 2)
				{
					for (int j = 0; j < nGram.size(); j++)
						cout << nGram[j] << " ";

					cout << "\n";
				}
			}

	}
	return 0;
}


void populate(vector<T> tokens, unordered_map<vector<T>, int> *database, int n, int iter)
{
	int i, j;
	double z = 0;

	if (tokens.size() < n)
		cout << "Input file is too small to create any nGrams of size " << n << "." << endl;
	else 
	{
		for (i = 0; i <=  tokens.size() - n; i++)
		{
			vector<T> nGram(n);
		
			for (j = 0; j < n; j++)
				nGram[j] = tokens[i + j];

			if (!iter && database->count(nGram) == 0)
				(*database)[nGram] = iter + 1;

			if (iter && database->count(nGram) != 0)
			{
				(*database)[nGram] = iter + 1;
				z++;
			}
		}
	}
	if (iter)
		cout << 1 - (z / (tokens.size() - n)) << endl;
}