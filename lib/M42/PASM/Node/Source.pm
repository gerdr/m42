use v6;
use panic;

module M42::PASM::Node::Source;

role Grammar {
	token source {
		^ <.sep>*
		[ <decl=.chunk>
		| <decl=.struct>
		|| . { panic($/) }
		]* %% <.sep>+ $
	}
}

role Parser {
	method source($/) {
		make :source([ $<decl>>>.ast ]).item
	}
}
