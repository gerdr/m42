GCCPREFIX := x86_64-w64-mingw32-
GCC := $(GCCPREFIX)gcc
GCCFLAGS := -std=c99 -Werror -O3
OBJDUMP := $(GCCPREFIX)objdump
RM := rm -f
LESS := less

CORE := src/core.o
PASM := bin/m42-pasm
PASMLIBS := \
	lib/M42/PASM/Grammar.pm \
	lib/M42/PASM/Parser.pm \
	lib/M42/PASM/Compiler.pm \
	lib/M42/PASM/Compiler/GNUC.pm
GARBAGE := $(CORE) $(CORE:%.o=%.c)
BASEHEADERS := include/m42/base.h

.PHONY: build clean dis

build: $(CORE)

clean:
	$(RM) $(GARBAGE)

dis: $(CORE)
	$(OBJDUMP) -d $< | $(LESS)

$(CORE:%.o=%.c): %.c: %.pasm $(PASM) $(PASMLIBS)
	$(PASM) --gnuc $@ $<

$(CORE): %.o: %.c $(BASEHEADERS)
	$(GCC) $(GCCFLAGS) -Iinclude -c -o $@ $<
