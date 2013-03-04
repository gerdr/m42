use v6;

module M42::PASM::ASG;

class Chunk {
	has $.name is rw;
	has %.regs;
	has @.args;
	has @.ops;
}

class Op {
	has $.name is rw;
	has @.args;
}

class Arg {
	has $.conv is rw;
	has $.value is rw;
}

class Integer {
	has $.value is rw;
}

class Register {
	has $.name is rw;
}

class Subscript {
	has $.index is rw;
}

class IV {
	has $.type is rw;
	has $.base is rw;
	has $.offset is rw;
}

class World {
	has %.chunks;
	has $.chunk = Chunk.new;
	has $.op = Op.new;
	has $.arg = Arg.new;
	has $.int = Integer.new;
	has $.reg = Register.new;
	has $.iv = IV.new;
	has $.value = Nil;
	has $.subscript = Subscript.new;

	method push-iv {
		$!value = $!iv;
		$!iv = IV.new;
	}

	method push-subscript {
		$!iv.offset = $!subscript;
		$!subscript = Subscript.new;
	}

	method push-int {
		$!value = $!int;
		$!int = Integer.new;
	}

	method push-reg {
		$!value = $!reg;
		$!reg = Register.new;
	}

	method pop-value {
		my $value = $!value;
		$!value = Nil;
		$value;
	}

	method push-chunk {
		%!chunks{$!chunk.name} = $!chunk;
		$!chunk = Chunk.new;
	}

	method push-op {
		$!chunk.ops.push($!op);
		$!op = Op.new;
	}

	method push-arg {
		$!op.args.push($!arg);
		$!arg = Arg.new;
	}
}
