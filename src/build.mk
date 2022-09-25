SRC_PREFIX := src
SRCS := boot.s kernel.c
SRCS := $(SRCS:%=$(SRC_PREFIX)/%)
