use v6;

module M42::PASM::Parser::Regdecl;

role Grammar {
	token regdecl {
		<type> \h+ <def=.regdecl-def>+ % <.comma>
	}

	token regdecl-def {
		<register> [ \h+ '=' \h+ <init=.parameter> ]?
	}
}

role AST {
	method regdecl($/) {
		make :reg({
			type => ~$<type>,
			defs => [ $<def>>>.ast ]
		}).item
	}

	method regdecl-def($/) {
		make :def({
			name => ~$<register><name>,
			init => $<init> ?? :arg(~$<init>[0]<index>).item !! Nil
		}).item
	}
}

role ASG {
	method regdecl($/) {
		my ($type, $defs) = callsame.value<type defs>;
		my $chunk = self.asg.chunk;

		sink for $defs>>.value.list {
			my ($name, $init) = .<name init>;
			self.cry($/, 'register redeclaration')
				if $name ~~ $chunk.regs;

			$chunk.regs{$name} = $type;

			next unless defined $init;
			given $init.key {
				when 'arg' {
					my $arg = +$init.value;
					self.cry($/, 'argument redeclaration')
						if defined $chunk.args[$arg];

					$chunk.args[$arg] = $name;
				}
			}
		}
	}
}
