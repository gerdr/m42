use v6;
grammar M42::Lila::Grammar;

our $SOURCE = '?';

token TOP {
	^ \s*
	[ <!>
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
