use v6;

module M42::PASM::Parser::Chunk;

role Grammar {
	token chunk {
		chunk \h+ <global> <.sep>+
		[ <statement=.chunk-reg>
		| <statement=.chunk-label>
		| <statement=.op>
		]+ % <.sep>+
	}

	token chunk-reg {
		<type> \h+ <def=.chunk-reg-def>+ % <.comma>
	}

	token chunk-reg-def {
		<register> [ \h+ '=' \h+ <init=.parameter> ]?
	}

	token chunk-label {
		'@' <dot>? <name> ':'
	}
}

role Actions {
	method chunk($/) {
		make :chunk({
			name => ~$<global><name>,
			statements => [ $<statement>>>.ast ]
		}).item
	}

	method chunk-reg($/) {
		make :reg([ $<def>>>.ast.map({ .<type> = ~$<type>; $_ }) ]).item
	}

	method chunk-reg-def($/) {
		make {
			name => ~$<register><name>,
			init => $<init> ?? :arg(~$<init>[0]<index>).item !! Nil
		}
	}

	method chunk-label($/) {
		make :label({
			local => ?$<dot>,
			name => ~$<name>
		}).item
	}
}
