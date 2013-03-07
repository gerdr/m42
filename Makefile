GCCPREFIX := x86_64-w64-mingw32-
GCC := $(GCCPREFIX)gcc
GCCFLAGS := -std=c99 -Werror -O3 -Iinclude
OBJDUMP := $(GCCPREFIX)objdump
RM := rm -f
LESS := less
PERL6 := perl6
PARROT := parrot

INC := include/m42
PMS := $(shell find lib -name '*.pm')
CORE := src/core.o
P6_DEPS := bin/p6-deps
M42_AS := bin/m42-as
M42_DIS := bin/m42-dis
M42_LILAC := bin/m42-lilac
T_SRC := t/src/core
T_LIB :=
GARBAGE := $(CORE) $(CORE:%.o=%.c) $(T_SRC) deps.mk \
	$(PMS:%.pm=%.pir) $(PMS:%.pm=%.pbc)

.PHONY: build clean check
.PHONY: check-lib check-src
.PHONY: core-ast core-asg core-dis

build: $(CORE)

clean:
	$(RM) $(GARBAGE)

core-ast:
	$(M42_AS) --ast src/core.pasm | $(LESS)

core-asg:
	$(M42_AS) --asg src/core.pasm | $(LESS)

core-dis: $(CORE)
	$(OBJDUMP) -d $< | $(LESS)

check: check-lib check-src

check-lib: $(T_LIB)

check-src: $(T_SRC)
	t/src/core

$(CORE:%.o=%.c): %.c: %.pasm $(PASM) lib/M42/PASM/Backends.pbc
	$(M42_AS) --gnuc -o=$@ $<

$(CORE): %.o: %.c $(INC)/base.h
	$(GCC) $(GCCFLAGS) -c -o $@ $<

t/src/core: $(CORE) $(INC)/core.h $(INC)/base.h
$(T_SRC): %: %.c
	$(GCC) $(GCCFLAGS) -o $@ $< $(CORE)

%.pbc: %.pm
	$(PERL6) -Ilib --target=pir --output=$*.pir $*.pm
	$(PARROT) -o $*.pbc $*.pir

include deps.mk

deps.mk: $(PMS)
	$(P6_DEPS) lib > $@
