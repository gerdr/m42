PERL6 = perl6
GCCPREFIX = x86_64-w64-mingw32-
GCC = $(GCCPREFIX)gcc
GCCFLAGS = -std=c99 -Werror -O3
OBJDUMP = $(GCCPREFIX)objdump
RM = rm -f
LESS = less

PASMLIB = PASM/Grammar.pm PASM/Parser.pm PASM/Compiler.pm PASM/Compiler/GNUC.pm

build: core.o

dis: core.o
	$(OBJDUMP) -d core.o | less

core.c: core.pasm pasm.pl $(PASMLIB)
	$(PERL6) -I. pasm.pl --gnuc core.c core.pasm

core.o: core.c
	$(GCC) $(GCCFLAGS) -c -o core.o core.c

clean:
	$(RM) core.c core.o
