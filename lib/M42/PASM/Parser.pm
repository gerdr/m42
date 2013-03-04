use v6;
use M42::PASM::Nodes;

class M42::PASM::Parser {
	also does M42::PASM::Nodes::Parser;

	has @.ast;

	method TOP($/) {
		my $source = $<source>.ast;
		@!ast.push($source);
		make $source;
	}

	multi method compose($/, *%args where 1) {
		%args.pairs[0]
	}
}
