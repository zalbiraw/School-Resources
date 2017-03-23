
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
vector<T> empty_vector;

int main(int argc, char **argv)
{
	if (argc < 6)
	{
		cout << "Error: insufficient number arguments." << endl;
		cout << "Required format: P4 text1.txt text2.txt # # #" << endl;
	}
	else
	{
		char* train = argv[1], *test = argv[2];
		int n = atoi(argv[3]), model = atoi(argv[5]);
		double threshold, delta;

		if (model == GOODTURING)
			threshold = atof(argv[4]);
		else if (model == ADDDELTA)
			delta = atof(argv[4]);
		else
		{
			cout << "Error: Please enter 0 or 1 for the last field" << endl;
			exit(0);
		}

		vector<T> tokens;
		vector<vector<T>> sentences;
		unordered_map<vector<T>, double> ml;  

		empty_vector.push_back("");
		try
		{
			read_tokens(train, tokens, false);
			int unique = populate(&tokens, &ml, n);
			ml[empty_vector] = tokens.size();
			
			read_tokens(test, tokens, true);
			generate_sentences(&tokens, &sentences);	

			if (model == GOODTURING)
				good_turing(threshold, (unique * 2), ml[empty_vector], n, &sentences, &ml);
			else if (model == ADDDELTA)
				add_delta(delta, (unique * 2), n, &sentences, &ml);
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
	int i, j, k;
	double sen_log = 0, prob;
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


			/*cout << "(" << (*ml)[nGram_child] << " + " << delta << ") \t/ ";
			cout << "[" << (*ml)[nGram_parent] << " + (" << magnitude << "^";
			cout << k << " * " << delta << ")]\t\t";

			for (int x = 0; x < nGram_parent.size(); x++)
				cout << nGram_parent[x] << " ";
			cout << "\t\t";

			for (int x = 0; x < nGram_child.size(); x++)
				cout << nGram_child[x] << " ";
			cout << endl;*/

			prob = ((double)(*ml)[nGram_child] + delta) / (double)((*ml)[nGram_parent] + (pow(magnitude, k) * delta));

			if (prob)
				sen_log += log(prob);
			else
				sen_log += -DBL_MAX;
		}
		cout << sen_log << endl;
	}
}

void good_turing(double threshold, int magnitude, int size, int n, vector<vector<T>> *sentences
	, unordered_map<vector<T>, double> *ml)
{
	int i, j, r, nG;
	double sen_log = 0, freq, prob;
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

	/*unordered_map<int, double> bin;
	for (auto i = c_bins.begin(); i != c_bins.end(); ++i)
	{
		nG = i->first;
		bin = i->second;
		for (auto j = bin.begin(); j != bin.end(); ++j)
		{
			r = j->first;
			freq = j->second;
			cout << "nGram: " << nG << " \tbin: " << r << " \tfrequency: " << freq << endl;
		}
	}*/

	for (auto i = c_bins.begin(); i != c_bins.end(); ++i)
	{
		nG = i->first;
		c_bins[nG][0] = pow(magnitude, nG) - nGram_bins[nG];
		for (auto j = i->second.begin(); j != i->second.end(); ++j)
		{
			r = j->first;
			freq = j->second;

			//cout << "Probablity[" << nG << "][" << r << "]\t=\t"; 
			if (r >= threshold)
			{
				probs[nG][r] = 1 / (double)size;
				//cout << freq << " / " << size << "\t\t\t\t=\t";
				//cout << probs[nG][r] << endl;
			}
			else
			{
				probs[nG][r] = (double)(r + 1) 
					* (double)(i->second[r + 1] / (double)(size * freq));

				if (probs[nG][r] == 0)
				{
					cout << "Error: Nr = 0, decrease threshold!\n";
					exit(0);
				}

				//cout << "(" << r << " + 1) * [" << i->second[r + 1] << " / (";
				//cout << size << " * " << freq << ")]\t=\t" << probs[nG][r] << endl;
			}

			if (r != 0)
			{
				sums[nG] += probs[nG][r]*freq;
				//cout << "added: " << prob;
				//cout << "\ttotal = " << sums[nG]<< endl;
			}
				
			//cout << "sums : " << sums[nG] << endl;
		}
	}

	for (auto i = nGram_bins.begin(); i != nGram_bins.end(); ++i)
	{
		nG = i->first;
		y[nG] = (1 - (c_bins[nG][r] / size)) / (sums[nG]);
	}

	/*for (auto i = y.begin(); i != y.end(); ++i)
	{
		nG = i->first;
		cout << "y(" << nG << ") = [1 - (" << c_bins[nG][r] << " / ";
		cout << size << ")] / (" << sums[nG] << ")";
		cout << "\t=\t" << y[nG] << endl;
	}*/
	
	for (auto i = c_bins.begin(); i != c_bins.end(); ++i)
		for (auto j = i->second.begin(); j != i->second.end(); ++j)
			if (j->first != 0)
				probs[i->first][j->first] *= y[nG];

	/*for (auto i = c_bins.begin(); i != c_bins.end(); ++i)
		for (auto j = i->second.begin(); j != i->second.end(); ++j)
		{
			cout << "Probablity[" << i->first << "][" << j->first;
			cout << "] = " << probs[i->first][j->first] << endl;
		}*/
				
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

			/*for (int x = 0; x < nGram.size(); x++)
				cout << nGram[x] << " ";
			cout << endl;*/

			sen_log += log(probs[nGram.size()][(*ml)[nGram]]);
		}
		cout << sen_log << endl;
	}
}

