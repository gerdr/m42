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
