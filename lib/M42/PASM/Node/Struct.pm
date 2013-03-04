use v6;

module M42::PASM::Node::Struct;

role Grammar {
	token struct { <!> }
}

role Parser {}

#token struct-decl {
#	$<declarator>=[ struct | union ] \h+ <struct-name> \h*
#	'{' [ <.sep> | \h+ ]?
#	<member>+ % <.sep>
#	[ <.sep> | \h+ ]? '}'
#}
#
#token basic-type { <type> }
#token struct-type { <struct-name> }
#
#token member {
#	[ <type=.basic-type>
#	| <type=.struct-type>
#	]
#	\h+ <name> [ '[' <array-dim=.integer> ']' ]*
#}
