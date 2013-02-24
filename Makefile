GCCPREFIX := x86_64-w64-mingw32-
GCC := $(GCCPREFIX)gcc
GCCFLAGS := -std=c99 -Werror -O3 -Iinclude
OBJDUMP := $(GCCPREFIX)objdump
RM := rm -f
LESS := less

INC := include/m42
CORE := src/core.o
PASM := bin/m42-as
PASMLIBS := \
	lib/M42/PASM/Grammar.pm \
	lib/M42/PASM/Parser.pm \
	lib/M42/PASM/Compiler.pm \
	lib/M42/PASM/Compiler/GNUC.pm
TESTS := t/core
GARBAGE := $(CORE) $(CORE:%.o=%.c) $(TESTS)

.PHONY: build clean check dis

build: $(CORE)

clean:
	$(RM) $(GARBAGE)

dis: $(CORE)
	$(OBJDUMP) -d $< | $(LESS)

check: $(TESTS)
	t/core

$(CORE:%.o=%.c): %.c: %.pasm $(PASM) $(PASMLIBS)
	$(PASM) --gnuc $@ $<

$(CORE): %.o: %.c $(INC)/base.h
	$(GCC) $(GCCFLAGS) -c -o $@ $<

t/core: $(CORE) $(INC)/core.h $(INC)/base.h
$(TESTS): %: %.c
	$(GCC) $(GCCFLAGS) -o $@ $< $(CORE)
