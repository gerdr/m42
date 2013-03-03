use v6;

module M42::PASM::Parser::Arg;

role Grammar {
	token arg { <conv=.arg-conv>? <value> }
	token arg-conv { sx | zx | tr | fx | ft }
}

role AST {
	method arg($/) {
		make :arg({
			value => $<value>.ast,
			conv => $<conv> ?? ~$<conv> !! Nil
		}).item
	}
}

role ASG {
	method arg($/) {
		callsame
	}
}
