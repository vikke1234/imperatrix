include src/build.mk

NAME   	  := imperatrix
AS 		  := clang
CC 		  := clang
BUILD_DIR := build
ISO_DIR   := $(BUILD_DIR)/$(NAME)

LIBC := $(LIBC_DIR)/libc.a

CFLAGS 	  := -Wall \
			 -Wextra \
			 -Werror \
			 -Wconversion \
			 -std=c11 \
			 -nostdlib \
			 --target=i686-elf \
			 -m32 \
			 -g \

ASFLAGS   := $(CFLAGS) -Wno-unused-command-line-argument

LDFLAGS   :=  -T linker.ld -L$(PWD) -static -nostdlib -fno-PIE -ffreestanding  -nostartfiles
CPPFLAGS  := $(INCLUDE_DIRS:%=-I%)

ARFLAGS   := -rcs --target=elf32-i386

HIDE      := @

QEMU      := qemu-system-i386
MKDIR     := mkdir -p
CP        := cp
MV        := mv
MKRESCURE := grub-mkrescue
RM 		  := rm -f

.PHONY: all run clean
# Create build directory

C_OBJS := $(patsubst %.c, $(BUILD_DIR)/%.o, $(filter %.c, $(SRCS)))

AS_OBJS := $(patsubst %.s, $(BUILD_DIR)/%.o, $(filter %.s, $(SRCS)))
$(info $(AS_OBJS))

LIBC_OBJS := $(patsubst %.c, $(BUILD_DIR)/%.o, $(LIBC_SRCS))

C_RULES := $(C_OBJS:%.o=%.dep)
C_RULES := $(filter %.dep, $(RULES))

LIBC_RULES += $(LIBC_SRCS:%.c=$(BUILD_DIR)/%.dep)
LIBC_RULES := $(filter %.dep, $(LIBC_RULES))

all: $(NAME)

$(BUILD_DIR):
	$(MKDIR) $(BUILD_DIR)

run: $(NAME).iso
	$(QEMU) -cdrom $(NAME).iso

run-debug:$(NAME).iso
	$(QEMU) -cdrom $(NAME).iso -s -S &
	(gdb -ex 'target remote localhost:1234' -ex 'symbol-file build/imperatrix/boot/imperatrix')

clean:
	$(RM) -r $(BUILD_DIR)

$(NAME): $(C_OBJS) $(AS_OBJS) $(LIBC) linker.ld | $(BUILD_DIR)
	$(HIDE) $(MKDIR) $(BUILD_DIR)
	$(info $@)
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) $(C_OBJS) $(AS_OBJS) -o $(NAME) $(LDFLAGS) $(LIBC) -Xlinker -Map=output.map

$(LIBC): $(LIBC_OBJS)
	$(HIDE) $(AR) $(ARFLAGS) $@ $^

$(NAME).iso: $(NAME) grub.cfg
	$(HIDE) $(MKDIR) $(ISO_DIR)/boot/grub
	$(HIDE) $(CP) grub.cfg  $(ISO_DIR)/boot/grub
	$(HIDE) $(CP) $(NAME) $(ISO_DIR)/boot
	$(HIDE) $(MKRESCURE) -o $@ $(ISO_DIR)

$(BUILD_DIR)/$(SRC_PREFIX)/%.dep: $(SRC_PREFIX)/%.c
	$(HIDE) $(MKDIR) $(@D)
	$(info $(@:.o,.dep))
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) -MM -MF $(patsubst %.o,$(BUILD_DIR)/%.dep, $(notdir $@)) -MT $(BUILD_DIR)/$@ $<

$(BUILD_DIR)/$(SRC_PREFIX)/%.o: $(SRC_PREFIX)/%.c
	$(HIDE) $(MKDIR) $(@D)
	$(info $(@:.o,.dep))
	$(info $(CFLAGS))
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(BUILD_DIR)/$(SRC_PREFIX)/stdlib/%.o : $(SRC_PREFIX)/stdlib/%.c
	$(info Building stdlib $@)
	$(CC) -c -o $@ $(CFLAGS) $(CPPFLAGS) $<

$(BUILD_DIR)/$(SRC_PREFIX)/stdlib/%.dep: $(SRC_PREFIX)/stdlib/%.c
	$(HIDE) $(MKDIR) $(@D)
	$(info Building $@, $<)
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) -MM -MF $(patsubst %.o,$(BUILD_DIR)/$(LIBC_DIR)/%.dep, $(notdir $@)) -MT $(BUILD_DIR)/$(LIBC_DIR)/$@ $<

$(BUILD_DIR)/$(SRC_PREFIX)/%.o: $(SRC_PREFIX)/%.s
	$(HIDE) $(MKDIR) $(@D)
	$(info $@)
	$(HIDE) $(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

include $(LIBC_RULES)
include $(C_RULES)
