use v6;

module M42::PASM::Node::Value;

role Grammar {
	token value {
		[ <value=.value-indirect>
		| <value=.value-register>
		| <value=.value-integer>
		]
	}

	token value-indirect {
		<type> '(' \h*
			<base=.value-base>
			<subscript=.value-subscript>?
		\h*')'
	}

	token value-base {
		<register=.value-register>
	}

	token value-subscript {
		'[' \h*
		[ <index=.value-integer>
		| <index=.value-register>
		]
		\h* ']'
	}

	token value-register {
		<register>
	}

	token value-integer {
		<integer>
	}
}

role Parser {
	method value($/) {
		make $<value>.ast
	}

	method value-indirect($/) {
		make :iv({
			type => ~$<type>,
			base => $<base>.ast,
			subscript => $<subscript> ?? $<subscript>[0].ast !! Nil
		}).item
	}

	method value-base($/) {
		make $<register>.ast
	}

	method value-subscript($/) {
		make $<index>.ast
	}

	method value-register($/) {
		make :register(~$<register><name>).item
	}

	method value-integer($/) {
		make :integer(~$<integer>).item
	}
}

#role ASG {
#	method value-indirect($/) {
#		my $type = callsame.value<type>;
#		my $iv = self.asg.iv;
#		$iv.type = $type;
#		$iv.offset //= Nil;
#		self.asg.push-iv;
#	}
#
#	method value-base($/) {
#		callsame;
#		self.asg.iv.base = self.asg.pop-value
#	}
#
#	method value-subscript($/) {
#		callsame;
#		self.asg.subscript.index = self.asg.pop-value;
#		self.asg.push-subscript;
#	}
#
#	method value-integer($/) {
#		my $value = callsame.value;
#		my $int = self.asg.int;
#		$int.value = +$value;
#		self.asg.push-int;
#	}
#
#	method value-register($/) {
#		my $name = callsame.value;
#		self.cry($/, "unknown register")
#			unless $name ~~ self.asg.chunk.regs;
#
#		my $reg = self.asg.reg;
#		$reg.name = $name;
#		self.asg.push-reg;
#	}
#}
