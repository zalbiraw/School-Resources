#include "rectangles.h"

int main(int argc, char const *argv[])
{
  char type, format;
  int width, height;
  char const* output;

  // validate input arguments
  validator(argc, argv,
    &type, &width, &height, &output, &format);

  // open file specified by the arguments
  FILE *fp = open_file(type, output);

  // write PNM headers to the file
  write_headers(fp, type, width, height, format);

  char **pixels;
  switch(type) {
    case PBM:
      // create pbm image and store it in a char 2d array
      pixels = pbm_rect(width, height);
      
      // print image to file
      if (format == ASCII) {
        // print image in ascii format to file
        pbm_ascii(fp, pixels, width, height);
      } else {
        // print image in raw format to file
        pbm_raw(fp, pixels, width, height);
      }

      break;

    case PGM:
      // add max gray value to the PNM image headers
      fprintf(fp, "255 ");
      // create pgm image and store it in a char 2d array
      pixels = pgm_rect(width, height);
      
      // print image to file
      if (format == ASCII) {
        // print image in ascii format to file
        pgm_ascii(fp, pixels, width, height);
      } else {
        // print image in raw format to file
        pgm_raw(fp, pixels, width, height);
      }

      break;

    case PPM:
      // add max gray value to the PNM image headers
      fprintf(fp, "255 ");
      // create ppm image and store it in a char 2d array
      pixels = ppm_rect(width, height);
      
      // print image to file
      if (format == ASCII) {
        // print image in ascii format to file
        ppm_ascii(fp, pixels, width, height);
      } else {
        // print image in raw format to file
        ppm_raw(fp, pixels, width, height);
      }

      break;
  }

  // free pixels array
  for (int y = 0; y < height; ++y) {
    free(pixels[y]);
  }
  free(pixels);
  
  fclose(fp);

  return EXIT_SUCCESS;
}
