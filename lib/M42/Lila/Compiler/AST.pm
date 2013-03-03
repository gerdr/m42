use v6;
use M42::Compiler;
#use M42::Lila::Parser;

class M42::Lila::Compiler::AST does M42::Compiler::AST {
	has $.grammar;
	has $.parser;
}
