use v6;
use M42::Compiler;
use M42::PASM::Parser;

class M42::PASM::Compiler::AST does M42::Compiler::AST {
	has $.grammar = M42::PASM::Parser::Grammar;
	has $.parser = M42::PASM::Parser::AST.new;
}
