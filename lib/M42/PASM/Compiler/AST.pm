use v6;
use M42::PASM::Compiler;

class M42::PASM::Compiler::AST does M42::PASM::Compiler;

my $indent = '  ';

method analyze {}
method dump { dump(0, self.ast) }

multi dump($depth, Nil) {
	print "?\n"
}

multi dump($depth, Bool $bool) {
	print "{ $bool ?? '#t' !! '#f' }\n"
}

multi dump($depth, Pair $ (:$key, :$value)) {
	print "$key: ";
	dump($depth, $value);
}

multi dump($depth, Str $str) {
	print "'$str'\n";
}

multi dump($depth, @array) {
	print "[\n";
	for @array {
		print $indent x ($depth + 1);
		dump($depth + 1, $_);
	}
	print $indent x $depth, "]\n";
}

multi dump($depth, %hash) {
	print "\{\n";
	for %hash.pairs {
		print $indent x ($depth + 1);
		dump($depth + 1, $_);
	}
	print $indent x $depth, "\}\n";
}
