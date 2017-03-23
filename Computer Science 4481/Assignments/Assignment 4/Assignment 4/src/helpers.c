#include "helpers.h"

void load_image(struct PGM_Image *pgm, char *filename) {

  if (load_PGM_Image(pgm, filename)) {
    printf("Unable to obtain image from input file.\n");
    exit(EXIT_FAILURE);
  }

}

FILE* open_file(char *filename, const char* mode) {

  FILE *fp = fopen(filename, mode);

  if (fp != NULL) return fp;

  printf("Unable to open/create file.\n");
  exit(EXIT_FAILURE);

}
