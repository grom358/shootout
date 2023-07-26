#ifndef __FILE_READALL_H__
#define __FILE_READALL_H__

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

/* Size of each input chunk to be read and allocate for. */
#ifndef READALL_CHUNK
#define READALL_CHUNK 2097152
#endif

#define READALL_OK 0       /* Success */
#define READALL_INVALID -1 /* Invalid parameters */
#define READALL_ERROR -2   /* Stream error */
#define READALL_TOOMUCH -3 /* Too much input */
#define READALL_NOMEM -4   /* Out of memory */

/* This function returns one of the READALL_ constants above.
 * If the return value is zero == READALL_OK, then:
 *   (*dataptr) points to a dynamically allocated buffer, with
 *   (*sizeptr) chars read from the file.
 *   The buffer is allocated for one extra char, which is NUL,
 *   and automatically appended after the data.
 * Initial values of (*dataptr) and (*sizeptr) are ignored.
 */
int readall(FILE *in, char **dataptr, size_t *sizeptr);

#endif
