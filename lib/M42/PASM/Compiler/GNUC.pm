use v6;
use M42::Compiler;
use M42::PASM::Parser;

class M42::PASM::Compiler::GNUC does M42::Compiler {
	has $.grammar = M42::PASM::Parser::Grammar;
	has $.parser = M42::PASM::Parser::ASG.new;

	method dump { !!! }
}
