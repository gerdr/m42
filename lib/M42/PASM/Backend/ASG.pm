use v6;
use pretty;
use M42::Compiler;
use M42::PASM::Composer;

class M42::PASM::Backend::ASG {
	also does M42::Compiler;

	has $.indent = '  ';
	has $.grammar = M42::PASM::Grammar;
	has $.parser = M42::PASM::Composer.new;

	method dump {
		say pretty(self.parser.world.perl, :$!indent)
	}
}
