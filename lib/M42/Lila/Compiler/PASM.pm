use v6;
use M42::Lila::Compiler;
class M42::Lila::Compiler::PASM does M42::Lila::Compiler;

my $PREFIX = '# generated by M42::Lila::Compiler::PASM
';

method dump {
	print $PREFIX;
}
