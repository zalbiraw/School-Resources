#include "encode.h"

int main(int argc, char const *argv[]) {
  
  if (argc < ARGC) {

    printf("%s", "Incorrect format. Please use one of following format:\n"
      "./encode in_PGM_filename prediction_rule_number out_filename, "
      "the following rules are available: - \n"
      "\t1. W"
      "\t2. N"
      "\t3. W/2 +N/2"
      "\t4. CALIC initial prediction");

    return EXIT_FAILURE;

  }

  char *in    = (char*)malloc(strlen(argv[1]) + 1),
        *out  = (char*)malloc(strlen(argv[3]) + 1);

  strcpy(in, argv[1]);
  strcpy(out, argv[3]);

  // call encoder function with the obtained parameters.
  lossless_DPCM_Encoder(in, atoi(argv[2]), out);

  // free allocated spaces for the filenames
  free(in);
  free(out);

  return EXIT_SUCCESS;

}

void lossless_DPCM_Encoder(char *in, int rule, char *out) {

  struct PGM_Image pgm;

  load_image(&pgm, in);

  FILE *fp = open_file(out, WRITE);

  int height        = pgm.height,
      width         = pgm.width,
      maxGrayValue  = pgm.maxGrayValue;

  // print headers to the output file.
  fprintf(fp, "%d %d %d %d\n", height, width, maxGrayValue, rule);

  unsigned char **image = pgm.image,
                **result = (unsigned char**)malloc(sizeof(unsigned char*) * height);

  // initialize results array.
  for (int i = 0; i < height; ++i)
    result[i] = (unsigned char*)malloc(sizeof(unsigned char) * width);

  // initialize the predictor_t object.
  predictor_t predictor = {
    .height  = height,
    .width   = width,
    .image   = image,
    .result  = result
  };

  // call the dpcm function.
  dpcm(rule, &predictor);

  // print encoded pixels to the out file.
  for (int i = 0; i < height; ++i)
    for (int j = 0; j < width; ++j)
      fprintf(fp, "%c", result[i][j]);

  fclose(fp);
}
