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
BACKENDS := lib/M42/PASM/Backends.pbc
DEPFILE := deps.mk
GARBAGE := $(CORE) $(CORE:%.o=%.c) $(T_SRC) $(PMS:%.pm=%.pir) $(PMS:%.pm=%.pbc)

.PHONY: build core backends
.PHONY: clean realclean
.PHONY: check check-lib check-src
.PHONY: core-ast core-asg core-dis

build core: $(CORE)

backends: $(BACKENDS)

realclean: GARBAGE += $(DEPFILE)
clean realclean:
	$(RM) $(GARBAGE)

core-ast: TARGET := ast
core-asg: TARGET := asg
core-ast core-asg: $(BACKENDS)
	$(M42_AS) --$(TARGET) src/core.pasm | $(LESS)

core-dis: $(CORE)
	$(OBJDUMP) -d $< | $(LESS)

check: check-lib check-src

check-lib: $(T_LIB)

check-src: $(T_SRC)
	t/src/core

$(CORE:%.o=%.c): %.c: %.pasm $(BACKENDS)
	$(M42_AS) --gnuc -o=$@ $<

$(CORE): %.o: %.c $(INC)/base.h
	$(GCC) $(GCCFLAGS) -c -o $@ $<

t/src/core: $(CORE) $(INC)/core.h $(INC)/base.h
$(T_SRC): %: %.c
	$(GCC) $(GCCFLAGS) -o $@ $< $(CORE)

%.pbc: %.pm
	$(PERL6) -Ilib --target=pir --output=$*.pir $*.pm
	$(PARROT) -o $*.pbc $*.pir

include $(DEPFILE)

deps.mk: $(PMS)
	$(P6_DEPS) lib > $@
