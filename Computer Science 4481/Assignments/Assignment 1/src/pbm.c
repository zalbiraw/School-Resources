#include "pbm.h"

char** pbm_rect(int width, int height) {
  char pixel,
    **pixels = (char**)malloc(height * sizeof (char*));
  int w1 = width/4,
    w3 = 3 * w1,
    h1 = height/4,
    h3 = 3 * h1;

  // draw rectangles
  for (int y = 0; y < height; ++y) {
    pixels[y] = (char*)malloc(width);

    for (int x = 0; x < width; ++x) {
      pixel = 0;

      // black rectangles
      if (x < w1 || w3 <= x || y < h1 || h3 <= y) {
        pixel = 1;
      }

      pixels[y][x] = pixel;
    }
  }

  // draw intersecting lines
  draw_line(pixels, w1, h1, w3 - 1, h3 - 1);
  draw_line(pixels, w3 - 1, h1, w1, h3 - 1);

  return pixels;
}

// use Bresenham's algorithm to draw line
void draw_line(char **pixels, int x0, int y0, int x1, int y1) {
  int dx = abs(x1 - x0),
      dy = abs(y1 - y0),
      sx = x0 < x1 ? 1 : -1,
      sy = y0 < y1 ? 1 : -1,
      err = (dx > dy ? dx : -dy) / 2,
      e;
 
  // iterate until line is complete
  while(1) {
    pixels[y0][x0] = 1;

    // break when x1, y1 is reached
    if (x0 == x1 && y0 == y1) break;

    // increment based on the value of the err
    e = err;
    if (e >-dx) { err -= dy; x0 += sx; }
    if (e < dy) { err += dx; y0 += sy; }
  }
}

// helper for printing the image in ascii format to a file
void pbm_ascii(FILE *fp, char **pixels, int width, int height) {
  for (int y = height - 1; y > -1; --y) {
    for (int x = 0; x < width; ++x) {
      fprintf(fp, "%d ", pixels[y][x]);
    }
  }
}

// helper for printing the image in raw format to a file
void pbm_raw(FILE *fp, char **pixels, int width, int height) {
  char pixel = 0;
  int k = 7;

  for (int y = height - 1; y > -1; --y) {
    for (int x = 0; x < width; ++x) {
      // shift values and or with pixel to pack the byte
      pixel |= pixels[y][x] << k--;

      // print and rest byte when full
      if (k == -1) {
        fprintf(fp, "%c", pixel);
        k = 7;
        pixel = 0;
      }
    }

    // fill the remainder of the yth-row byte with zero bits
    while (k != 7) {
      pixel |= 0 << k--;
      
      // print and rest byte
      if (k == -1) {
        fprintf(fp, "%c", pixel);
        k = 7;
        pixel = 0;
      }
    }
  }
}