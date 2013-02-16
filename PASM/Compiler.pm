use v6;
use PASM::Grammar;
use PASM::Parser;
role PASM::Compiler is PASM::Parser;

has %.chunks;
has %.labels;
has $.current-chunk;

method dump { !!! }

method compile($dest, *@sources) {
	self.parse($_, slurp($_)) for @sources;
	self.validate;
	temp $*OUT = open($dest, :w);
	self.dump;
	$*OUT.flush;
}

method parse($source, $code) {
	temp $PASM::Grammar::SOURCE = $source;
	PASM::Grammar.parse($code, :actions(self))
}

method validate {
	# TODO
}

method reg-decl($/) {
	die "reg declaration without a chunk"
		unless defined $!current-chunk;

	sink for callsame.list {
		my $name = .<name>;
		die "redeclaration of register \%$name"
			if $name ~~ $!current-chunk<regs>;

		$!current-chunk<regs>{$name} = $_;
	}
}

method op($/) {
	die "op invocation without a chunk"
		unless defined $!current-chunk;

	my $op = callsame;
	$!current-chunk<code>.push(:$op.item);
}

method chunk-decl($/) {
	my $name = callsame;
	die "redeclaration of chunk $name"
		if $name ~~ %!chunks;

	$!current-chunk = {
		name => $name,
		regs => {},
		args => [],
		code => [],
		labels => [],
	};

	%!chunks{$name} = $!current-chunk;
}

method label-decl($/) {
	die "label declaration without a chunk"
		unless defined $!current-chunk;

	my $ast = callsame;
	my $name = $ast<local>
		?? $!current-chunk<name> ~ '__' ~ $ast<name>
		!! $ast<name>;

	die "redeclaration of label $name"
		if $name ~~ %!labels;

	my $label = {
		name => $name,
		chunk => $!current-chunk,
		offset => +$!current-chunk<code>
	};

	%!labels{$name} = $label;
	$!current-chunk<labels>.push($label);
	$!current-chunk<code>.push(:$label.item);
}
