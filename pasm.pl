use v6;
use lib '.';
use PASM::Compiler::GNUC;

sub read-source($_) { $_ => slurp($_) }

multi MAIN($dest, Bool :$gnuc!, *@sources) {
	PASM::Compiler::GNUC::compile($dest, @sources.map(&read-source))
}

multi MAIN($dest, Bool :$bytecode!, *@sources) {
	!!!
}
