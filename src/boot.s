.set ALIGN, 1 << 0
.set MEMINFO, 0 << 1
.set VIDEO_MODE, 1 << 2
.set FLAGS, ALIGN | MEMINFO | VIDEO_MODE
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM
.long 0 /* header addr */
.long 0 /* load addr */
.long 0 /* load end addr */
.long 0 /* bss end addr */
.long 0 /* entry addr */
.long 1 /* video mode type, 0 = linear, 1 = EGA */
.long 0 /* width */
.long 0 /* height */
.long 0 /* depth */

.section .bss
.align 16
stack_top:
.skip 0x4000
stack_bottom:


.section .text
.align 4
.global _start
.type _start, @function
_start:
    mov $stack_bottom, %esp

    push %ebx
    call kernel_main
    add 4, %esp
    cli

/* Loop forever */
1:
    hlt
    jmp 1b

.size _start, . - _start
