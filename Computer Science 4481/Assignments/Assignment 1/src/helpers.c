#include "helpers.h"

// opens file in write mode for usage
FILE* open_file(char type, char const* output) {
  int size = strlen(output) + EXT_LEN + 1;
  char filename[size];

  strcpy(filename, output);

  // concatenates file format 
  switch(type) {
    case PBM:
      strcat(filename, ".pbm");
      break;
    case PGM:
      strcat(filename, ".pgm");
      break;
    case PPM:
      strcat(filename, ".ppm");
      break;
  }

  filename[size - 1] = '\0';
  
  // open file
  FILE *fp = fopen(filename, "w");

  if (fp == NULL) {
    printf("Unable to create file.\n");
    exit(EXIT_FAILURE);
  }

  return fp;
}

// writes header values to file
void write_headers(FILE *fp, char type,
  int width, int height, char format) {
  char mode = type;

  // determines which magic number the document will start with
  if (format == RAW) {
    mode += 3;
  }

  fprintf(fp, "P%c %d %d ", mode, width, height);
}