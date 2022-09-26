NAME   	  := imperatrix
CC     	  := gcc
AS        := gcc
SHELL  	  := /bin/bash
BUILD_DIR := build
ISO_DIR   := $(BUILD_DIR)/$(NAME)
QEMU      := qemu-system-x86_64

ASFLAGS   := -Wall -march=x86-64 -m32
CFLAGS 	  := -Wall -Wextra -Werror -Wconversion \
			 -std=c11 -ffreestanding -O2 -march=x86-64 -m32 \
			 -T linker.ld -nostdlib
CLEAN     := clean
HIDE      := @

MKDIR     := mkdir -p
CP        := cp
MV        := mv
MKRESCURE := grub-mkrescue -o $(NAME).iso
RM 		  := rm -f

.PHONY: all run
# Create build directory


include src/build.mk

OBJS := $(addprefix $(BUILD_DIR)/, $(SRCS))
OBJS := $(addsuffix .o, $(basename $(OBJS)))
SOURCE_FOLDERS := $(dir $(OBJS))

all: $(NAME)

run: $(NAME)
	$(QEMU) -kernel $(NAME)


$(NAME): $(OBJS)
	$(HIDE) $(MKDIR) $(BUILD_DIR)
	$(info $@)
	$(HIDE) $(CC) $(OBJS) -o $(NAME) $(CFLAGS)
	$(HIDE) $(MKDIR) $(ISO_DIR)/boot/grub
	$(HIDE) $(CP) grub.cfg  $(ISO_DIR)/boot/grub
	$(HIDE) $(MV) $(NAME) $(ISO_DIR)/boot
	$(HIDE) $(MKRESCURE) $(ISO_DIR)

$(BUILD_DIR)/$(SRC_PREFIX)/%.o: $(SRC_PREFIX)/%.c
	$(HIDE) $(MKDIR) $(@D)
	$(info $@)
	$(HIDE) $(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/$(SRC_PREFIX)/%.o: $(SRC_PREFIX)/%.s
	$(HIDE) $(MKDIR) $(@D)
	$(info $@)
	$(HIDE) $(AS) $(ASFLAGS) -c -o $@ $<

$(CLEAN):
	$(RM) $(BUILD_DIR)


