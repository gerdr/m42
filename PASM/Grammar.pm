use v6;
grammar PASM::Grammar;

our $SOURCE = '?';

token TOP {
	^ \s*
	[ <decl=.chunk-decl>
	| <decl=.reg-decl>
	| <decl=.op>
	| <decl=.label-decl>
	|| (\V+) {
		die "parse fail in %s:\n[%i] %s\n".sprintf(
			$SOURCE, $/.Str.lines.Int, $0)
	}
	]* %% <.sep>+ $
}

token comment { '#' \V* <.eol> }
token sep { \h* [ \v | <.comment> ] \h* }
token comma { \h* ',' \h* }
token eol { \v | $ }
token alnum { <[a..zA..Z0..9]> }

token type {
	[ i8 | i16 | i32 | i64
	| f16 | f32 | f64
	| ptr | ref | reg
	| char | int | short | long | llong
	| float | double | ldouble
	| size | ptrdiff | intmax | intptr
	]
}

token name { <.alnum> [ <.alnum> | '_' <![_]> | '.' ]* }
token reg-name { '%' <name> }
token arg-name { '$' <[0..9]>+ }
token label { '@' <dot>? <name> }
token star { '*' }
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

token value { <value=.bare-value> | <value=.typed-value> }
token typed-value { <type> '(' <bare-value> ')' }
token bare-value { <star>? <reg-name> [ ':' <offset> ]? }
token offset { <constant> }
token constant { <sizeof> }
token sizeof { sizeof '(' <type> ')' }

token nullary-op { <!> }
token unary-op { $<name>=[ jmp ] \h+ <value> }
token binary-op { $<name>=[ lea ] \h+ <value>**2 % <.comma> }
token ternary-op { $<name>=[ add | fadd ] \h+ <value>**3 % <.comma> }
