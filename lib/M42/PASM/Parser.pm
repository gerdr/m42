use v6;
use M42::PASM;
use M42::PASM::Parser::Op;
use M42::PASM::Parser::Value;
use M42::PASM::Parser::Chunk;
use M42::PASM::Parser::Struct;

module M42::PASM::Parser;

sub panic($/) {
	die sprintf "parse fail:\n[%i] %s\n", +$/.Str.lines, ~$0
}

grammar Grammar {
	also does M42::PASM::Parser::Value::Grammar;
	also does M42::PASM::Parser::Op::Grammar;
	also does M42::PASM::Parser::Chunk::Grammar;
	also does M42::PASM::Parser::Struct::Grammar;

	token TOP {
		^ <.sep>*
		[ <decl=.chunk>
		| <decl=.struct>
		|| (<-[\v\;]>+) { panic($/) }
		]* %% <.sep>+ $
	}

	token comment { '#' \V* <.eol> }

	token sep { \h* [ \v | ';' | <.comment> ] \h* }

	token eol { \v | $ }

	token comma { \h* ',' \h* }

	token dot { '.' }

	token integer { <.digit>+ | 0x <.xdigit>+ }

	token name { [ [ <[a..zA..Z0..9]>+ ]+ % '_' ]+ % '.' }

	token type { @(M42::PASM::types) }

	token register { '%' <name> }

	token global { '@' <name> }

	token usertype { ':' <name> }

	token parameter { '$' $<index>=[ <.digit>+ ] }
}

class Actions {
	also does M42::PASM::Parser::Value::Actions;
	also does M42::PASM::Parser::Op::Actions;
	also does M42::PASM::Parser::Chunk::Actions;
	also does M42::PASM::Parser::Struct::Actions;

	method TOP($/) { make [ $<decl>>>.ast ] }
}
