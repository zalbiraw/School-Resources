#include "decode.h"

int main(int argc, char const *argv[]) {
  
  if (argc < ARGC) {

    printf("%s", "Incorrect format. Please use one of following format:\n"
      "./decode in_compressed_filename out_PGM_filename\n");

    return EXIT_FAILURE;

  }

  char *in    = (char*)malloc(strlen(argv[1]) + 1),
        *out  = (char*)malloc(strlen(argv[2]) + 1);

  strcpy(in, argv[1]);
  strcpy(out, argv[2]);

  // call decoder function with the obtained parameters.
  lossless_DPCM_Decoder(in, out);

  // free allocated spaces for the filenames
  free(in);
  free(out);

  return EXIT_SUCCESS;

}

void lossless_DPCM_Decoder(char *in, char *out) {

  // open encoded file.
  FILE *fp = open_file(in, READ);
  int height, width, maxGrayValue, rule, **pixels;

  // read pgm and decode props.
  fscanf(fp, "%d %d %d %d\n", &height, &width, &maxGrayValue, &rule);

  pixels = (int**)malloc(sizeof(int*) * height);

  // initialize pixels array.
  for (int i = 0; i < height; ++i) {

    // initialize pixels array's rows.
    pixels[i] = (int*)malloc(sizeof(int) * width);

    // fill the pixels array with the encoded values.
    for (int j = 0; j < width; ++j)
      fscanf(fp, "%d ", &pixels[i][j]);

  }

  fclose(fp);

  // initialize the predictor_t object.
  predictor_t predictor = {
    .height = height,
    .width = width,
    .pixels = pixels,
    .result = pixels
  };

  // call the dpcm function.
  dpcm(rule, &predictor);

  fp = open_file(out, WRITE);

  // write the pgm to the out file
  fprintf(fp, "P5\n%d %d\n%d\n", width, height, maxGrayValue);
  for (int i = 0; i < height; ++i)
    for (int j = 0; j < width; ++j)
      fprintf(fp, "%c", (unsigned char)pixels[i][j]);

  fclose(fp);

}
