#include <string.h>
#include <stddef.h>

char * const restrict out = (char * const restrict) 0xb8000;

int printf(const char *restrict fmt, ...) {
    for(size_t i = 0; i < strlen(fmt); i++) {
        char current = fmt[i];

        out[i] = current;
    }

    return 0;
}
