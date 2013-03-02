use v6;

class M42::PASM::ASG::Chunk;

has $.name;
has %.regs;
has %.labels;
has @.args;
has @.code;

method init($comp, $ast) {
	$!name = $ast<name>;
	self.dispatch($comp, $_) for $ast<statements>.list;
	self.validate;
	$comp.declare($!name, self);
}

method validate {
	sink for @!args.kv -> $index, $type {
		die "missing argument $index in chunk $!name"
			unless defined $type
	}
}

multi method dispatch($comp, $ (:key($) where 'reg', :value(@_))) {
	sink for @_ -> $ (:name($reg), :$type, :$init) {
		die "redeclaration of register '$reg' in chunk '$!name'"
			if $reg ~~ %!regs;

		%!regs{$reg} = $type;

		next unless defined $init;
		given $init.key {
			when 'arg' {
				my $arg = +$init.value;
				die "redeclaration of argument $arg in chunk '$!name'"
					if defined @!args[$arg];

				@!args[$arg] = $reg;
			}
		}
	}
}

multi method dispatch($comp, $ (:key($) where 'label', :value($))) {}
multi method dispatch($comp, $ (:key($) where 'op', :value($))) {}
