use v6;

module M42::PASM::Node::Arg;

role Grammar {
	token arg { <conv=.arg-conv>? <value> }
	token arg-conv { sx | zx | tr | fx | ft }
}

role Parser {
	method arg($/) {
		make self.compose($/, arg => {
			value => $<value>.ast,
			conv => $<conv> ?? ~$<conv> !! Nil
		})
	}
}
