use v6;
use M42::PASM::Parser;
use M42::PASM::ASG;

role M42::PASM::Compiler;

has $.grammar = M42::PASM::Parser::Grammar;
has $.actions = M42::PASM::Parser::Actions;

has @.ast;
has %.globals;
has %.structs;

method compile($dest, *@sources) {
	self.parse($_, slurp($_)) for @sources;
	self.analyze;
	temp $*OUT = open($dest, :w);
	self.dump;
	$*OUT.close;
}

method parse($source, $code) {
	@!ast.push($!grammar.parse($code, :$!actions).ast.list)
#	CATCH {}
}

method analyze {
	sink self.dispatch($_) for @!ast
}

method dump { !!! }

method declare($key, $value) {
	die "redeclaration of global '$key'"
		if $key ~~ %!globals;

	%!globals{$key} = $value;
}

multi method dispatch($ (:key($) where 'chunk', :value($ast))) {
	M42::PASM::ASG::Chunk.new.init(self, $ast)
}
