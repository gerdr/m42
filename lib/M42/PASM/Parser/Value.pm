use v6;

module M42::PASM::Parser::Value;

role Grammar {
	token value {
		[ <value=.value-indirect>
		| <value=.value-register>
		| <value=.value-integer>
		]
	}

	token value-indirect {
		<type> '(' \h* <register> [ '[' \h*
		[ <index=.value-integer>
		| <index=.value-register>
		]
		\h* ']' ]? \h*')'
	}

	token value-register {
		<register>
	}

	token value-integer {
		<integer>
	}
}

role AST {
	method value($/) {
		make $<value>.ast
	}

	method value-indirect($/) {
		make :iv({
			type => ~$<type>,
			base => ~$<register><name>,
			index => $<index> ?? $<index>[0].ast !! Nil,
			multi => :sizeof(~$<type>).item
		}).item
	}

	method value-register($/) {
		make :register(~$<register><name>).item
	}

	method value-integer($/) {
		make :integer(~$<integer>).item
	}
}

role ASG {
	method value-integer($/) {
		my $int = callsame.value;
		my $dv = self.asg.dv;
		$dv.type = 'integer';
		$dv.value = +$int;
		self.asg.push-dv;
	}

	method value-register($/) {
		my $reg = callsame.value;
		self.cry($/, "unknown register")
			unless $reg ~~ self.asg.chunk.regs;

		my $dv = self.asg.dv;
		$dv.type = 'register';
		$dv.value = $reg;
		self.asg.push-dv;
	}

	method value-indirect($/) {
		my $value = callsame.value;
		my $iv = self.asg.iv;
		# TODO
		self.asg.push-iv;
	}
}
