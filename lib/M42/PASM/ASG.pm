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

class DV {
	has $.type is rw;
	has $.value is rw;
}

class IV {}

class World {
	has %.chunks;
	has $.chunk = Chunk.new;
	has $.op = Op.new;
	has $.arg = Arg.new;
	has $.dv = DV.new;
	has $.iv = IV.new;
	has $.value = Nil;

	method push-iv {
		$!value = $!iv;
		$!iv = IV.new;
	}

	method push-dv {
		$!value = $!dv;
		$!dv = DV.new;
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
