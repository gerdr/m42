use v6;
use M42::Lila::Grammar;
use M42::Lila::Parser;
role M42::Lila::Compiler is M42::Lila::Parser;

method dump { !!! }

method compile($dest, *@sources) {
	self.parse($_, slurp($_)) for @sources;
	self.validate;
	temp $*OUT = open($dest, :w);
	self.dump;
	$*OUT.flush;
}

method parse($source, $code) {
	temp $M42::Lila::Grammar::SOURCE = $source;
	M42::Lila::Grammar.parse($code, :actions(self))
}

method validate {}
