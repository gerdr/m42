use v6;
use M42::PASM::Node::Arg;
use M42::PASM::Node::Chunk;
use M42::PASM::Node::Label;
use M42::PASM::Node::Op;
use M42::PASM::Node::Regdecl;
use M42::PASM::Node::Source;
use M42::PASM::Node::Struct;
use M42::PASM::Node::Value;

module M42::PASM::Nodes;

role Grammar {
	also does M42::PASM::Node::Arg::Grammar;
	also does M42::PASM::Node::Chunk::Grammar;
	also does M42::PASM::Node::Label::Grammar;
	also does M42::PASM::Node::Op::Grammar;
	also does M42::PASM::Node::Regdecl::Grammar;
	also does M42::PASM::Node::Source::Grammar;
	also does M42::PASM::Node::Struct::Grammar;
	also does M42::PASM::Node::Value::Grammar;
}

role Parser {
	also does M42::PASM::Node::Arg::Parser;
	also does M42::PASM::Node::Chunk::Parser;
	also does M42::PASM::Node::Label::Parser;
	also does M42::PASM::Node::Op::Parser;
	also does M42::PASM::Node::Regdecl::Parser;
	also does M42::PASM::Node::Source::Parser;
	also does M42::PASM::Node::Struct::Parser;
	also does M42::PASM::Node::Value::Parser;
}
