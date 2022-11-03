NAME := libc.a

MKDIR := mkdir -p
HIDE := @
CC := clang

BUILD_DIR := build

CFLAGS    := -Wall -Werror -Wextra -m32\
			 --target=x86_64
CPPFLAGS  := -I$(PWD)
LDFLAGS   := -nostartfiles -nostdlib
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
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.dep: %.c | $(BUILD_DIR)
	$(HIDE) $(CC) $(CFLAGS) $(CPPFLAGS) -M -MF $@ -MT $(@:.dep=.o) $^

$(BUILD_DIR):
	$(HIDE) $(MKDIR) $@


-include $(RULES)
