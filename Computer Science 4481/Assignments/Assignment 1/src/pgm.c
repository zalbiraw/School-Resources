#include "pgm.h"

char** pgm_rect(int width, int height) {
  char **pixels = (char**)malloc(height * sizeof (char*));

  int x0 = width / 4,
      y0 = height / 4,
      x1 = (2 * x0) - 1,
      y1 = (2 * y0) - 1,
      dx = abs(x1 - x0),
      dy = abs(y1 - y0),
      sx = x0 < x1 ? 1 : -1,
      sy = y0 < y1 ? 1 : -1,
      err = (dx > dy ? dx : -dy) / 2,
      e2;

  // initializing image rows and set pixels to black
  for (int y = 0; y < height; ++y) {
    pixels[y] = (char*)malloc(width);
    for (int x = 0; x < width; ++x) {
      pixels[y][x] = 0;
    }
  }
 
  //Count Bresenham's steps
  int x = x0,
      y = y0,
      steps = 0;

  while(1) {
    steps++;
    if (x == x1 && y == y1) break;

    e2 = err;
    if (e2 >-dx) { err -= dy; x += sx; }
    if (e2 < dy) { err += dx; y += sy; }
  }

  // use Bresenham's line drawing algorithm to iterate along a line
  // from (width / 4, height / 4) to center and draw cols and rows
  // with respect to the line.
  int color = 255;
  float a = (float)color / (steps - 1);

  x = x0;
  y = y0;

  steps = 0;
  while(1) {
    color = 255 - steps++ * a;
    // draw rows and cols as function iterates along the diagonal line
    draw_col(pixels, color, x, width - x, y);
    draw_col(pixels, color, x, width - x, height - y - 1);
    draw_row(pixels, color, y, height - y, x);
    draw_row(pixels, color, y, height - y, width - x - 1);

    if (x == x1 && y == y1) break;

    e2 = err;
    if (e2 >-dx) { err -= dy; x += sx; }
    if (e2 < dy) { err += dx; y += sy; }
  }

  return pixels;
}

// helper for initializing pixel values for rows in the image
void draw_col(char **pixels, char color, int x0, int x1, int y) {
  for (int x = x0; x < x1; ++x) {
    pixels[y][x] = color;
  }
}

// helper for initializing pixel values for columns in the image
void draw_row(char **pixels, char color, int y0, int y1, int x) {
  for (int y = y0; y < y1; ++y) {
    pixels[y][x] = color;
  }
}

// helper for printing the image in ascii format to a file
void pgm_ascii(FILE *fp, char **pixels, int width, int height) {
  for (int y = height - 1; y > -1; --y) {
    for (int x = 0; x < width; ++x) {
      fprintf(fp, "%d ", (unsigned char)pixels[y][x]);
    }
  }
}

// helper for printing the image in raw format to a file
void pgm_raw(FILE *fp, char **pixels, int width, int height) {
  for (int y = height - 1; y > -1; --y) {
    for (int x = 0; x < width; ++x) {
      fprintf(fp, "%c", pixels[y][x]);
    }
  }
}