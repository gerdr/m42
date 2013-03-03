use v6;
use M42::PASM::Spec;

module M42::PASM::Parser::Op;

role Grammar {
	token op {
		[ <op=.op-nullary>
		| <op=.op-multary(1)>
		| <op=.op-multary(2)>
		| <op=.op-multary(3)>
		]
	}

	token op-nullary { $<name>=@(M42::PASM::Spec::ops(0)) }

	multi token op-multary($n where 1) {
		$<name>=@(M42::PASM::Spec::ops($n)) \h+ <arg>**1 % <.comma>
	}

	multi token op-multary($n where 2) {
		$<name>=@(M42::PASM::Spec::ops($n)) \h+ <arg>**2 % <.comma>
	}

	multi token op-multary($n where 3) {
		$<name>=@(M42::PASM::Spec::ops($n)) \h+ <arg>**3 % <.comma>
	}
}

role AST {
	method op($/) {
		make :op({
			name => ~$<op><name>,
			args => [ $<op><arg>>>.ast ]
		}).item
	}
}

role ASG {
	method op($/) {
		my $name = callsame.value<name>;
		self.asg.op.name = $name;
		self.asg.push-op;
	}
}
