use v6;
use M42::PASM::Spec;
use M42::PASM::Nodes;

grammar M42::PASM::Grammar does M42::PASM::Nodes::Grammar {
	token TOP { <source> }
	token comment { '#' \V* <.eol> }
	token sep { \h* [ \v | ';' | <.comment> ] \h* }
	token eol { \v | $ }
	token comma { \h* ',' \h* }
	token dot { '.' }
	token decint { <.digit>+ }
	token hexint { 0x <.xdigit>+ }
	token integer { <.decint> | <.hexint> }
	token name { [ [ <[a..zA..Z0..9]>+ ]+ % '_' ]+ % '.' }
	token type { @(M42::PASM::Spec::types) }
	token register { '%' <name> }
	token global { '@' <name> }
	token usertype { ':' <name> }
	token parameter { '$' <index=.decint> }
}
