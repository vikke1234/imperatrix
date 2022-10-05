SRC_PREFIX   := src
SRCS 		 := kernel.c boot.s
INCLUDE_DIRS := stdlib
INCLUDE_DIRS := $(INCLUDE_DIRS:%=$(PWD)/$(SRC_PREFIX)/%)
SRCS := $(SRCS:%=$(SRC_PREFIX)/%)
