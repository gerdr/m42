use v6;

role M42::Compiler {
	method grammar { !!! }
	method parser { !!! }

	method compile($dest, *@sources) {
		self.parse($_, slurp($_)) for @sources;
		temp $*OUT = open($dest, :w);
		self.dump;
		$*OUT.close;
	}

	method parse($source, $code) {
		self.grammar.parse($code, :actions(self.parser))
		# CATCH {}
	}

	method dump { !!! }
}

role M42::Compiler::AST does M42::Compiler {
	has $.indent = '  ';

	method dump {
		self.visit(0, self.parser.ast, :root)
	}

	multi method visit($depth, Nil) {
		print "?\n"
	}

	multi method visit($depth, Bool $bool) {
		print "{ $bool ?? '#t' !! '#f' }\n"
	}

	multi method visit($depth, Pair $ (:$key, :$value)) {
		print "$key: ";
		self.visit($depth, $value);
	}

	multi method visit($depth, Str $str) {
		print "'$str'\n";
	}

	multi method visit($depth, @array, :$root!) {
		sink self.visit($depth, $_) for @array
	}

	multi method visit($depth, @array) {
		print "[\n";
		for @array {
			print $!indent x ($depth + 1);
			self.visit($depth + 1, $_);
		}
		print $!indent x $depth, "]\n";
	}

	multi method visit($depth, %hash, :$root!) {
		sink self.visit($depth, $_) for %hash.pairs
	}

	multi method visit($depth, %hash) {
		print "\{\n";
		for %hash.pairs {
			print $!indent x ($depth + 1);
			self.visit($depth + 1, $_);
		}
		print $!indent x $depth, "\}\n";
	}
}
