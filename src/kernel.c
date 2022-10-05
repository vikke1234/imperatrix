#include <stdio.h>
#include <stdint.h>
#include <multiboot.h>

#ifndef __linux__
#error "Will not compile on non linux platforms"
#endif

#ifndef __i386__
#error "Not building i386"
#endif


void kernel_main() {
    printf("hello world");
}

