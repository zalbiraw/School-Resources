#include "encode.h"

int main(int argc, char const *argv[]) {

  if (argc < ARGC) {
    printf("%s", "Incorrect formate." 
      "Please use one of following formate:\n"
      "encode in_PGM_filename searching_buffer_size compressed_filename\n");
    return EXIT_FAILURE;
  }

  Encode_Using_LZ77(argv[1], atoi(argv[2]), argv[3]);

  return EXIT_SUCCESS;
}

void Encode_Using_LZ77(const char *in, unsigned int bsize, const char *out) {

  struct PGM_Image pgm;

  char *filename = (char*)malloc(strlen(in));

  strcpy(filename, in);

  if (load_PGM_Image(&pgm, filename)) {
    printf("Unable to obtain image from input file.\n");
    exit(EXIT_FAILURE);
  }

  free(filename);

  FILE *fp = fopen(out, "w");

  if (fp == NULL) {
    printf("Unable to create file.\n");
    exit(EXIT_FAILURE);
  }

  int height  = pgm.height,
      width   = pgm.width,
      size    = pgm.maxGrayValue,
      c, max, index, len;

  linked_t  **dictionary = calloc(sizeof(linked_t), size + 1),
            *list;

  // initialize dictionary
  for (c = 0; c <= size; ++c) dictionary[c] = init();

  // add headers to the encoded file
  fprintf(fp, "%d %d %d\n", size, height, width);

  size = height * width;
  unsigned char **image = pgm.image,
                *pixels = (unsigned char*)malloc(size * sizeof(char));

  for (int i = 0, k = 0; i < height; ++i)
    for (int j = 0; j < width; ++j, ++k)
      pixels[k] = image[i][j];

  // iterate through pixels to compress them
  for (int i = 0, j, k, b = -bsize + 1; i < size; ++i, ++b) {
    c = pixels[i];
    list = dictionary[c];

    if (!list->len) {

      // add character to buffer and print results
      push(list, i);
      fprintf(fp, "0,0,%c\n", c);

    } else {

      max = -1;

      // remove any nodes outside the buffer
      if (list->head->index < b) trim_until(list, b);

      // iterate through the nodes that matched
      for (node_t *instance = list->head; instance; ) {
        
        // find the length of the match
        for (j = i, k = instance->index, len = 0;
          j < size && k < size && pixels[j] == pixels[k];
          ++j, ++k) ++len;

        // choose the prefered match based on length the position
        if (len >= max) {
          max = len;
          index = instance->index;
        }
        
        instance = instance->next;
      }

      // increment the buffer and reader pointers
      i += max;
      b += max;

      // continue if a match is not found
      if (max == -1) continue;

      // add new matches to the buffer
      for (j = i - max; j < i; ++j) {
        list = dictionary[pixels[j]];
        push(list, j);
      }

      // print result
      fprintf(fp, "%d,%d,%c\n", i - max - index, max, pixels[i]);

    }

  }

  // free dictionary and image obejects
  for (int i = 0; i <= pgm.maxGrayValue; i++) trim_until(dictionary[i], size);
  free(dictionary);
  free_PGM_Image(&pgm);
  fclose(fp);

}
