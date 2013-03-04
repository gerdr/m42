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
