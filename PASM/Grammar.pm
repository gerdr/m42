use v6;
grammar PASM::Grammar;

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

token type {
	[ i8 | i16 | i32 | i64
	| f16 | f32 | f64
	| ptr | ref | val
	| char | int | short | long | llong
	| float | double | ldouble
	| size | ptrdiff | intmax | intptr
	]
}

token name { [ [ <[a..zA..Z0..9]>+ ]+ % '_' ]+ % '.' }
token reg-name { '%' <name> }
token arg-name { '$' <number> }
token label { '@' <dot>? <name> }
token dot { '.' }

token reg-def { <reg-name> [ \h+ '=' \h+ <reg-init=.arg-name> ]? }

token chunk-decl { chunk \h+ '@' <name> }
token reg-decl { <type> \h+ <reg-def>+ % <.comma> }
token label-decl { <label> ':' }

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

token nullary-op { $<name>=[ <!> ] }
token unary-op { $<name>=[ jmp ] \h+ <value> }
token binary-op { $<name>=[ lea ] \h+ <value>**2 % <.comma> }
token ternary-op { $<name>=[ add | fadd ] \h+ <value>**3 % <.comma> }
