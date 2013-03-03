GCCPREFIX := x86_64-w64-mingw32-
GCC := $(GCCPREFIX)gcc
GCCFLAGS := -std=c99 -Werror -O3 -Iinclude
OBJDUMP := $(GCCPREFIX)objdump
RM := rm -f
LESS := less

INC := include/m42
CORE := src/core.o
M42_AS := bin/m42-as
M42_DIS := bin/m42-dis
M42_LILAC := bin/m42-lilac
LIBS := $(shell find lib -type f)
T_SRC := t/src/core
T_LIB :=
GARBAGE := $(CORE) $(CORE:%.o=%.c) $(T_SRC)

.PHONY: build clean check checl-lib check-src dis

build: $(CORE)

clean:
	$(RM) $(GARBAGE)

dis: $(CORE)
	$(OBJDUMP) -d $< | $(LESS)

check: check-lib check-src

check-lib: $(T_LIB)

check-src: $(T_SRC)
	t/src/core

$(CORE:%.o=%.c): %.c: %.pasm $(PASM) $(LIBS)
	$(M42_AS) --gnuc -o $@ $<

$(CORE): %.o: %.c $(INC)/base.h
	$(GCC) $(GCCFLAGS) -c -o $@ $<

t/src/core: $(CORE) $(INC)/core.h $(INC)/base.h
$(T_SRC): %: %.c
	$(GCC) $(GCCFLAGS) -o $@ $< $(CORE)
