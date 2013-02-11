use v6;
use PASM::Grammar;
use PASM::Parser;
module PASM::Compiler::GNUC;

class Compiler { ... }

our sub compile($dest, *@sources) {
	my $compiler = Compiler.new;
	for @sources {
		temp $PASM::Grammar::CURRENT_FILE = .key;
		$compiler.parse(.value)
	}

	temp $*OUT = open($dest, :w);
	$compiler.dump;
}

class Compiler does PASM::Parser {
	has %!chunks;

	method parse($code) {
		say PASM::Grammar.parse($code, :actions(self))
	}

	method dump { say '__EOF__' }
}
