use v6;
use M42::PASM;

module M42::PASM::Parser::Op;

role Grammar {
	token op {
		[ <op=.op-nullary>
		| <op=.op-multary(1)>
		| <op=.op-multary(2)>
		| <op=.op-multary(3)>
		]
	}

	token op-nullary { $<name>=@(M42::PASM::ops(0)) }

	multi token op-multary($n where 1) {
		$<name>=@(M42::PASM::ops($n)) \h+ <arg=.op-arg>**1 % <.comma>
	}

	multi token op-multary($n where 2) {
		$<name>=@(M42::PASM::ops($n)) \h+ <arg=.op-arg>**2 % <.comma>
	}

	multi token op-multary($n where 3) {
		$<name>=@(M42::PASM::ops($n)) \h+ <arg=.op-arg>**3 % <.comma>
	}

	token op-arg { <conv=.op-conv>? <value> }

	token op-conv { sx | zx | tr | fx | ft }
}

role Actions {
	method op($/) {
		make :op({
			name => ~$<op><name>,
			args => [ $<op><arg>>>.ast ]
		}).item
	}

	method op-arg($/) {
		make {
			value => $<value>.ast,
			conv => $<conv> ?? ~$<conv> !! Nil
		}
	}
}
