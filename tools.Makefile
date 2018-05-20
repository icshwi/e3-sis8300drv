
SUBDIRS :=         \
	acquisition    \
	flash          \
	i2c_rtm        \
	irq            \
	memory         \
	mmap           \
	output         \
	performance    \
	register       \
	remove         \
	speed          \
	i2c_temp

FILES := $(foreach dir,$(SUBDIRS),$(wildcard $(dir)/*))
SOURCES := $(filter %.c,$(FILES))
OBJECTS := $(SOURCES:.c=)

CC := gcc

CCFLAGS := -O3 -std=c99 -D_GNU_SOURCE -Wall -I../include -I../lib

USR_LDFLAGS = -Wl,--enable-new-dtags
USR_LDFLAGS += -Wl,-rpath=$(E3_MODULES_INSTALL_LOCATION_LIB)/linux-x86_64
USR_LDFLAGS += -L$(E3_MODULES_INSTALL_LOCATION_LIB)/linux-x86_64
USR_LDFLAGS += -lsis8300drv
USR_LDFLAGS += -lrt -lm -ludev

name2 := $(lastword $(MAKEFILE_LIST))


all:
	@make -f $(name2) $(OBJECTS)

%: %.c
	$(CC) $(CCFLAGS) $(USR_LDFLAGS) -o $@ $<

clean:
	rm $(OBJECTS)
