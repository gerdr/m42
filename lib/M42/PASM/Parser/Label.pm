use v6;

module M42::PASM::Parser::Label;

role Grammar {
	token label {
		'@' <dot>? <name> ':'
	}
}

role AST {
	method label($/) {
		make :label({
			local => ?$<dot>,
			name => ~$<name>
		}).item
	}
}

role ASG {
	method label($/) {
		callsame
	}
}

#method label-decl($/) {
#	my $ast = callsame;
#	my $name = $ast<local>
#		?? $!current-chunk<name> ~ '__' ~ $ast<name>
#		!! $ast<name>;
#
#	die "redeclaration of label $name"
#		if $name ~~ %!labels;
#
#	my $label = {
#		name => $name,
#		chunk => $!current-chunk,
#		offset => +$!current-chunk<code>
#	};
#
#	%!labels{$name} = $label;
#	$!current-chunk<labels>.push($label);
#	$!current-chunk<code>.push(:$label.item);
#}

