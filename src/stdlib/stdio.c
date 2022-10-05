#include <string.h>
#include <stddef.h>
#include <stdint.h>

uint16_t encode_color(uint16_t color, char ch) {
    return (uint16_t)(color << 8) | (uint16_t)ch;
}

int printf(const char *restrict fmt, ...) {

    volatile uint16_t * out = (uint16_t* )0xb8000;

    for (uint16_t i = 0; fmt[i] != '\0'; i++) {
        out[i] = encode_color(15, fmt[i]);
    }
    return 0;
}
