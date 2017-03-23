#include <stdio.h>
#include <iostream>
#include <unordered_map>
#include <vector>
#include "fileRead.h"
#include "VectorHash.h"
#include "utilsToStudents.h"

using namespace std;

typedef string T;
vector<T> sub_vector(vector<T>*, int, int);
void populate(vector<T>*,unordered_map<vector<T>, unordered_map<vector<T>, int>>*, int);
void generate_vocab(unordered_map<vector<T>, int>*, vector<T>*, vector<double>*);

vector<T> empty_vector;

int main(int argc, char **argv)
{
	vector<T> word;
	vector<T> vocab;
	vector<double> probs;
	if (argc < 3)
	{
		cout << "Error: insufficient number arguments." << endl;
		cout << "Required format: P3 text.txt #" << endl;
	}
	else
	{
		char* file = argv[1];
		int n = atoi(argv[2]);

		vector<T> tokens, sentence;
		unordered_map<vector<T>, unordered_map<vector<T>, int>> ml; 

		empty_vector.push_back(""); 
		try
		{
			read_tokens(file, tokens, true);
			populate(&tokens, &ml, n);

			sentence.push_back("<END>");

			int i = 0, j = 1, z, x = 0;
			while (1)
			{
				word.clear();
				vocab.clear();
				probs.clear();

				if (n < 2)
					word = empty_vector;
				else
					for (z = 0; z < j; z++)
						word.push_back(sentence[i + z]);

				generate_vocab(&ml[word], &vocab, &probs);
				sentence.push_back(vocab[drawIndex(probs)]);

				if (sentence[sentence.size() - 1].compare("<END>") == 0)
					break;

				if (j < n - 1)
					j++;
				else
					i++;
			}

			for (i = 1; i < sentence.size(); i++)
				cout << sentence[i] << " ";
			cout << endl;
		}
		catch (FileReadException e)                     
		{
			e.Report();	
		}
	}
	return 0;
}

vector<T> sub_vector(vector<T> *sentence, int start, int finish)
{
	vector<T> sub(finish - start);
	for (int i = 0; i < finish - start; i++)
		sub[i] = (*sentence)[start + i];
	return sub;
}

void populate(vector<T> *tokens, unordered_map<vector<T>, unordered_map<vector<T>, int>> *ml, int n)
{
	int z;
	vector<T> nGram, nGram_parent;

	if (tokens->size() < n)
		cout << "Input file is too small to create any nGrams of size " << n << "." << endl;
	else 
	{
		for (int i = 1; i <= n; i++)
			for (int j = 0; j <=  tokens->size() - i; j++)
			{
				unordered_map<vector<T>, int> nGram_child;

				nGram = sub_vector(tokens, j, j + i);

				if (i == 1)
					nGram_parent = empty_vector;
				else
					nGram_parent = sub_vector(&nGram, 0, nGram.size() - 1);

				if ((*ml)[nGram_parent] != nGram_child)
					nGram_child = (*ml)[nGram_parent];

				nGram_child[nGram]++;
				(*ml)[nGram_parent] = nGram_child;
			}
	}
}

void generate_vocab(unordered_map<vector<T>, int> *database, vector<T> *vocab, vector<double> *probs)
{
	int total = 0;
	for (auto i = database->begin(); i != database->end(); ++i) 
	{
		(*vocab).push_back(i->first[(i->first).size() - 1]);
		(*probs).push_back(i->second);
		total += i->second;
	}

	for (int i = 0; i < probs->size(); i++)
		(*probs)[i] /= total;
}
