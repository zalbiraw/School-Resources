#define STR_LEN 4
#define LRU 0
#define LFU 1

typedef struct
{
	int mem_loc;
	int freq; 
} page_t;

void failure();
FILE* open_trace(char*);
void simulate(int, FILE*, short);
page_t** generate_table(int, int);
int find(page_t**, int, int);
void reorder_lru(page_t**, int, int);
void reorder_lfu(page_t**, int, int);
void swap(page_t**, int);