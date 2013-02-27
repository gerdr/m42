use v6;
use M42::PASM;
grammar M42::PASM::Grammar;

our $SOURCE = '?';

token TOP {
	^ \s*
	[ <decl=.chunk-decl>
	| <decl=.reg-decl>
	| <decl=.op>
	| <decl=.label-decl>
	|| (<-[\v\;]>+) {
		die sprintf "parse fail in %s:\n[%i] %s\n",
			$SOURCE, $/.Str.lines.Int, $0
	}
	]* %% <.sep>+ $
}

token comment { '#' \V* <.eol> }
token sep { \h* [ \v | ';' | <.comment> ] \h* }
token comma { \h* ',' \h* }
token eol { \v | $ }

token type { @(M42::PASM::types) }

token name { [ [ <[a..zA..Z0..9]>+ ]+ % '_' ]+ % '.' }
token reg-name { '%' <name> }
token arg-name { '$' <number> }
token struct-name { ':' <name> }
token label { '@' <dot>? <name> }
token dot { '.' }

token reg-def { <reg-name> [ \h+ '=' \h+ <reg-init=.arg-name> ]? }

token chunk-decl { chunk \h+ '@' <name> }
token reg-decl { <type> \h+ <reg-def>+ % <.comma> }
token label-decl { <label> ':' }

token struct-decl {
	$<declarator>=[ struct | union ] \h+ <struct-name> \h*
	'{' [ <.sep> | \h+ ]?
	<XXX>+ % <.sep>
	[ <.sep> | \h+ ]? '}'
}

token op {
	[ <op=.nullary-op>
	| <op=.unary-op>
	| <op=.binary-op>
	| <op=.ternary-op>
	]
}

token value { <value=.direct-value> | <value=.indirect-value> }

token indirect-value {
	<type> '(' \h* <reg-name> [ '[' \h* <index=.constant> \h* ']' ]? \h*')'
}

token direct-value { <value=.reg-name> }
token constant { <constant=.sizeof> | <constant=.number> }
token sizeof { sizeof '(' <type> ')' }
token number { \d+ }

token nullary-op { $<name>=[ @(M42::PASM::ops(0)) ] }
token unary-op { $<name>=[ @(M42::PASM::ops(1)) ] \h+ <value> }
token binary-op { $<name>=[ @(M42::PASM::ops(2)) ] \h+ <value>**2 % <.comma> }
token ternary-op { $<name>=[ @(M42::PASM::ops(3)) ] \h+ <value>**3 % <.comma> }
