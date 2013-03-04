use v6;

module M42::PASM::Node::Chunk;

role Grammar {
	token chunk {
		chunk \h+ <global> [
			<.sep>+
			[ <statement=.regdecl>
			| <statement=.label>
			| <statement=.op>
			]+ % <.sep>+
		]?
	}
}

role Parser {
	method chunk($/) {
		make self.compose($/, chunk => {
			name => ~$<global><name>,
			statements => [ $<statement>>>.ast ]
		})
	}
}
