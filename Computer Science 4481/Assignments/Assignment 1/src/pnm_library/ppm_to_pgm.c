#include "libpnm.h"

int main() {
  struct PGM_Image red, green, blue;
  struct PPM_Image ppm;

  load_PPM_Image(&ppm, "ppm_300_100_raw.ppm");

  copy_PPM_to_PGM(&ppm, &red, RED);
  copy_PPM_to_PGM(&ppm, &green, GREEN);
  copy_PPM_to_PGM(&ppm, &blue, BLUE);

  save_PGM_Image(&red, "ppm_300_100.R.pgm", true);
  save_PGM_Image(&green, "ppm_300_100.G.pgm", true);
  save_PGM_Image(&blue, "ppm_300_100.B.pgm", true);

  free_PGM_Image(&red);
  free_PGM_Image(&green);
  free_PGM_Image(&blue);
  free_PPM_Image(&ppm);

  return 0;
}