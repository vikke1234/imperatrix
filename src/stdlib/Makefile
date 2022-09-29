NAME := libc.a

MKDIR := mkdir -p

BUILD_DIR := build

CFLAGS    := -nostdlib -nostdinc -nostartfiles -Wall -Werror -Wextra
CPPFLAGS  := -I$(PWD)
ARFLAGS   := -rcs --target=elf32-x86-64

SRCS := \
		string.c \
		stdio.c

RULES := $(SRCS:%.c=$(BUILD_DIR)/%.dep)
OBJS  := $(SRCS:%.c=$(BUILD_DIR)/%.o)

.PHONY: all

all: $(NAME)

clean:
	$(RM) $(NAME)
	$(RM) -r $(BUILD_DIR)

$(NAME): $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)

$(BUILD_DIR)/%.o: %.c
	$(info building $@, dependencies $^)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.dep: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) -M -MF $@ -MT $(@:.dep=.o) $^

$(BUILD_DIR):
	$(MKDIR) $@


-include $(RULES)
