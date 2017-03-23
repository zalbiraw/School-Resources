#include "decode.h"

int main(int argc, char const *argv[]) {

  if (argc < ARGC) {
    printf("%s", "Incorrect formate. Please use one of following formate:\n"
      "decode in_compressed_filename out_PGM_filename\n");
    return EXIT_FAILURE;
  }

  Decode_Using_LZ77(argv[1], argv[2]);

  return EXIT_SUCCESS;
}

void Decode_Using_LZ77(const char *in, const char *out) {

  FILE *fp = fopen(in, "r");

  if (fp == NULL) {
    printf("Unable to open file.\n");
    exit(EXIT_FAILURE);
  }

  // read pgm props
  int maxGrayValue, width, height, size;
  fscanf(fp, "%d %d %d\n", &maxGrayValue, &width, &height);

  size = width * height;
  unsigned char *pixels = (unsigned char*)malloc(size),
                c;

  // decode
  for (int i = 0, index, len; i < size; ++i) {
    fscanf(fp, "%d,%d,%c\n", &index, &len, &c);

    for (int j = 0, k = i; j < len; ++j, ++i) pixels[i] = pixels[k - index + j];

    pixels[i] = c;
  }

  fclose(fp);

  fp = fopen(out, "w");

  if (fp == NULL) {
    printf("Unable to open file.\n");
    exit(EXIT_FAILURE);
  }

  // write the pgm
  fprintf(fp, "P5\n%d %d\n%d\n", height, width, maxGrayValue);
  for (int i = 0; i < size; ++i) fprintf(fp, "%c", pixels[i]);
  fclose(fp);

}
