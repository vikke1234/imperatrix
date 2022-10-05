include src/build.mk

NAME   	  := imperatrix
AS        := gcc
SHELL  	  := /bin/bash
BUILD_DIR := build
ISO_DIR   := $(BUILD_DIR)/$(NAME)
LIBC_DIR  := $(SRC_PREFIX)/stdlib

LIBC := $(LIBC_DIR)/libc.a

ASFLAGS   := -Wall -march=x86-64 -m32
CFLAGS 	  := -Wall -Wextra -Werror -Wconversion \
			 -std=c11 -march=x86-64 -m32 -g

LDFLAGS   :=  -T linker.ld $(INCLUDE_DIRS:%=-I%) -L$(PWD) -l:src/stdlib/libc.a\
			  -nostdlib -nostdinc -fno-PIE
CPPFLAGS  :=

HIDE      := @

QEMU      := qemu-system-x86_64
MKDIR     := mkdir -p
CP        := cp
MV        := mv
MKRESCURE := grub-mkrescue
RM 		  := rm -f

.PHONY: all run clean
# Create build directory

OBJS := $(addprefix $(BUILD_DIR)/, $(SRCS))
OBJS := $(addsuffix .o, $(basename $(OBJS)))


all: $(NAME).iso $(NAME)

run: $(NAME).iso
	$(QEMU) -cdrom $(NAME).iso

run-debug:$(NAME).iso
	$(QEMU) -cdrom $(NAME).iso -s -S &
	(gdb -ex 'target remote localhost:1234' -ex 'symbol-file build/imperatrix/boot/imperatrix')

clean:
	$(RM) -r $(BUILD_DIR)

$(NAME): $(OBJS) $(LIBC)
	$(HIDE) $(MKDIR) $(BUILD_DIR)
	$(info $@)
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) $(OBJS) -o $(NAME) $(LDFLAGS) -Xlinker -Map=output.map

$(LIBC):
	(cd $(LIBC_DIR) && make)

$(NAME).iso: $(NAME)
	$(HIDE) $(MKDIR) $(ISO_DIR)/boot/grub
	$(HIDE) $(CP) grub.cfg  $(ISO_DIR)/boot/grub
	$(HIDE) $(CP) $(NAME) $(ISO_DIR)/boot
	$(HIDE) $(MKRESCURE) -o $@ $(ISO_DIR)

$(BUILD_DIR)/$(SRC_PREFIX)/%.o: $(SRC_PREFIX)/%.c
	$(HIDE) $(MKDIR) $(@D)
	$(info $@)
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $< $(LDFLAGS)

$(BUILD_DIR)/$(SRC_PREFIX)/%.o: $(SRC_PREFIX)/%.s
	$(HIDE) $(MKDIR) $(@D)
	$(info $@)
	$(HIDE) $(AS) $(ASFLAGS) -c -o $@ $< $(LDFLAGS)


