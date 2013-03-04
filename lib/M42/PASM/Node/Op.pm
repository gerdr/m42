use v6;
use M42::PASM::Spec;

module M42::PASM::Node::Op;

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

role Parser {
	method op($/) {
		make self.compose($/, op => {
			name => ~$<op><name>,
			args => [ $<op><arg>>>.ast ]
		})
	}
}
