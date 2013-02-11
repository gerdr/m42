use v6;
grammar PASM::Grammar;

our $CURRENT_FILE = '?';

token TOP {
	^ \s*
	[ <chunk-decl>
	| <reg-decl>
	|| (\V+) {
		die "[%s:%i] PANIC: %s\n".sprintf($CURRENT_FILE, $/.Str.lines.Int, $0)
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
token reg-name { '%' <.name> }
token arg-name { '$' <.name> }

token reg-def { <reg-name> [ \h+ '=' \h+ <reg-init=.arg-name> ]? }

token chunk-decl { chunk \h+ <name> }
token reg-decl { <type> \h+ <reg-def>+ % <.comma> }
