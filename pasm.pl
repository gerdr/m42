use v6;
use lib '.';
use PASM::Compiler::GNUC;

multi MAIN($dest, Bool :$gnuc!, *@sources) {
	PASM::Compiler::GNUC.new.compile($dest, @sources)
}

multi MAIN($dest, Bool :$bytecode!, *@sources) {
	!!!
}
