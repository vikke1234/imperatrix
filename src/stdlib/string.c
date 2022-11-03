#include <string.h>
#include <stddef.h>

size_t strlen(const char * str) {
    size_t len = 0ULL;
    while(str[len++])
        ; // null statement
    return len;
}

char *strcpy(char *restrict dest, const char *restrict src) {
    size_t i;
    for (i = 0ULL; src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    return dest;
}
