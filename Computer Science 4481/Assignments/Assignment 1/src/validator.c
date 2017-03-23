#include "validator.h"

void validator(int argc, char const *argv[],
  char* type, int* width, int* height,
  char const** output, char* format)
{
  // check if the number of arguments is valid
  if (argc != ARG_NUM) {
    printf("Incorrect number of arguments." 
      "Please provide the following arguments:\n"
      "1. Image type code [1-3]\n"
      "2. Width\n"
      "3. Height\n"
      "4. Output name\n"
      "5. Format code [1-2]\n");

    exit(EXIT_FAILURE);
  }

  *type = *argv[TYPE_CODE];
  *width = atoi(argv[WIDTH]);
  *height = atoi(argv[HEIGHT]);
  *output = argv[OUTPUT];
  *format = *argv[FORMAT];

  // validate the image type code input
  if (strlen(argv[TYPE_CODE]) != 1 || (
      *type != PBM &&
      *type != PGM &&
      *type != PPM)) {
    printf("Please input a number between 1-3 for the image type code.\n");
    exit(EXIT_FAILURE);
  }
  
  // validate the image width input
  if (*type == PPM) {
    validate_dimensions("Width", *width, PPM_WIDTH_DIVSOR);
  } else {
    validate_dimensions("Width", *width, PBM_PGM_WIDTH_DIVSOR);
  }

  // validate the image height input
  validate_dimensions("Height", *height, HEIGHT_DIVSOR);

  // validate the image format code input
  if (strlen(argv[FORMAT]) != 1 || (
      *format != ASCII &&
      *format != RAW)) {
    printf("Please input a number between 0-1 for the image format code.\n");
    exit(EXIT_FAILURE);
  }
}

// validate helper, to validate the width and height inputs
void validate_dimensions(char const *dimension, int width, int divisor) {
  if (width < divisor || width % divisor) {
    printf("%s must be divisble by %d and greater than or eaqual to %d.\n",
      dimension, divisor, divisor);
    exit(EXIT_FAILURE);
  }
}