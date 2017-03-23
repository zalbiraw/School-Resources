
#include <stdio.h>
#include <iostream>
#include <unordered_map>
#include <vector>
#include <cmath>
#include <float.h>
#include "fileRead.h"
#include "VectorHash.h"
#include "utilsToStudents.h"

#define GOODTURING 0
#define ADDDELTA 1

using namespace std;

typedef string T;

vector<T> sub_vector(vector<T>*, int, int);
void generate_sentences(vector<T>*, vector<vector<T>>*);
int populate(vector<T>*,unordered_map<vector<T>, double>*, int);
void add_delta(double, int, int, vector<vector<T>>*, unordered_map<vector<T>, double>*);
void good_turing(double, int, int, int, vector<vector<T>>*, unordered_map<vector<T>, double>*);
void get_possible_sentences(vector<vector<T>>*, vector<vector<vector<T>>>*, vector<T>);
vector<T> empty_vector;

int main(int argc, char **argv)
{
	if (argc < 8)
	{
		cout << "Error: insufficient number arguments." << endl;
		cout << "Required format: P6 text1.txt text2.txt text3.txt # # # #" << endl;
	}
	else
	{
		char* train = argv[1], *test = argv[2], *dict = argv[3];
		int n = atoi(argv[4]), model = atoi(argv[7]);
		double threshold = atof(argv[5]), delta = atof(argv[6]);

		vector<T> tokens, dictionary;
		vector<vector<T>> sentences;
		vector<vector<vector<T>>> sentences_pool;
		unordered_map<vector<T>, double> database;  

		empty_vector.push_back("");
		try
		{
			read_tokens(train, tokens, false);
			int unique = populate(&tokens, &database, n);
			database[empty_vector] = tokens.size();
			
			read_tokens(dict, dictionary, false);
			read_tokens(test, tokens, true);
			generate_sentences(&tokens, &sentences);
			get_possible_sentences(&sentences, &sentences_pool, dictionary);
			for (int i = 0; i < sentences_pool.size(); i++)
			{
				if (model)
					add_delta(delta, (unique * 2), n, &sentences_pool[i], &database);
				else
					good_turing(threshold, (unique * 2), database[empty_vector], n, &sentences_pool[i], &database);
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
	vector<T> sub(finish - start);
	for (int i = 0; i < finish - start; i++)
		sub[i] = (*sentence)[start + i];
	return sub;
}

void generate_sentences(vector<T> *tokens, vector<vector<T>> *sentences)
{
	vector<T> sentence;
	for (int i = 0; i < (*tokens).size(); i++)
	{
		if ((*tokens)[i].compare("<END>") == 0)
		{	
			(*sentences).push_back(sentence);
			sentence.clear();
			continue;
		}
		sentence.push_back((*tokens)[i]);
	}
}

void get_possible_sentences(vector<vector<T>> *sentences
	, vector<vector<vector<T>>> *sentences_pool, vector<T> dictionary)
{
	int i, j, k, diff;
	vector<T> sentence;
	for (i = 0; i < (*sentences).size(); i++)
	{
		sentence = (*sentences)[i];
		vector<vector<T>> sentence_pool;
		for (j = 0; j < sentence.size(); j++)
		{
			for (k = 0; k < dictionary.size(); k++)
			{
				diff =  static_cast<int>(uiLevenshteinDistance(sentence[j],dictionary[k]));
				if (diff == 1)
				{
					sentence_pool.push_back(sentence);
					sentence_pool[sentence_pool.size() - 1][j] = dictionary[k];
				}
			}
		}
		(*sentences_pool).push_back(sentence_pool);
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

void add_delta(double delta, int magnitude, int n, vector<vector<T>> *sentences
	, unordered_map<vector<T>, double> *ml)
{
	int i, j, k, best_sentence;
	double sen_log = 0, prob, best_probability = -DBL_MAX;
	vector<T> sentence, nGram_child, nGram_parent;

	for (i = 0; i < (*sentences).size(); i++)
	{
		sen_log = 0;
		sentence = (*sentences)[i];
		for (j = 1; j <= sentence.size(); j++)
		{
			if (j < n)
				k = j;
			else
				k = n;
			
			nGram_child = sub_vector(&sentence, j - k, j);

			if (nGram_child.size() == 1)
				nGram_parent = empty_vector;
			else
				nGram_parent = sub_vector(&nGram_child, 0, nGram_child.size() - 1);

			prob = ((double)(*ml)[nGram_child] + delta) / (double)((*ml)[nGram_parent] + (pow(magnitude, k) * delta));

			if (prob)
				sen_log += log(prob);
			else
				sen_log += -DBL_MAX;
		}
		if (best_probability < sen_log)
		{
			best_probability = sen_log;
			best_sentence = i;
		}
	}
	for (i = 0; i < (*sentences)[best_sentence].size(); i++)
		cout << (*sentences)[best_sentence][i] << " ";
	cout << endl;
}

void good_turing(double threshold, int magnitude, int size, int n, vector<vector<T>> *sentences
	, unordered_map<vector<T>, double> *ml)
{
	int i, j, r, nG, best_sentence;
	double sen_log = 0, freq, prob, best_probability = -DBL_MAX;;
	vector<T> sentence, nGram;
	unordered_map<int, double> nGram_bins, y, sums;
	unordered_map<int, unordered_map<int, double>> c_bins;
	unordered_map<int, unordered_map<int, double>> probs;
	
	for (auto i = ml->begin(); i != ml->end(); ++i)
	{
		if (i->first[0].compare("") != 0)
		{
			nG = i->first.size();
			r = i->second;
			nGram_bins[nG]++;
			c_bins[nG][r]++;
		}
	}

	for (auto i = c_bins.begin(); i != c_bins.end(); ++i)
	{
		nG = i->first;
		c_bins[nG][0] = pow(magnitude, nG) - nGram_bins[nG];
		for (auto j = i->second.begin(); j != i->second.end(); ++j)
		{
			r = j->first;
			freq = j->second;

			if (r >= threshold)
				probs[nG][r] = 1 / (double)size;
			else
			{
				probs[nG][r] = (double)(r + 1) 
					* (double)(i->second[r + 1] / (double)(size * freq));

				if (probs[nG][r] == 0)
				{
					cout << "Error: Nr = 0, decrease threshold!\n";
					exit(0);
				}
			}

			if (r != 0)
				sums[nG] += probs[nG][r]*freq;
		}
	}

	for (auto i = nGram_bins.begin(); i != nGram_bins.end(); ++i)
	{
		nG = i->first;
		y[nG] = (1 - (c_bins[nG][r] / size)) / (sums[nG]);
	}
	
	for (auto i = c_bins.begin(); i != c_bins.end(); ++i)
		for (auto j = i->second.begin(); j != i->second.end(); ++j)
			if (j->first != 0)
				probs[i->first][j->first] *= y[nG];
				
	for (i = 0; i < (*sentences).size(); i++)
	{
		sen_log = 0;
		sentence = (*sentences)[i];
		for (j = 1; j <= sentence.size(); j++)
		{
			if (j < n)
				nGram = sub_vector(&sentence, 0, j);
			else
				nGram = sub_vector(&sentence, j - n, j);

			sen_log += log(probs[nGram.size()][(*ml)[nGram]]);
		}
		if (best_probability < sen_log)
		{
			best_probability = sen_log;
			best_sentence = i;
		}
	}
	for (i = 0; i < (*sentences)[best_sentence].size(); i++)
		cout << (*sentences)[best_sentence][i] << " ";
	cout << endl;
}

