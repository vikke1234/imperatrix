SRC_PREFIX   := src
LIBC_DIR  := $(SRC_PREFIX)/stdlib

SRCS 		 := \
				kernel.c \
				boot.s
LIBC_SRCS 	 := \
				stdio.c \
				string.c

INCLUDE_DIRS := stdlib
INCLUDE_DIRS := $(INCLUDE_DIRS:%=$(PWD)/$(SRC_PREFIX)/%)

SRCS 	  := $(SRCS:%=$(SRC_PREFIX)/%)
LIBC_SRCS := $(LIBC_SRCS:%=$(LIBC_DIR)/%)
