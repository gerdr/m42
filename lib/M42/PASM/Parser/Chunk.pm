use v6;

module M42::PASM::Parser::Chunk;

role Grammar {
	token chunk {
		chunk \h+ <global> [
			<.sep>+
			[ <statement=.regdecl>
			| <statement=.label>
			| <statement=.op>
			]+ % <.sep>+
		]?
	}
}

role AST {
	method chunk($/) {
		make :chunk({
			name => ~$<global><name>,
			statements => [ $<statement>>>.ast ]
		}).item
	}
}

role ASG {
	method chunk($/) {
		my $name = callsame.value<name>;
		self.cry($<global>, 'global redeclaration')
			if $name ~~ self.asg.chunks;

		my $chunk = self.asg.chunk;
		for $chunk.args.kv -> $index, $type {
			self.cry($/, "missing argument $index")
				unless defined $type
		}

		$chunk.name = $name;
		self.asg.push-chunk;
	}
}
