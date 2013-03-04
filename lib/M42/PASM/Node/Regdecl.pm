use v6;

module M42::PASM::Node::Regdecl;

role Grammar {
	token regdecl {
		<type> \h+ <def=.regdecl-def>+ % <.comma>
	}

	token regdecl-def {
		<register> [ \h+ '=' \h+ <init=.parameter> ]?
	}
}

role Parser {
	method regdecl($/) {
		make self.compose($/, reg => {
			type => ~$<type>,
			defs => [ $<def>>>.ast ]
		})
	}

	method regdecl-def($/) {
		make :def({
			name => ~$<register><name>,
			init => $<init> ?? :para(~$<init>[0]<index>).item !! Nil
		}).item
	}
}
