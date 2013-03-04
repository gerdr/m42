use v6;
use M42::PASM::Spec;
use M42::PASM::ASG;
use M42::PASM::Parser::Op;
use M42::PASM::Parser::Arg;
use M42::PASM::Parser::Value;
use M42::PASM::Parser::Chunk;
use M42::PASM::Parser::Struct;
use M42::PASM::Parser::Label;
use M42::PASM::Parser::Source;
use M42::PASM::Parser::Regdecl;

module M42::PASM::Parser;

my role Crier {
	method cry($/, $msg = 'parse fail') {
		my $no = +$/.orig.substr(0, $/.to).lines;
		my $line := $/.orig.lines[$no-1];
		die "$msg:\n[$no] $line";
	}
}

grammar Grammar does Crier {
	also does M42::PASM::Parser::Value::Grammar;
	also does M42::PASM::Parser::Op::Grammar;
	also does M42::PASM::Parser::Arg::Grammar;
	also does M42::PASM::Parser::Chunk::Grammar;
	also does M42::PASM::Parser::Struct::Grammar;
	also does M42::PASM::Parser::Label::Grammar;
	also does M42::PASM::Parser::Source::Grammar;
	also does M42::PASM::Parser::Regdecl::Grammar;

	token TOP { <source> }

	token comment { '#' \V* <.eol> }

	token sep { \h* [ \v | ';' | <.comment> ] \h* }

	token eol { \v | $ }

	token comma { \h* ',' \h* }

	token dot { '.' }

	token integer { <.digit>+ | 0x <.xdigit>+ }

	token name { [ [ <[a..zA..Z0..9]>+ ]+ % '_' ]+ % '.' }

	token type { @(M42::PASM::Spec::types) }

	token register { '%' <name> }

	token global { '@' <name> }

	token usertype { ':' <name> }

	token parameter { '$' $<index>=[ <.digit>+ ] }
}

class AST does Crier {
	also does M42::PASM::Parser::Value::AST;
	also does M42::PASM::Parser::Op::AST;
	also does M42::PASM::Parser::Arg::AST;
	also does M42::PASM::Parser::Chunk::AST;
	also does M42::PASM::Parser::Struct::AST;
	also does M42::PASM::Parser::Label::AST;
	also does M42::PASM::Parser::Source::AST;
	also does M42::PASM::Parser::Regdecl::AST;

	has @.ast;

	method TOP($/) {
		my $ast = $<source>.ast;
		@!ast.push($ast);
		make $ast;
	}
}

class ASG is AST {
	also does M42::PASM::Parser::Value::ASG;
	also does M42::PASM::Parser::Op::ASG;
	also does M42::PASM::Parser::Arg::ASG;
	also does M42::PASM::Parser::Chunk::ASG;
	also does M42::PASM::Parser::Struct::ASG;
	also does M42::PASM::Parser::Label::ASG;
	also does M42::PASM::Parser::Source::ASG;
	also does M42::PASM::Parser::Regdecl::ASG;

	has $.asg = M42::PASM::ASG::World.new;
}
