#include "file_readall.h"
#include "lexer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * CSV requires " characters to be converted to "". Returns the escaped string.
 * If no escaping is required returns back src.
 *
 * (*src) The string to be converted. Does not need to be null terminated.
 * (length) The length of the string.
 * (*quote_count) Output parameter indicating the number of quote characters
 * that were escaped.
 */
char *csv_escape(const char *src, int length, int *quote_count) {
  *quote_count = 0;
  // Pass 1. Calculate number of quote characters.
  for (int i = 0; i < length; ++i) {
    if (src[i] == '"') {
      ++(*quote_count);
    }
  }
  if (quote_count == 0) {
    return (char *)src;
  } else {
    // Pass 2. Replace " characters with ""
    char *ret = malloc(length + *quote_count + 1);
    if (ret == NULL) {
      return NULL;
    }
    char *dst = ret;
    for (int i = 0; i < length; ++i) {
      if (src[i] == '"') {
        *dst = '"';
        ++dst;
      }
      *dst = src[i];
      ++dst;
    }
    *dst = '\0';
    return ret;
  }
}

int main(int argc, char** argv) {
  if (argc < 3) {
    fprintf(stderr, "Usage: %s <input-file> <output-file>\n", argv[0]);
    return 1;
  }
  FILE *file = fopen(argv[1], "rb");
  if (!file) {
    perror("fopen");
    return 1;
  }

  char *input;
  size_t file_size;
  int ret = readall(file, &input, &file_size);

  fclose(file);

  if (ret != READALL_OK) {
    fprintf(stderr, "Error reading input!");
    return 1;
  }

  FILE *out = fopen(argv[2], "wb");
  if (!out) {
    perror("fopen");
    return 1;
  }

  Lexer *l = lexer_new(input, file_size);
  Token t;
  for (;;) {
    lexer_next_token(l, &t);
    if (t.type == TT_EOF) {
      break;
    }
    int length = t.length;
    char *text = t.str;
    if (t.type == TT_STRING) {
      ++text;
      length -= 2;
    }
    int quote_count = 0;
    if (t.type == TT_STRING || t.type == TT_COMMENT) {
      text = csv_escape(text, length, &quote_count);
      if (text == NULL) {
        fprintf(stderr, "Out of memory!");
        return 1;
      }
      length += quote_count;
    }
    fprintf(out, "%zu,%zu,\"%.*s\",\"%s\"\n", t.line_no, t.col_no, length, text,
           token_type_str(t.type));
    if (quote_count > 0) {
      free(text);
    }
  }
  free(l);
  fclose(out);
  return 0;
}
