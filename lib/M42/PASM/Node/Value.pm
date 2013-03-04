use v6;

module M42::PASM::Node::Value;

role Grammar {
	token value {
		[ <value=.value-indirect>
		| <value=.value-register>
		| <value=.value-integer>
		]
	}

	token value-indirect {
		<type> '(' \h*
		<base=.value-register>
		<subscript=.value-subscript>?
		\h*')'
	}

	token value-subscript {
		'[' \h*
		[ <subscript=.value-integer>
		| <subscript=.value-register>
		]
		\h* ']'
	}

	token value-register {
		<register>
	}

	token value-integer {
		<integer>
	}
}

role Parser {
	method value($/) {
		make $<value>.ast
	}

	method value-indirect($/) {
		make :iv({
			type => ~$<type>,
			base => $<base>.ast,
			subscript => $<subscript> ?? $<subscript>[0].ast !! Nil
		}).item
	}

	method value-subscript($/) {
		make $<subscript>.ast
	}

	method value-register($/) {
		make :reg(~$<register><name>).item
	}

	method value-integer($/) {
		make :int(~$<integer>).item
	}
}
