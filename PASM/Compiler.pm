use v6;
use PASM::Grammar;
use PASM::Parser;
role PASM::Compiler is PASM::Parser;

has %.chunks;
has $.current-chunk;
has %.labels;

method dump { !!! }

method compile($dest, *@sources) {
	self.parse($_, slurp($_)) for @sources;
say %!chunks.perl;
	temp $*OUT = open($dest, :w);
	self.dump;
	$*OUT.flush;
}

method parse($source, $code) {
	temp $PASM::Grammar::SOURCE = $source;
	PASM::Grammar.parse($code, :actions(self))
}

method op($/) {
	my $op = callsame;
	die "op invocation without a chunk"
		unless defined $!current-chunk;

	$!current-chunk<code>.push(:$op.item);
}

method chunk-decl($/) {
	my $name = callsame;
	die "redeclaration of chunk $name"
		if $name ~~ %!chunks;

	$!current-chunk = {
		name => $name,
		regs => [],
		code => []
	};

	%!chunks{$name} = $!current-chunk;
}

method label-decl($/) {
	my $label = callsame;
	die "label declaration without a chunk"
		unless defined $!current-chunk;

	my $name = $label<local>
		?? $!current-chunk<name> ~ '__' ~ $label<name>
		!! $label<name>;

	die "redeclaration of label $name"
		if $name ~~ %!labels;

	%!labels{$name} = {
		chunk => $!current-chunk,
		offset => +$!current-chunk<code>
	};

	$!current-chunk<code>.push(:label($name).item);
}
