use v6;

role M42::Dumper {
	has $.indent = '  ';

	method root { !!! }

	method dump {
		self.visit(0, self.root, :root)
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

	multi method visit($depth, Int $int) {
		print "$int\n";
	}

	multi method visit($depth, @array, :$root!) {
		sink self.visit($depth, $_) for @array
	}

	multi method visit($depth, @array where !*) {
		print "[]\n"
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

	multi method visit($depth, %hash where !*) {
		print "\{\}\n"
	}

	multi method visit($depth, %hash) {
		print "\{\n";
		for %hash.pairs {
			print $!indent x ($depth + 1);
			self.visit($depth + 1, $_);
		}
		print $!indent x $depth, "\}\n";
	}

	multi method visit($depth, \arg) {
		die "\nPANIC: don't know how to dump { arg.WHAT.gist }"
	}
}
