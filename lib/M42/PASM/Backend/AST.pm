use v6;
use M42::Compiler;
use M42::Dumper;
use M42::PASM::Grammar;
use M42::PASM::Parser;

class M42::PASM::Backend::AST {
	also does M42::Compiler;
	also does M42::Dumper;

	has $.grammar = M42::PASM::Grammar;
	has $.parser = M42::PASM::Parser.new;

	method root { self.parser.ast }
}
