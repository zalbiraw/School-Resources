#include "ppm.h"

char** ppm_rect(int width, int height) {
  char **pixels = (char**)malloc(height * sizeof (char*));

  // init array rows
  for (int y = 0; y < height; ++y) {
    pixels[y] = (char*)malloc(width * 3);
  }
 
  int h12 = height /2,
      w12 = width / 2,
      w13 = width / 3,
      w23 = 2 * w13;

  // draw the five rectangles
  draw_rect(pixels, RECT_1, 0, h12, w13, height);
  draw_rect(pixels, RECT_2, w13, h12, w23, height);
  draw_rect(pixels, RECT_3, w23, h12, width, height);
  draw_rect(pixels, RECT_4, 0, 0, w12, h12);
  draw_rect(pixels, RECT_5, w12, 0, width, h12);

  return pixels;
}

// draws different rectangles based on the beging and ending points
void draw_rect(char **pixels, int rect, int x0, int y0, int x1, int y1) {
  int r, g, b, step, range;
  for (int y = y0; y < y1; ++y) {
    // gets the appropriate colors for the gradiant rectangles
    step = y - y0;
    range = y1 - y0 - 1;
    r = get_color(rect + RED, step, range);
    g = get_color(rect + GREEN, step, range);
    b = get_color(rect + BLUE, step, range);

    // fills the rows with the appropriate values
    for (int x = x0 * 3; x < x1 * 3;) {
      pixels[y][x++] = r;
      pixels[y][x++] = g;
      pixels[y][x++] = b;
    }
  }
}

// helper to calculate the right gradiant colors for all rectangles
int get_color(int channel, int step, int range) {
  switch(channel) {
    case RED_1: case GREEN_2: case BLUE_3:
      return 255;

    case GREEN_1: case BLUE_1:
    case RED_3: case GREEN_3:
    case RED_4: case GREEN_4: case BLUE_4:
      return 255 - 255 * step / range;

    case RED_2: case BLUE_2:
    case RED_5: case GREEN_5: case BLUE_5:
      return 255 * step / range;

    default:
      return 0;
  }
}

// helper for printing the image in ascii format to a file
void ppm_ascii(FILE *fp, char **pixels, int width, int height) {
  for (int y = height - 1; y > -1; --y) {
    for (int x = 0; x < width * 3; x += 3) {
      fprintf(fp, "%d %d %d ",
        (unsigned char)pixels[y][x],
        (unsigned char)pixels[y][x + 1],
        (unsigned char)pixels[y][x + 2]);
    }
  }
}

// helper for printing the image in raw format to a file
void ppm_raw(FILE *fp, char **pixels, int width, int height) {
  for (int y = height - 1; y > -1; --y) {
    for (int x = 0; x < width * 3; x += 3) {
      fprintf(fp, "%c%c%c", pixels[y][x], pixels[y][x + 1], pixels[y][x + 2]);
    }
  }
}