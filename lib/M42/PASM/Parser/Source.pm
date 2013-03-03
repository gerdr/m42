use v6;

module M42::PASM::Parser::Source;

role Grammar {
	token source {
		^ <.sep>*
		[ <decl=.chunk>
		| <decl=.struct>
		|| . { self.cry($/) }
		]* %% <.sep>+ $
	}
}

role AST {
	method source($/) {
		make :source([ $<decl>>>.ast ]).item
	}
}

role ASG {}
