use v6;
use panic;
use M42::PASM::Nodes;

my class Chunk is export {
	has $.name is rw;
	has %.regs;
	has @.paras;
	has %.labels;
	has @.ops;
}

my class Reg is export {
	has $.name is rw;
	has $.type is rw;
}

my class Regval is export {
	has $.name is rw;
}

my class Intval is export {
	has $.value is rw;
}

my class IV is export {
	has $.type is rw;
	has $.base is rw;
	has $.offset is rw;

	method parse($ (:$type, :$base, :$subscript)) {
		IV.new(
			type => $type,
			base => do given \$base {
				when :(:$reg) {
					Regval.new(name => $base.value)
				}
			},
			offset => do given \$subscript {
				when :(:$int) {
					Intval.new(value => +$subscript.value)
				}
				when :(:$reg) {
					Regval.new(name => $subscript.value)
				}
				default { Nil }
			}
		)
	}
}

my class Subscript is export {
	has $.index is rw;
}

my class Label is export {
	has $.name is rw;
	has $.offset is rw;
}

my class Op is export {
	has $.name is rw;
	has @.args;
}

my class Arg is export {
	has $.conv is rw;
	has $.value is rw;
}

my class World is export {
	has %.globals;
	has %.chunks;
}

class M42::PASM::Composer {
	also does M42::PASM::Nodes::Parser;

	has $.world = World.new;
	has $!chunk = Chunk.new;
	has $!op = Op.new;

	multi method compose($/, :$chunk!) {
		my $name = $chunk<name>;

		panic($<global>, "redeclaration of \@$name")
			if $name ~~ $!world.globals;

		$!chunk.name = $name;
		$!world.globals{$name} = Chunk;
		$!world.chunks{$name} = $!chunk;

		for $!chunk.labels.keys {
			my $lname = "$name.$_";
			panic($<global>, "redeclaration of \@$lname")
				if $lname ~~ $!world.globals;

			$!world.globals{$lname} = Label;
		}

		$!chunk = Chunk.new;
		:$chunk
	}

	multi method compose($/, :$op!) {
		$!op.name = $op<name>;
		$!chunk.ops.push($!op);
		$!op = Op.new;
		:$op
	}

	multi method compose($/, :$reg! (:$type, :@defs)) {
		for @defs>>.value -> $ (:$name, :$init) {
			panic($/, "redeclaration of \%$name")
				if $name ~~ $!chunk.regs;

			given \$init {
				when :(:$para) {
					my $index = $init<para>;
					panic($/, "redeclaration of \$$index")
						if defined $!chunk.paras[$index];

					$!chunk.paras[$index] = $name;
				}
			}

			$!chunk.regs{$name} = Reg.new(:$name, :$type);
		}
		:$reg
	}

	multi method compose($/, :$arg! (:$value, :$conv)) {
		given \$value {
			when :(:$reg) {
				$!op.args.push(Arg.new(
					value => Regval.new(name => $value<reg>),
					conv => $conv
				))
			}
			when :(:$iv) {
				$!op.args.push(Arg.new(
					value => IV.parse($value.value),
					conv => $conv
				))
			}
		}
		:$arg
	}

	multi method compose($/, :$label!) {
		panic($/, "redeclaration of \@.$label")
			if $label ~~ $!chunk.labels;

		$!chunk.labels{$label} = Label.new(
			name => $label,
			offset => +$!chunk.ops
		);

		:$label
	}

	multi method compose($/) {
		die %_.perl
	}
}
