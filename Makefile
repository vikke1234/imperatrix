NAME   	  := imperatrix
CC     	  := gcc
AS        := gcc
SHELL  	  := /bin/bash
BUILD_DIR := build

ASFLAGS   := -Wall -march=x86-64 -m32
CFLAGS 	  := -Wall -Werror -Wconversion -std=c11 -nostartfiles -march=x86-64 -m32
CLEAN     := clean
HIDE      := @

MKDIR     := mkdir -p
RM 		  := rm -f

# Create build directory


include src/build.mk

OBJS := $(addprefix $(BUILD_DIR)/, $(SRCS))
OBJS := $(addsuffix .o, $(basename $(OBJS)))
SOURCE_FOLDERS := $(dir $(OBJS))

all: $(NAME)


$(NAME): $(OBJS)
	$(HIDE) $(MKDIR) $(BUILD_DIR)
	$(info $@)
	$(HIDE) $(CC) $(OBJS) -o $(NAME) $(CFLAGS)

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


