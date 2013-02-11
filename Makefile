PERL6 = perl6
RM = rm -f

PASMLIB = PASM/Grammar.pm PASM/Parser.pm PASM/Compiler/GNUC.pm

build: core/core.c

core/core.c: core/core.pasm pasm.pl $(PASMLIB)
	$(PERL6) -I. pasm.pl --gnuc core/core.c core/core.pasm

clean:
	$(RM) core/core.c
