use v6;
use M42::Compiler;
use M42::PASM::Parser;
use pretty;

class M42::PASM::Compiler::ASG does M42::Compiler {
	has $.indent = '  ';
	has $.grammar = M42::PASM::Parser::Grammar;
	has $.parser = M42::PASM::Parser::ASG.new;

	method dump {
		say pretty(self.parser.asg.perl, :$!indent)
	}
}
