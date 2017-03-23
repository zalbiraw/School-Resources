
#include <stdio.h>
#include <iostream>
#include <unordered_map>
#include <vector>
#include <cmath>
#include <float.h>
#include "fileRead.h"
#include "VectorHash.h"
#include "utilsToStudents.h"

using namespace std;

typedef char T;

vector<T> sub_vector(vector<T>*, int, int);
void generate_sentences(vector<T>*, vector<vector<T>>*, int);
int populate(vector<T>*,unordered_map<vector<T>, double>*, int);
vector<int> add_delta(double, int, int, vector<vector<T>>*
	, vector<unordered_map<vector<T>, double>>*);
vector<T> empty_vector;

int main(int argc, char **argv)
{
	if (argc < 4)
	{
		cout << "Error: insufficient number arguments." << endl;
		cout << "Required format: P5 # # #" << endl;
	}
	else
	{
		string train_danish = "danish1.txt";
		string test_danish = "danish2.txt";

		string train_english = "english1.txt";
		string test_english = "english2.txt";

		string train_french = "french1.txt";
		string test_french = "french2.txt";

		string train_italian = "italian1.txt";
		string test_italian = "italian2.txt";

		string train_latin = "latin1.txt";
		string test_latin = "latin2.txt";

		string train_sweedish = "sweedish1.txt";
		string test_sweedish = "sweedish2.txt";


		int n = atoi(argv[1]), senLength = atoi(argv[3]);
		double delta = atof(argv[2]);

		vector<T> tokens;
		vector<string> train, test; 
		vector<vector<T>> sentences;
		unordered_map<vector<T>, double> danish_database, english_database, 
			french_database, italian_database, latin_database, sweedish_database;
		vector<unordered_map<vector<T>, double>> databases;

		empty_vector.push_back('\e');
		try
		{
			train.push_back(train_danish);
			train.push_back(train_english);
			train.push_back(train_french);
			train.push_back(train_italian);
			train.push_back(train_latin);
			train.push_back(train_sweedish);

			test.push_back(test_danish);
			test.push_back(test_english);
			test.push_back(test_french);
			test.push_back(test_italian);
			test.push_back(test_latin);
			test.push_back(test_sweedish);

			databases.push_back(danish_database);
			databases.push_back(english_database);
			databases.push_back(french_database);
			databases.push_back(italian_database);
			databases.push_back(latin_database);
			databases.push_back(sweedish_database);

			vector<vector<int>> results(databases.size());
			for (int i = 0; i < train.size(); i++)
			{
				tokens.clear();
				read_tokens(train[i], tokens, true);
				populate(&tokens, &databases[i], n);
				databases[i][empty_vector] = tokens.size();
			}

			for (int i = 0; i < test.size(); i++)
			{
				tokens.clear();
				read_tokens(test[i], tokens, true);
				generate_sentences(&tokens, &sentences, senLength);
				results[i] = add_delta(delta, 26, n, &sentences, &databases);
			}

			double failed = 0, total = 0;
			for (int i = 0; i < results.size(); i++)
				for (int j = 0; j < results[i].size(); j++)
				{
					total += results[i][j];
					if (i != j)
						failed += results[i][j];
				}

			cout << failed / total * 100 << "%" << endl;
			for (int i = 0; i < results.size(); i++)
			{
				for (int j = 0; j < results[i].size(); j++)
					cout << results[i][j] << "\t";
				cout << endl;
			}
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
	vector<T> sub;
	for (int i = 0; i < finish - start; i++)
		sub.push_back((*sentence)[start + i]);
	return sub;
}

void generate_sentences(vector<T> *tokens, vector<vector<T>> *sentences, int senLength)
{
	(*sentences).clear();
	vector<T> sentence;
	for (int i = 1; i < (*tokens).size() + 1; i++)
	{
		sentence.push_back((*tokens)[i - 1]);
		if (i % senLength == 0)
		{	
			(*sentences).push_back(sentence);
			sentence.clear();
			continue;
		}
	}
}

int populate(vector<T> *tokens,unordered_map<vector<T>, double> *ml, int n)
{
	int z, unique = 0;
	vector<T> nGram;

	if (tokens->size() < n)
		cout << "Input file is too small to create any nGrams of size " << n << "." << endl;
	else 
	{
		for (int i = 1; i <= n; i++)
			for (int j = 0; j <=  (*tokens).size() - i; j++)
			{
				nGram = sub_vector(tokens, j, j + i);
				(*ml)[nGram]++;

				if (i == 1 && (*ml)[nGram] == 1)
					unique++;
			}
	}
	return unique;
}

vector<int> add_delta(double delta, int magnitude, int n, vector<vector<T>> *sentences
	, vector<unordered_map<vector<T>, double>> *databases)
{
	int i, j, k, offset, lang;
	double sen_log = 0, prob, best;
	vector<T> sentence, nGram_child, nGram_parent;
	vector<int> result (databases->size());

	for (i = 0; i < (*sentences).size(); i++)
	{
		best = -DBL_MAX;
		sentence = (*sentences)[i];
		for (j = 0; j < (*databases).size(); j++)
		{
			sen_log = 0;
			for (k = 1; k <= sentence.size(); k++)
			{
				if (k < n)
					offset = j;
				else
					offset = n;
				
				nGram_child = sub_vector(&sentence, k - offset, k);

				if (nGram_child.size() == 1)
					nGram_parent = empty_vector;
				else
					nGram_parent = sub_vector(&nGram_child, 0, nGram_child.size() - 1);

				prob = ((double)(*databases)[j][nGram_child] + delta) 
				/ (double)((*databases)[j][nGram_parent] 
					+ (pow(magnitude, offset) * delta));

				/*cout << "(" << (*databases)[j][nGram_child] << " + " << delta << ") \t/ ";
				cout << "[" << (*databases)[j][nGram_parent] << " + (" << magnitude << "^";
				cout << offset << " * " << delta << ")] = " << prob << "\t";

				for (int x = 0; x < nGram_parent.size(); x++)
					cout << nGram_parent[x] << " ";
				cout << "\t";

				for (int x = 0; x < nGram_child.size(); x++)
					cout << nGram_child[x] << " ";
				cout << endl;*/

				if (prob > 0)
					sen_log += log(prob);
				else
				{
					sen_log = -DBL_MAX;
					break;
				}
			}
			if (sen_log > best)
			{
				best = sen_log;
				lang = j;
			}
		}
		if (best != -DBL_MAX)
			result[lang]++;
	}
	return result;
}
