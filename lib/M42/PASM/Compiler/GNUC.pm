use v6;
use M42::PASM::Compiler;

class M42::PASM::Compiler::GNUC does M42::PASM::Compiler;

method dump {
	say @.globals.perl
}
