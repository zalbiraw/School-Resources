#include <stdio.h>
#include <iostream>
#include <unordered_map>
#include "fileRead.h"
#include "VectorHash.h"

using namespace std;

typedef string T;
void populate(vector<T>, unordered_map<vector<T>, int>*, int);
void evaluate(vector<T>, unordered_map<vector<T>, int>*, int);


int main(int argc, char **argv)
{
	if (argc < 4)
	{
		cout << "Error: insufficient number arguments." << endl;
		cout << "Required format: P2 text1.txt text2.txt #" << endl;
	}
	else
	{
		char* file1 = argv[1], *file2 = argv[2];
		int n = atoi(argv[3]);

		vector<T> tokens, nGram;
		unordered_map<vector<T>, int> database;  
		try
		{
			read_tokens(file1, tokens, true);
			populate(tokens, &database, n);

			read_tokens(file2, tokens, true);
			evaluate(tokens, &database, n);
		}
		catch (FileReadException e)                     
		{
			e.Report();
		}
	}
	return 0;
}


void populate(vector<T> tokens, unordered_map<vector<T>, int> *database, int n)
{
	int i, j, z;

	if (tokens.size() < n)
		cout << "Input file is too small to create any nGrams of size " << n << "." << endl;
	else 
	{
		for (i = 1; i <= n; i++)
			for (j = 0; j <=  tokens.size() - i; j++)
			{
				vector<T> nGram(i);
				for (z = 0; z < i; z++)
					nGram[z] = tokens[j + z];

				if (database->count(nGram) == 0)
					(*database)[nGram] = 1;
			}
	}
}

void evaluate(vector<T> tokens, unordered_map<vector<T>, int> *database, int n)
{
	bool skip = false;
	int i, j, z = 1, curr = 0;
	double dne = 0, sen = 0;

	for (i = 0; i < tokens.size(); i++)
	{
		if (!skip && i < (tokens.size() - z) + 1)
		{
			vector<T> nGram(z);
			for (j = 0; j < z; j++)
			{
				nGram[j] = tokens[i + j];
				if (tokens[i + j].compare("<END>") == 0)
				{
					skip = true;
					break;
				}
				
			}
				
			if (database->count(nGram) == 0)
			{
				skip = true;
				dne++;
				curr = -1;
			}
		}

		if (tokens[i].compare("<END>") == 0)
		{
			z = 1;
			sen++;
			skip = false;

			if (curr != -1)
			{
				if (i + 1 - curr > n - 1)
				{
					for (int x = 0; tokens[curr + x].compare("<END>") != 0; x++)
						cout << tokens[curr + x] << " ";
					cout << "<END>" << endl;
				}
			}

			curr = i + 1;
		}
		else if (z < n)
		{
			z++;
			i--;
		}		
	}

	cout << dne/sen << endl;
}


