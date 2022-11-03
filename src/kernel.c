#include <multiboot.h>

int printf(const char *fmt, ...);

#ifndef __i386__
#error "Not building i386"
#endif


void kernel_main() {
    printf("hello world");
}

